
model.niche.generate.absence <- function(rasterstack, prescells, npoints = (length(prescells[,1] * 5)), bboxfact=0.1) {
# stub function
	presence <- get.xy.from.cell(rasterstack, prescells)
	xmin <- min(presence[,1])
	xmax <- max(presence[,1])
	ymin <- min(presence[,2])
	ymax <- max(presence[,2])
	xrange <- xmax - xmin
	yrange <- ymax - ymin
	xmin <- xmin - bboxfact * xrange
	xmax <- xmax + bboxfact * xrange
	ymin <- ymin - bboxfact * yrange
	ymax <- ymax + bboxfact * yrange
	
	n <- npoints * 3
	x <- runif(n, min=xmin, max=xmax)
	y <- runif(n, min=ymin, max=ymax)
	xy <- cbind(x, y)
	cells <- get.cell.from.xy(rasterstack, xy)
	cells <- unique(na.omit(cells))
	
	absvals <- values.cell(rasterstack, cells)
	absvals <- na.omit(absvals)
	if (length(absvals[,1]) > npoints) { absvals <- absvals[1:npoints,]	
	} else {
		frac <- length(absvals[,1]) / npoints
		warning(paste("generated absence points =", frac,"times requested number" ))
	}
	return(absvals)
}


model.niche.read.values.presence <- function(rasterstack, presence) {
	cell <- na.omit(presence)
	if (length(cell) < length(presence[,1])) {
		frac <- length(presence[,1]) / length(cell)
		warning(paste("presence points on grid=", frac,"times total" )) 
	}
	ucells <- unique(cell)
	if (length(ucells) < length(cell)) {
		frac <- length(ucells) < length(cell)
		warning(paste("unique presence cells=", frac,"times total" )) 
	}
	rm(cell)
	vals <- values.cell(rasterstack, ucells[,2])
	vals <- na.omit(vals)
	if (length(vals[,1]) < length(ucells)) {
		frac <- length(vals[,1]) / length(ucells)
		warning(paste("presence cells with values=", frac,"times total unique cells" )) 
	}
	if (length(vals[,1]) < 3) { stop("too few presence points") }
	return(vals)
}


model.niche.read.values.absence <- function(rasterstack, absence) {
	cells <- get.cell.from.xy(rasterstack, absence) 
	cells <- na.omit(cells)
	if (length(cells) < length(absence[,1])) {
		frac <- length(cells) / length(absence[,1])
		warning(paste("provided absence points on grid=", frac,"times total" )) 
	}		

	ucells <- unique(cells)
	if (length(ucells) < length(cells)) {
		frac <- length(ucells) < length(cells)
		warning(paste("unique absence cells=", frac,"times total" )) 
	}
		
	vals <- values.cell(rasterstack, ucells)
	vals <- na.omit(vals)
	if (length(vals[,1]) < length(ucells)) {
		frac <- length(vals[,1]) / length(ucells)
		warning(paste("absence cells with values=", frac,"times total unique cells" )) 
	}
	return(vals)
}



model.niche.presence.absence.fit <- function(rasterstack, model, presence, absence=NA, testsample=0.2, abssize=5, absbboxfact=0.1) {
# models that use absence data, either supplied or generated
	cell <- get.cell.from.xy(rasterstack, presence)
	id <- seq(1:length(cell))
	cell <- cbind(id, cell)
	prsvals <- model.niche.read.values.presence(rasterstack, cell) 

	if (is.na(absence)) { absvals <- model.niche.generate.absence(rasterstack, prsvals[,1], npoints=(abssize * length(prsvals[,1])), bboxfact=absbboxfact) 
	} else { absvals <- model.niche.read.values.absence(rasterstack, absence) }

	testsample  <- max(0, min(1, testsample))
	if (testsample > 0.01) { 
		threshold <- round(testsample * length(prsvals[,1]))
		randnr <- runif(n=length(prsvals[,1]), 1, 1000)
		randcells <- cbind(randnr, prsvals[,1])
		randcells <- randcells[order(randcells[,1]),]
		traincells <- randcells[(threshold+1):(length(randcells[,1])), 2]
		testcells <- randcells[1:threshold, 2]
		prstrain <- subset(prsvals, prsvals[,1] %in% traincells)
		prstest <- subset(prsvals, prsvals[,1] %in% testcells)
		
		threshold <- round(testsample * length(absvals[,1]))
		randnr <- runif(n=length(absvals[,1]), 1, 1000)
		randcells <- cbind(randnr, absvals[,1])
		randcells <- randcells[order(randcells[,1]),]
		traincells <- randcells[(threshold+1):(length(randcells[,1])), 2]
		testcells <- randcells[1:threshold, 2]
		abstrain <- subset(absvals, absvals[,1] %in% traincells)
		abstest <- subset(absvals, absvals[,1] %in% testcells)
		test <- TRUE
	}
	else {  
		prstrain <- prsvals
		prstest <- NA
		abstrain <- absvals
		abstest <- NA
		test <- FALSE
	}
	rm(prsvals)
	rm(absvals)

	prsabs <- 1
	prstrain <- cbind(prsabs, prstrain)
	prstest <- cbind(prsabs, prstest)
	prsabs <- 0
	abstrain <-  cbind(prsabs, abstrain)
	abstest <-  cbind(prsabs, abstest)
	trainvals <- rbind(prstrain, abstrain)[-2]
	testvals <- rbind(prstest, abstest)[-2]

#	nichemodel <- model.niche.randomforest.fit(trainvals)
#	return(nichemodel)
	
}



model.niche.presence.fit <- function(presence, rasterstack, model, haveabsence=FALSE, absenceopt="") {
# truly "presence only models" such as bioclim and domain


}



model.niche.predict <- function(nicheobject, filename) {



}

model.niche.randomforest.fit <- function(presabs) {


}


model.niche.domain.fit <- function(presence, rasterstack) {
	domain$presence <- presence
	domain$rasterstack <- rasterstack
}


model.niche.domain.predict <- function(domainmodel) {
	

}

