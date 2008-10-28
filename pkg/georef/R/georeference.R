

get.coordinates <- function(cy='', sp='', co='', loc='') {
	theurl <- paste("http://bg.berkeley.edu:8080/ws/single?cy=", cy, "&sp=", sp, "&co=", co, "&locality=", loc, sep='')
	xml <- xmlTreeParse(theurl)
# to do: improved parsing:	
	return(xml$doc$children$biogeomancer)
}


get.elevation <- function(latitude, longitude) {
	theurl <- paste("http://ws.geonames.org/srtm3?lat=", latitude, "&lng=", longitude, sep='')
	elevation <- scan(theurl, what='character', quiet=TRUE)
	if (elevation < -32000) { elevation <- NA }
	return(elevation)
}



.get.country.list <- function() {
	path <- paste(system.file(package="Rgis"), "/data", sep='')
	d <- read.table(paste(path, "/countries", sep=""), header=T, sep="\t",  quote = "!@!")
	return(as.matrix(d))
}

get.country <- function(lonlat, radius=0) {
	cnts <- .get.country.list()
	for (i in 1:length(lonlat[,1])) {
		theurl <- paste("http://ws.geonames.org/countryCode?lat=", lonlat[i,2], "&lng=", lonlat[i,1], "&radius=", radius, sep='')
		country <- scan(theurl, what='character', quiet=TRUE)
		if (length(country) > 1) { res <- NA
		} else {
			rec <- subset(cnts, cnts[,3] == country) 
			if (length(rec) == 0) { res <- NA }
			else res <- (rec)
		}	
		if (i==1) { res2 <- res 
		} else { res2 <- rbind(res2, res) }
	}	

	return(res2)
}


get.admin.division <- function(latitude, longitude, radius=0, maxrows=1) {
	theurl <- paste("http://ws.geonames.org/countrySubdivision?lat=", latitude, "&lng=", longitude, "&radius=", radius, "&maxrows=", maxrows, sep='')
	subdivs <- scan(theurl, what='character', quiet=TRUE)
	return(subdivs)
}



#http://ws.geonames.org/findNearbyPlaceName?lat=47.3&lng=9 
#http://ws.geonames.org/findNearby?lat=47.3&lng=9 
#http://ws.geonames.org/findNearbyWikipedia?lat=47&lng=9


