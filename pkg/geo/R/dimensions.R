# Author: Robert J. Hijmans
# Date :  June 2017
# Version 0.9
# Licence GPL v3


setMethod('dim', signature(x='GeoRaster'), 
	function(x){ return(c(nrow(x), ncol(x), nlayer(x))) }
)

setMethod('nrow', signature(x='GeoRaster'), 
	function(x){ return(x@ptr$nrow)}
)

setMethod('ncol', signature(x='GeoRaster'), 
	function(x){ return(x@ptr$ncol) }
)


setMethod('dim<-', signature(x='GeoRaster'), 
	function(x, value) {
	
		if (length(value) == 1) {
			value <- c(value, ncol(x), nlayer(x))
		} else if (length(value) == 2) {
			value <- c(value, nlayer(x))
		} else if (length(value) > 3) {
			warning('value should have length 1, 2, or 3. Additional values ignored')
			value <- value[1:3]
		}		
		value <- as.integer(pmax(round(value), c(1,1,1)))
		georaster(value, as.vector(extent(x)), crs(x))
	}
)



if (!isGeneric("ncell")) {
	setGeneric("ncell", function(x)
		standardGeneric("ncell"))
}	

setMethod('ncell', signature(x='GeoRaster'), 
	function(x) {
		return(as.numeric(ncol(x)) * nrow(x))
	}
)


setMethod('ncell', signature(x='ANY'), 
	function(x) {
		NROW(x) * NCOL(x)
	}
)



setMethod('length', signature(x='GeoRaster'), 
	function(x) {
		ncell(x) * nlayer(x)
	}
)

if (!isGeneric("nlayer")) {
	setGeneric("nlayer", function(x)
		standardGeneric("nlayer"))
}	

setMethod('nlayer', signature(x='GeoRaster'), 
	function(x){
		return(x@ptr$nlyr) 
    }
)



'ncol<-' <- function(x, value) {
	dim(x) <- c(nrow(x), value)
	return(x)
}	

'nrow<-' <- function(x, value) {
	dim(x) <- c(value, ncol(x))
	return(x)
}	


'xmin<-' <- function(x, value) {
	if (inherits(x, 'Extent')) {
		x@ptr$xmin <- value
	} else {
		x@extent@ptr$xmin <- value
	}
	return(x)
}

'xmax<-' <- function(x, value) {
	if (inherits(x, 'Extent')) {
		x@ptr$xmax <- value
	} else {
		x@extent@ptr$xmax <- value
	}
	return(x)
}

'ymin<-' <- function(x, value) {
	if (inherits(x, 'Extent')) {
		x@ptr$ymin <- value
	} else {
		x@extent@ptr$ymin <- value
	}
	return(x)
}

'ymax<-' <- function(x, value) {
	if (inherits(x, 'Extent')) {
		x@ptr$ymax <- value
	} else {
		x@extent@ptr$ymax <- value
	}
	return(x)
}




if (!isGeneric("res")) {
	setGeneric("res", function(x)
		standardGeneric("res"))
}
if (!isGeneric("xres")) {
	setGeneric("xres", function(x)
		standardGeneric("xres"))
}
if (!isGeneric("yres")) {
	setGeneric("yres", function(x)
		standardGeneric("yres"))
}

setMethod('res', signature(x='GeoRaster'), 
function(x) {
		x@ptr$res
	}
)

setMethod('xres', signature(x='GeoRaster'), 
function(x) {
		res[1]
	}
)

setMethod('yres', signature(x='GeoRaster'), 
function(x) {
		res[2]
	}
)
