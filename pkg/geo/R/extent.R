# Author: Robert J. Hijmans
# Date :  October 2017
# Version 0.9
# Licence GPL v3


if (!isGeneric("ext")) {
	setGeneric("ext", function(x, ...)
		standardGeneric("ext"))
}	

if (!isGeneric("ext<-")) {
	setGeneric("ext<-", function(x, value)
		standardGeneric("ext<-"))
}	

	

setMethod('ext', signature(x='missing'), 
	function(x, ...){ 
		e <- methods::new('GeoExtent')
		e@ptr <- GeoExtent$new()
		return(e)
	}
)	
	
setMethod('ext', signature(x='numeric'), 
	function(x, ...){ 
		dots <- unlist(list(...))
		x <- c(x, dots)
		if (length(x) < 4) {
			stop('insufficient number of elements (should be 4)')
		}
		if (length(x) > 4) {
			warning('more elements than expected (should be 4)')
		}
		names(x) <- NULL
		e <- methods::new('GeoExtent')
		e@ptr <- GeoExtent$new(x[1], x[2], x[3], x[4])
		if (validObject(e)) return(e)
	}	
)


setMethod('ext', signature(x='GeoRaster'), 
	function(x, ...){ 
		e <- methods::new('GeoExtent')
		e@ptr <- x@ptr$extent
		return(e)
	}
)	

setMethod("ext<-", signature('GeoRaster', 'GeoExtent'), 
	function(x, value) {
	    stop()
		# requires a deep copy
		# y <- deepcopy(x)
		#y@ptr$extent <- as.vector(value)
		#return(y)
	}
)

