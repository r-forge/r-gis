# Author: Robert J. Hijmans
# Date :  October 2017
# Version 0.9
# Licence GPL v3


if (!isGeneric("extent")) {
	setGeneric("extent", function(x, ...)
		standardGeneric("extent"))
}	


if (!isGeneric("xmin")) {
	setGeneric("xmin", function(x)
		standardGeneric("xmin"))
}

if (!isGeneric("xmax")) {
	setGeneric("xmax", function(x)
		standardGeneric("xmax"))
}

if (!isGeneric("ymin")) {
	setGeneric("ymin", function(x)
		standardGeneric("ymin"))
}

if (!isGeneric("ymax")) {
	setGeneric("ymax", function(x)
		standardGeneric("ymax"))
}

	

setMethod('extent', signature(x='missing'), 
	function(x, ...){ 
		e <- methods::new('GeoExtent')
		return(e)
	}
)	
	
setMethod('extent', signature(x='numeric'), 
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
		e@xmin <- x[1]
		e@xmax <- x[2]
		e@ymin <- x[3]
		e@ymax <- x[4]
		if (validObject(e)) return(e)
	}	
)


setMethod('extent', signature(x='GeoRaster'), 
	function(x, ...){ 
		extent(x@ptr$extent)
	}
)	


setMethod('xmin', signature(x='GeoRaster'), 
function(x) {
	return(xmin(extent(x)))
})

setMethod('xmax', signature(x='GeoRaster'), 
function(x) {
	return(xmax(extent(x)))
})

setMethod('ymin', signature(x='GeoRaster'), 
function(x) {
	return(ymin(extent(x)))
})

setMethod('ymax', signature(x='GeoRaster'), 
function(x) {
	return(ymax(extent(x)))
})

setMethod('xmin', signature(x='GeoExtent'), 
function(x) {
	return(x@xmin)
})

setMethod('xmax', signature(x='GeoExtent'), 
function(x) {
	return(x@xmax)
})

setMethod('ymin', signature(x='GeoExtent'), 
function(x) {
	return(x@ymin)
})

setMethod('ymax', signature(x='GeoExtent'), 
function(x) {
	return(x@ymax)
})


