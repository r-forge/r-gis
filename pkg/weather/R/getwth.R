# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.2  August 2012


getWthFile <- function(filename, type='NASA') {
	if (type=='NASA') {
		return(.getWthFileNASA(filename))
	}
}

getWthXY <- function(lon, lat, start="1983-1-1", end="2012-12-31", overwrite=FALSE) {
	sday <- dayFromDate(start)
	smon <- monthFromDate(start)
	syr <- yearFromDate(start)
	eday <- dayFromDate(end)
	emon <- monthFromDate(end)
	eyr <- yearFromDate(end)

	r <- raster()
	cell <- cellFromXY(r, c(lon, lat))
	if (is.na(cell)) {
		stop("invalid coordinates")
	} 
	filename <- paste("daily_weather_", cell, ".nasa", sep="")

	vars <- c("swv_dwn", "T2M", "T2MN", "T2MX", "RH2M", "RAIN")

	xy <- xyFromCell(r, cell)
	lon <- xy[1]
	lat <- xy[2]

	if (!file.exists(filename) | overwrite) {
		part1 <- "http://earth-www.larc.nasa.gov/cgi-bin/cgiwrap/solar/agro.cgi?email=agroclim%40larc.nasa.gov&step=1&lat="
		part2 <- paste(lat, "&lon=", lon, "&sitelev=&ms=", smon, "&ds=", sday, "&ys=", syr, "&me=", emon, "&de=", eday, "&ye=", eyr, sep="")
		part3 <- ''
		for (i in 1:length(vars)) {
			part3 <- paste(part3, "&p=", vars[i], sep="")
		}
		part3 <- paste(part3, "&submit=Submit", sep="")
		theurl <- paste(part1, part2, part3, sep="")
		download.file(url=theurl, destfile=filename, method="auto", quiet = FALSE, mode = "wb", cacheOK = TRUE)
	}
	
	return(.getWthFileNASA(filename))
}



.ICASAstyle <- function(lns) {

	lns <- lns[10:(length(lns)-1)]
	lns <- strsplit ( gsub("[[:space:]]+", " ", gsub("[[:space:]]+$", "", lns))  , " ")
	lns <- data.frame(matrix(as.numeric(unlist(lns)), ncol=length(lns[[1]]), byrow=T))
	#colnames(lns) <- h2[[1]]
	lns <- lns[,-1]
	colnames(lns) <- c("year", "doy", "srad", "tmax", "tmin", "prec", "wind", "tdew", "tavg", "relh")

	#rhnx <- rhMinMax(lns[,'relh'], lns[,'tmin'], lns[,'tmax'], lns[,'tavg']) 
	#vapr <- lns[,'relh'] * SVP(lns[,'tavg']) / 1000     # 100 for % and 10 to go from hPa to kPa
	#lns <- cbind(lns, rhnx, vapr)
	
	date <- dateFromDoy(lns[,'doy'], lns[,'year'])
	#lns <- cbind(as.data.frame(date), lns)
	lns <- lns[,-c(1:2)]

	r <- raster()
	cell <- cellFromXY(r, c(x, y))
	
	makeWeather(cell, x, y, alt, date, lns)
	#@ WEYR WEDAY  SRAD   TMAX   TMIN   RAIN   WIND   TDEW    T2M   RH2M
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

		colnames(v) <- c("year", "doy", "srad", "tmax", "tmin", "prec", "wind", "tdew", "tavg", "relh")
	
		date <- dateFromDoy(v[,'doy'], v[,'year'])
		#lns <- cbind(as.data.frame(date), lns)
		v <- v[,-c(1:2)]

		r <- raster()
		cell <- cellFromXY(r, c(x, y))
	
		return( makeWeather(cell, x, y, alt, date, v) )

	}

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

	nicevars <- c("year", "doy", "srad", "tavg", "tmin", "tmax", "relh", "prec")
	colnames(v) <- nicevars
	## rhnx <- rhMinMax(lns[,'relh'], lns[,'tmin'], lns[,'tmax'], lns[,'tavg']) 
	## vapr <- lns[,'relh'] * SVP(lns[,'tavg']) / 1000     # 100 for % and 10 to go from hPa to kPa
	##	lns <- cbind(lns, rhnx, vapr)
	
	date <- dateFromDoy(v[,'doy'], v[,'year'])

	r <- raster()
	cell <- cellFromXY(r, c(x, y))
	
	v <- v[, -c(1:2)]
	makeWeather(cell, x, y, alt, date, v)
}

