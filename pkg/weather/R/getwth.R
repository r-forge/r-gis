# Author: Robert J. Hijmans
# License GPL3
# Version 1.0  December 2012


.getWthFile <- function(filename, type='NASA') {
	if (type=='NASA') {
		return(.getWthFileNASA(filename))
	}
}

getWthPower <- function(lon, lat, overwrite=FALSE, tile=FALSE, folder=getwd(), quiet, ...) {
	r <- raster()
	cell <- cellFromXY(r, c(lon, lat))
	if (is.na(cell)) {	stop("invalid coordinates") }
	
	folder <- paste(folder, '/power', sep='')
	dir.create(folder, FALSE, TRUE)
	
	dots <- list(...)
	source <- dots@source
	if (is.null(source)) { source <- 'davis' }
	source <- tolower(source)
	filename <- paste(folder, "/power_", cell, ".wth", sep="")
	xy <- xyFromCell(r, cell)
	lon <- xy[1]
	lat <- xy[2]
	
	if (!file.exists(filename) | overwrite) {

		if (tile) {
			i <- cellFromXY(aggregate(raster(), 30), c(lon, lat))
			theurl <- paste("http://biogeo.ucdavis.edu/data/climate/power/tile", i, ".zip" , sep='')
			filename <- paste(folder, "/tile_", i, ".zip", sep="")
			if (! file.exists(filename)) {
				if (missing(quiet)) { quiet <- FALSE }
				download.file(url=theurl, destfile=filename, method="auto", quiet=quiet, mode = "wb")
			}
			unzip(filename, exdir=folder)
		}

		if (missing(quiet)) { quiet <- TRUE }
	
		if (source == 'davis') {
			theurl <- paste("http://biogeo.ucdavis.edu/data/climate/power/pow", cell, ".txt" , sep='')
			download.file(url=theurl, destfile=filename, method="auto", quiet=quiet, mode="wb", cacheOK=TRUE)
		} else {
			vars <- c("swv_dwn", "T2M", "T2MN", "T2MX", "RH2M", "RAIN")
			d <- as.Date(Sys.time())
			eday <- dayFromDate(d)
			emon <- monthFromDate(d)
			eyr <- yearFromDate(d)
			part1 <- "http://earth-www.larc.nasa.gov/cgi-bin/cgiwrap/solar/agro.cgi?email=agroclim%40larc.nasa.gov&step=1&lat="
			part2 <- paste(lat, "&lon=", lon, "&sitelev=&ms=1&ds=1&ys=1983&me=", emon, "&de=", eday, "&ye=", eyr, sep="")
			part3 <- paste("&p=", vars, sep='', collapse='')
			part3 <- paste(part3, "&submit=Submit", sep="")
			theurl <- paste(part1, part2, part3, sep="")
			f <- tempfile()
			download.file(url=theurl, destfile=f, method="auto", quiet=quiet, mode="wb", cacheOK=TRUE)
			v <- .getWthFileNASA(f)
			file.remove(f)
			save(v, file=filename)
		 }
	}
	
	if (file.exists(filename)) {
        env <- new.env()
        d <- get(load(filename, env), env)
		if (is.null(d$rhmin)) {
			rhnx <- rhMinMax(d) 
			vapr <- d$relh * .SVP(d$tmp) / 1000     # 100 for % and 10 to go from hPa to kPa
			rh <- cbind(d$relh, rhnx, vapr)
			colnames(rh) <- c("rh", "rhmin", "rhmax", "vapr")
			i <- which(colnames(d) == 'relh')
			d <- cbind(d[, -i], rh)
		}
		alt <- attr(d, 'alt')
		attr(d, 'alt') <- NULL
		elevation <- NA
		if (!is.null(alt)) {
			try(elevation <- as.numeric(alt), silent=TRUE)
		}
		w <- new('Weather')
		w@values <- d
		w@locations <- data.frame(longitude=lon, latitude=lat, elevation=elevation, name='Power', stringsAsFactors=FALSE)
        return(w)
    } else {
		stop('could not do it')
	}

}



.ICASAstyle <- function(lns) {

	lns <- lns[10:(length(lns)-1)]
	lns <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns))  , " ")
	lns <- data.frame(matrix(as.numeric(unlist(lns)), ncol=length(lns[[1]]), byrow=T))
	#colnames(lns) <- h2[[1]]
	lns <- lns[,-1]
	colnames(lns) <- c("year", "doy", "srad", "tmax", "tmin", "prec", "wind", "tdew", "tmp", "relh")

	#rhnx <- rhMinMax(lns[,'relh'], lns[,'tmin'], lns[,'tmax'], lns[,'tmp']) 
	#vapr <- lns[,'relh'] * .SVP(lns[,'tmp']) / 1000     # 100 for % and 10 to go from hPa to kPa
	#lns <- cbind(lns, rhnx, vapr)
	
	date <- dateFromDoy(lns[,'doy'], lns[,'year'])
	#lns <- cbind(as.data.frame(date), lns)
	lns[,-c(1:2)]
}

.getWthFileNASA <- function(filename) {

	lns <- readLines(filename)
	hdr <- lns[1:30]
	end <- which(hdr=="@ WEYR WEDAY  SRAD   TMAX   TMIN   RAIN   WIND   TDEW    T2M   RH2M")

	if (length(end) > 0) {
		h <- which(hdr == "@ INSI   WTHLAT   WTHLONG  WELEV   TAV   AMP  REFHT  WNDHT") + 1
		h1 <- hdr[h]
		y <- as.numeric(substr(h1, 9, 15))
		x <- as.numeric(substr(h1, 18, 25))
		alt <- as.numeric(substr(h1, 27, 32))

		h2 <- lns[end]
		h2 <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", h2))  , " ")
		end2 <- which(lns=="</PRE></BODY></HTML>") - 1
		
		lns <- trim( lns[ c((end+1):end2) ] )
	
		lns <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns))  , " ")
		v <- unlist(lns)
		
		v <- as.numeric(v)
		v[v == -99] <- NA
		v <- data.frame(matrix(v, ncol=length(lns[[1]]), byrow=T))

		colnames(v) <- c("year", "doy", "srad", "tmax", "tmin", "prec", "wind", "tdew", "tmp", "relh")	
		
	} else {

		end <- which(hdr=="-END HEADER-")
		if (end != 18) { warning('strange file') }
		
		hdr <- hdr[1:end]
		loc <- which(substr(hdr, 1, 9)=='Location:')
		loc <- substr(hdr[loc], 11, 100)
		loc <- unlist(strsplit(loc, "   "))
		loc <- unlist(strsplit(loc, " "))
		x <- as.numeric(loc[2])
		y <- as.numeric(loc[4])
		alt <- hdr[which(substr(hdr, 1, 9)=='Elevation')]
		alt <- as.numeric(unlist(strsplit(alt, "="))[2])
		
		lns <- lns[-c(1:end)]
		lns <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns))  , " ")
		v <- unlist(lns)
		v[v=="-"] <- NA
		v <- data.frame(matrix(as.numeric(v), ncol=length(lns[[1]]), byrow=T))

		nicevars <- c("year", "doy", "srad", "tmp", "tmin", "tmax", "relh", "prec")
		colnames(v) <- nicevars
	}
	
	rhnx <- rhMinMax2(v) 
	vapr <- v$relh * .SVP(v$tmp) / 1000     # 100 for % and 10 to go from hPa to kPa
	rh <- cbind(v$relh, rhnx, vapr)
	colnames(rh) <- c("rh", "rhmin", "rhmax", "vapr")
	i <- which(colnames(v) == 'relh')
	v <- cbind(v[, -i], rh)
	return(v)
	
#date <- dateFromDoy(v[,'doy'], v[,'year'])

#	r <- raster()
#	cell <- cellFromXY(r, c(x, y))
#	v <- v[, -c(1:2)]
#	makeWeather(cell, x, y, alt, date, v)
}

