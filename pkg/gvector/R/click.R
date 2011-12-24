# Author: Robert J. Hijmans
# Date : January 2009 - December 2011
# Version 1.0
# Licence GPL v3


if (!isGeneric("click")) {
	setGeneric("click", function(x, ...)
		standardGeneric("click"))
}	

	
setMethod('click', signature(x='SpatialPolygons'),
	function(x, n=1, id=FALSE, xy=FALSE, type="n", ...) {
		loc <- locator(n, type, ...)
		xyCoords <- cbind(x=loc$x, y=loc$y)
		if (id) {
			text(xyCoords, labels=1:n)
		}

		xyCoords <- SpatialPoints(xyCoords)
		xyCoords@proj4string <- x@proj4string
		i <- which(!is.na(over(x, xyCoords)))
		if (length(i) > 0) {
			if (.hasSlot(x, 'data')) {
				x <- x@data[i,]
			} else {
				x <- row.names(x)[i]
			}
		} else {
			x <- NULL
		}
		
		if (xy) {
			x <- cbind(xyCoords, x)
		}
		return(x)
	}
)


setMethod('click', signature(x='SpatialLines'), 
	function(x, ...) {
		e <- as(drawExtent(), 'SpatialPolygons')
		e@proj4string <- x@proj4string
		i <- which(!is.na(over(x, e)))
		if (length(i) > 0) {
			if (.hasSlot(x, 'data')) {
				x <- x@data[i,]
			} else {
				x <- row.names(x)[i]
			}
		} else {
			x <- NULL
		}
		x
	}
)

setMethod('click', signature(x='SpatialPoints'), 
	function(x, ...) {
		e <- as(drawExtent(), 'SpatialPolygons')
		e@proj4string <- x@proj4string
		i <- which(!is.na(over(x, e)))
		if (length(i) > 0) {
			if (.hasSlot(x, 'data')) {
				x <- x@data[i,]
			} else {
				x <- row.names(x)[i]
			}
		} else {
			x <- NULL
		}
		x
	}
)

