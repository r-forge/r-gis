
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
detect.conversion.error <- function(xy){
	xy <- na.omit(xy)
	number.digits <- cbind(ndigits(xy[,1]),ndigits(xy[,2]))
	index <- which((pmin(number.digits[,1],number.digits[,2]) + (as.numeric(abs(number.digits[,1]-number.digits[,2]))==1))>=2)
	xy <- xy[index,]
	xy <- abs(xy)
	xy.dec <- xy - trunc(xy,digits=0)
	fr <- vector(length=10)
	for (i in 1:10)
	fr[i] <- length(subset(xy.dec,xy.dec[,1]>(i-1)/10 & xy.dec[,2]<i/10)[,1])
	p.value <- chisq.test(fr,p=rep(0.1,times=10))$p.value
	return(list(p.value = p.value,frequencies = fr))}