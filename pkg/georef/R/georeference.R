

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
	d <- data("countries")
	return(as.matrix(d))
}

get.country <- function(lonlat, radius=0, retries=3, interval=10) {
	cnts <- .get.country.list()
	res <- matrix(ncol=3,nrow=length(lonlat[,1]))
	
    country <- F
    
    for (i in 1:length(lonlat[,1])) {
		theurl <- paste("http://ws.geonames.org/countryCode?lat=", lonlat[i,2], "&lng=", lonlat[i,1], "&radius=", radius, sep='')
		cnt <- 0
		repeat{
            try(country <- scan(theurl, what='character', quiet=TRUE), silent=T)
            cnt <- cnt + 1
            if ((length(country) == 1 & nchar(country)==2) || length(country)>5){
                break                
            }
            else if (cnt==retries){                
                cat(i, paste(lonlat[i,],collapse=","),"failed to connect to webservice \n Will now assign blanks. \n")
                break
            }
            else {
                Sys.sleep(interval*cnt)
            }
        }
		if (length(country) > 1) { res[i,] <- c(NA,NA,NA)
		} else {
			rec <- subset(cnts, cnts[,3] == country) 
			if (length(rec) == 0) { res[i,] <- c(NA,NA,NA) 
			} else res[i,] <- rec
		}	
	}	
	colnames(res) <- c("NAME_ENGLISH", "ISO3", "ISO2")
	return(res)
}


get.admin.division <- function(latitude, longitude, radius=0, maxrows=1) {
	theurl <- paste("http://ws.geonames.org/countrySubdivision?lat=", latitude, "&lng=", longitude, "&radius=", radius, "&maxrows=", maxrows, sep='')
	subdivs <- scan(theurl, what='character', quiet=TRUE)
	return(subdivs)
}



#http://ws.geonames.org/findNearbyPlaceName?lat=47.3&lng=9 
#http://ws.geonames.org/findNearby?lat=47.3&lng=9 
#http://ws.geonames.org/findNearbyWikipedia?lat=47&lng=9


