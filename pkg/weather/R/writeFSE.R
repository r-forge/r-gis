# Author: Robert J. Hijmans
# License GPL3


writeFSE <- function(w, country='AAA', station=1, wind=2.5,  path=getwd(), ... ) {
	
#	w@values$srad <- w@values$srad * 1000
#	w@values$tmin <- w@values$tmin + tempfact
#	w@values$tmax <- w@values$tmax + tempfact
#	w@values$prec <- w@values$prec * rainfact
	year <- yearFromDate(w@values$date)
	lon <- w@locations$longitude
	lat <- w@locations$latitude
	alt <- w@locations$elevation
	
	years <- unique(year)
	for (yr in years) {
		fname <- paste(path, '/', country, station, '.', substr(yr, 2, 4), sep="")
		thefile <- file(fname, "w")
		
		cat("*-----------------------------------------------------------", "\n", file = thefile)
		cat("*  Created by the R package 'weather'\n", file = thefile)
		cat("*", "\n", file = thefile)
		cat("*  Column    Daily Value\n", file = thefile)
		cat("*     1      Station number\n", file = thefile)
		cat("*     2      Year\n", file = thefile)
		cat("*     3      Day\n", file = thefile)
		cat("*     4      irradiance         KJ m-2 d-1\n", file = thefile)
		cat("*     5      min temperature            oC\n", file = thefile)
		cat("*     6      max temperature            oC\n", file = thefile)
		cat("*     7      vapor pressure            kPa\n", file = thefile)
		cat("*     8      mean wind speed         m s-1\n", file = thefile)
		cat("*     9      precipitation          mm d-1\n", file = thefile)
		cat("*\n", file = thefile)
		cat("** WCCDESCRIPTION=gizmo\n", file = thefile)
		cat("** WCCFORMAT=2\n", file = thefile)
		cat("** WCCYEARNR=", yr, "\n", file = thefile)
		cat("*-----------------------------------------------------------", "\n", file = thefile)

		if (isTRUE(list(...)$dotsboundlat)) {
			if ( lat > 60) { lat <- 59 }
			if ( lat < -60 ) { lat <- -59 }
		}
		cat(lon, lat, alt, '  0.00  0.00 \n', file = thefile)

		yw <- w[ ,year==yr]
		
		yw[is.na(yw)] <- -9999
		for (d in 1:length(yw[,1])) {
			cat("1  ", sprintf("%6.0f", yr), sprintf("%5.0f", d), sprintf("%10.0f", yw$srad[d]), sprintf("%8.1f", yw$tmin[d]), sprintf("%8.1f", yw$tmax[d]), sprintf("%8.1f", yw$vapr[d]), sprintf("%8.1f", wind), sprintf("%8.1f", yw$prec[d]), "\n", file=thefile)
		}
		close(thefile)
    }
	return(invisible(fname))
}		