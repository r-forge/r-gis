
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


get.country <- function(latitude, longitude, radius=0) {
	theurl <- paste("http://ws.geonames.org/countryCode?lat=", latitude, "&lng=", longitude, "&radius=", radius, sep='')
	country <- scan(theurl, what='character', quiet=TRUE)
	return(country)
}


get.admin.division <- function(latitude, longitude, radius=0, maxrows=1) {
	theurl <- paste("http://ws.geonames.org/countrySubdivision?lat=", latitude, "&lng=", longitude, "&radius=", radius, "&maxrows=", maxrows, sep='')
	subdivs <- scan(theurl, what='character', quiet=TRUE)
	return(subdivs)
}



#http://ws.geonames.org/findNearbyPlaceName?lat=47.3&lng=9 
#http://ws.geonames.org/findNearby?lat=47.3&lng=9 
#http://ws.geonames.org/findNearbyWikipedia?lat=47&lng=9



get.ndigits <- function(x){
    result <- pmax(0,nchar(abs(x))-nchar(abs(trunc(x,digits=0)))-1)
    return(result)
}


#Detect conversion error (degrees-minutes to decimals) 
detect.conversion.error <- function(x,digits){
	x <- as.vector(na.omit(x))
    x <- x[get.ndigits(x) >= digits]
    x <- abs(x)
    x.dec <- x - trunc(x,digits=0)
    a <- length(x.dec[x.dec < 0.6])
    b <- length(x.dec[x.dec > 0.6])
	result <- chisq.test(c(a,b), p=c(0.6,0.4))
	return(list(p.value = result$p.value, estimated.number.wrong = round(a - (a+b)*0.6)))
 }


