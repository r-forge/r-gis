# Author: Robert J. Hijmans
# Date :  June 2008
# Version 0.9
# Licence GPL v3

if (!isGeneric("setMinMax")) {setGeneric("setMinMax", function(x) standardGeneric("setMinMax"))}	
if (!isGeneric("minmax")) {setGeneric("minmax", function(x) standardGeneric("minmax"))}	


setMethod("values", signature(x='SpatRaster'), 
function(x, matrix=TRUE, ...) {
	if (.hasValues(x)) {
		v <- x@ptr$getValues()
		if (matrix) {
			v <- matrix(v, ncol=nlyr(x))
			colnames(v) <- names(x)
		}
	} else {
		v <- NULL
	}
	return(v)	
}
)


setMethod('values<-', signature(x='SpatRaster', 'ANY'), 
	function(x, value) {
	if (is.matrix(value)) { 
		if (nrow(value) == nrow(x)) {
			value <- as.vector(t(value))
		} else {
			value <- as.vector(value)
		} 
	} else if (is.array(value)) { 
		stopifnot(length(dim(value)) == 3)
		value <- as.vector(aperm(value, c(2,1,3)))
	}
	
	if (!(is.numeric(value) || is.integer(value) || is.logical(value))) {
		stop('value must be numeric, integer, or logical')
	}

	if (length(value) == 1) {	
		value <- rep(value, ncell(x))
	} 
	stopifnot((length(value) %% ncell(x)) == 0)

	y <- rast(x)
	y@ptr$setValues(value)
	y
}
)
	

.hasValues <- function(x) {
	x@ptr$hasValues
}

.inMemory <- function(x) {
	x@ptr$inMemory
}

.filenames <- function(x) {
	x@ptr$filenames
}

.hasMinMax <- function(x) {
	x@ptr$hasRange
}

setMethod('minmax', signature(x='SpatRaster'), 
	function(x) {
		rmin <- x@ptr$range_min
		rmax <- x@ptr$range_max
		rbind(rmin, rmax)
	}
)


setMethod('setMinMax', signature(x='SpatRaster'), 
	function(x) {
		if (!.hasMinMax(x)) {
			x@ptr$setRange
		}
	}
)