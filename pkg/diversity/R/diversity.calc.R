
diversity.internal.checkdata <- function(x) {
	if (length(x) > 0) {
		if (!is.vector(x)) {
			print(x)
			print(class(x))
			stop('input should be a vector')
		}
		if (is.numeric(x)) {x <- round(x)}
		x <- x[!is.na(x)]
	}	
	return(x)
}	


diversity.index.nobservations <- function(x) {
	x <- diversity.internal.checkdata(x)
	return(length((x)))
}	

diversity.index.richness <- function(x) {
	x <- diversity.internal.checkdata(x)
	return(length(unique(x))) 
}

diversity.index.presenceabsence <- function(x, species) {
	x <- diversity.internal.checkdata(x)
	if (is.numeric(species)) { species <- round(species)}
	if (length(which(x==species)) > 0) { 
		return(TRUE) 
	} else {return(FALSE) }
}

diversity.index.shannon <- function(x) {
#   H(i) := sum((-P(i) * ln P(i))
#   P(i) = the Proportion of objects in the i-th class
	if (length(x) > 0) {
		x <- diversity.internal.checkdata(x)
		spp <- as.matrix(table(x)) / length(x)
		H <- -1 * spp * log(spp) 	
		return(sum(H))
	} else { return(NA) } 	
}

diversity.index.margalef <- function(x) {
#    //Margalef. S: Number of species. N: Number of individuals in the S species.
	x <- diversity.internal.checkdata(x)
	S <- length(unique(x))
	N <- length(x)
	return((S-1)/log(N))
}

diversity.index.menhinick <- function(x) {
	x <- diversity.internal.checkdata(x)
	S <- length(unique(x))
	N <- length(x)
	return((S)/sqrt(N))
}


diversity.index.simpson <- function(x) {
	x <- diversity.internal.checkdata(x)
	spp <- as.matrix(table(x)) / length(x)
	return(sum(spp^2))
}

diversity.index.simpson2 <- function(x) {
#Simpson's index, D = sum( n(i)*(n(i)-1) / N*(N-1) )
#n(i) = number of objects in i-th class (species)
#N = total number of objects}
	x <- diversity.internal.checkdata(x)
	spp <- as.matrix(table(x)) 
	obs <- length(x)
	n <- spp * (spp - 1)
	N <- obs * (obs - 1)
	return(sum(n/N))
}

diversity.index.brillouin <- function(x) {
	x <- diversity.internal.checkdata(x)
	spp <- as.matrix(table(x)) / length(x)
	obs <- length(x)
	small <- which(spp < 150) 
    big <- which(spp >= 150)
	f <- vector('numeric', length=length(spp))
	f[small] <- log(factorial(spp[small]))
# Stirling's approximation ln(x!) = x.ln(x) - x */
	f[big] <- spp[big] * log(spp[big]) - spp[big]
	if (obs < 150)  {n <- log(factorial(obs)) 
	} else { n <- obs * log(obs) - obs }
	HB <- (n - sum(f)) / obs
	return(HB)
}	
	

diversity.index.renyi <- function(x, alpha) {
	x <- diversity.internal.checkdata(x)
	spp <- as.vector(table(x)) / length(x)
	spp <- spp^alpha
	reyni <- (1 / (1-alpha) ) * log(sum(spp))
	return(reyni)
}
	

   
diversity.estimator.chao <- function(x) {
	x <- diversity.internal.checkdata(x)
	spp <- as.vector(table(x))
	Sobs <- length(spp)
	singles <- length(spp[spp==1])
	doubles <- length(spp[spp==2])
	chao <- Sobs + singles^2/(2*doubles)
	return(chao)
}


diversity.reserve.rebelo <- function(xy) {
	xy[is.na(xy)] <- 0
	xy <- round(xy)
	xy[xy<0] <- 0
	xy[xy>0] <- 1
	nspecies <- length(xy[,1])
	nsites <- length(xy[1,])
	res <- matrix(ncol=2, nrow=nsites)
	for (i in 1:nsites) {
		sitesppcount <- colSums(xy)
		nsp <- max(sitesppcount)
		if (nsp == 0) {break}
		selsite <- which(sitesppcount == nsp)[1]
		res[i,1] <- selsite
		res[i,2] <- nsp
		delspp <- as.vector(which(xy[,selsite]==1))
		xy[delspp,] <- 0
	}
	colnames(res) <- c("Site", "nSpecies")
	return(res[1:(i-1),])
}

	
diversity.point.to.raster <- function(rs, filename, xya, fun=diversity.index.richness) {
	xya <- xya[,1:3]
	rsout <- set.filename(rs, filename)
	cells <- get.cell.from.xy(rs, xya[,1:2])
	rows <- get.row.from.cell(rs, cells)
	cols <- get.col.from.cell(rs, cells)
	xyarc <- cbind(xya, rows, cols)
	urows <- unique(rows)
	urows <- urows[order(urows)]
	allrows <- seq(1:rs@nrows)
	allrows <- cbind(allrows, FALSE)
	allrows[urows, 2] <- TRUE
	d <- vector(length=rs@ncols)
	d[!is.na(d)] <- NA
	dna <- d
	for (r in 1 : rs@nrows) {
		if (!allrows[r, 2]) {	
			rsout <- set.values.row(rsout, dna, r)
			rsout <- write.row(rsout) 
		}
		else {
			dd <- subset(xyarc, xyarc[,4] == r)
			cols <- dd[,5]
			ucols <- unique(cols)
			ucols <- ucols[order(ucols)]
			d <- dna
			for (c in 1:length(ucols)) {
				ddd <- subset(dd, dd[,5] == ucols[c] )
				d[ucols[c]] <- fun(ddd)	
			}
			rsout <- set.values.row(rsout, d, r)
			rsout <- write.row(rsout)
		}	
	}	
	return(rsout)
}

   