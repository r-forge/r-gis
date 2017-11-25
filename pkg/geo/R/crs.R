# Author: Robert J. Hijmans
# Date :  January 2009
# Version 0.9
# Licence GPL v3



if (!isGeneric("crs")) {
	setGeneric("crs", function(x, ...)
		standardGeneric("crs"))
}	

setMethod("crs", signature('GeoRaster'), 
	function(x) {
		x@ptr$crs
	}
)

if (!isGeneric("crs<-")) {
	setGeneric("crs<-", function(x, value, ...)
		standardGeneric("crs<-"))
}	

setMethod("crs<-", signature('GeoRaster'), 
	function(x, value, ...) {
		x@ptr$crs <- value
	}
)

