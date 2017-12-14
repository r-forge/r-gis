# Author: Robert J. Hijmans
# Date :  January 2009
# Version 0.9
# Licence GPL v3



setMethod("crs", signature('GeoRaster'), 
	function(x) {
		x@ptr$crs
	}
)


setMethod("crs<-", signature('GeoRaster', 'character'), 
	function(x, ..., value) {
	# requires deep copy
	#	x@ptr$crs <- value
	#	return(x)
	}
)

