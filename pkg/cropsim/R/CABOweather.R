
.yearFromDate <- function(date) {
	as.numeric(format(as.Date(date), "%Y"))
}

writeCABOwth <- function(wth, lon, lat, alt, path=getwd(), rainfact=1, tempfact=0) {
	
#	wth[is.na(wth)] <- -9999
	wth$yr <- .yearFromDate(wth$day)
	syear <- min(wth$yr)
	eyear <- max(wth$yr)

	for (year in syear:eyear) {
		fname <- paste(path, '/AA1.', substr(year, 2, 4), sep="")
		thefile <- file(fname, "w")
		
		cat("*-----------------------------------------------------------", "\n", file = thefile)
#		cat("*  Cell number: ",cell, "\n", file = thefile)
#		cat("*", "\n", file = thefile)
		cat("*  Created by R-simmodels", "\n", file = thefile)
		cat("*", "\n", file = thefile)
		cat("*  Column    Daily Value", "\n", file = thefile)
		cat("*     1      Station number", "\n", file = thefile)
		cat("*     2      Year", "\n", file = thefile)
		cat("*     3      Day", "\n", file = thefile)
		cat("*     4      irradiance         KJ m-2 d-1", "\n", file = thefile)
		cat("*     5      min temperature            oC", "\n", file = thefile)
		cat("*     6      max temperature            oC", "\n", file = thefile)
		cat("*     7      vapor pressure            kPa", "\n", file = thefile)
		cat("*     8      mean wind speed         m s-1", "\n", file = thefile)
		cat("*     9      precipitation          mm d-1", "\n", file = thefile)
		cat("*", "\n", file = thefile)
		cat("** WCCDESCRIPTION=gizmo", "\n", file = thefile)
		cat("** WCCFORMAT=2", "\n", file = thefile)
		cat("** WCCYEARNR=", year, "\n", file = thefile)
		cat("*-----------------------------------------------------------", "\n", file = thefile)
		if ( lat > 60) { lat <- 59 }
		if ( lat < -60 ) { lat <- -59 }
		cat(lon, lat, alt, '  0.00  0.00', "\n", file = thefile)

		yw <- subset(wth, wth$yr==year)
		for (d in 1:length(yw[,1])) {
			wind <- 2.5;
			rad <- yw$srad[d] * 1000
			tmin <- yw$tmin[d] + tempfact
			tmax <- yw$tmax[d] + tempfact;
			rh <- yw$relh[d]
			tavg <- (tmin + tmax)/2;
			SVP <- 6.5 * exp((tavg / 16.1)); #  [T in deg C; or another empirical function]
			vapr <- rh * SVP / 1000 ; #   100 for % and 10 to go from hPa to kPa
			prec <- yw$prec[d] * rainfact;
#			cat(txtf, 1, y:6, inttostr(i):5, rad:10:0, tmin:8:1, tmax:8:1, vapr:8:1, wind:8:1, prec:8:1);
			cat("1  ", sprintf("%6.0f", year), sprintf("%5.0f", d), sprintf("%10.0f", rad), sprintf("%8.1f", tmin), sprintf("%8.1f", tmax), sprintf("%8.1f", vapr), sprintf("%8.1f", wind), sprintf("%8.1f", prec), "\n", file=thefile)
		}
		
		close(thefile)
    }
	return(TRUE)
}		
