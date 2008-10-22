

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

get.country <- function(latitude, longitude, radius=0) {
	theurl <- paste("http://ws.geonames.org/countryCode?lat=", latitude, "&lng=", longitude, "&radius=", radius, sep='')
	country <- scan(theurl, what='character', quiet=TRUE)
	if (length(country) > 1) { return(NA)
	} else {
		cnts <- .get.country.list()
		rec <- subset(cnts, cnts[,3] == country) 
		if (length(rec) == 0) { return(NA) }
		else return(rec)
	}	
}


get.admin.division <- function(latitude, longitude, radius=0, maxrows=1) {
	theurl <- paste("http://ws.geonames.org/countrySubdivision?lat=", latitude, "&lng=", longitude, "&radius=", radius, "&maxrows=", maxrows, sep='')
	subdivs <- scan(theurl, what='character', quiet=TRUE)
	return(subdivs)
}



#http://ws.geonames.org/findNearbyPlaceName?lat=47.3&lng=9 
#http://ws.geonames.org/findNearby?lat=47.3&lng=9 
#http://ws.geonames.org/findNearbyWikipedia?lat=47&lng=9


