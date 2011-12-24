# Author: Robert J. Hijmans
# Date : December 2011
# Version 1.0
# Licence GPL v3


setMethod('update', signature(object='SpatialPolygons'), 
function(object, ...) {

	yy <- list(...)
	if (is.null(yy)) {
		return(object)
	}

	i <- which(sapply(yy, function(x) inherits(x, 'SpatialPolygons')))
	if (length(i)==0) {
		stop('additional arguments should be of class SpatialPolygons')
	} else if (length(i) < length(yy)) {
		warning('additional arguments that are not of class SpatialPolygons are ignored')
		yy <- yy[i]
	} 

	haswarned <- FALSE
	for (y in yy) {
		if (! identical(projection(x), projection(y)) ) {
			if (!haswarned) {
				warning('non identical CRS')
				haswarned <- TRUE
			}
			y@proj4string <- x@proj4string
		}	
		subs <- gIntersects(x, y, byid=TRUE)
		if (!any(subs)) {
			next
		} else {
			int <- crop(y, x)
			x <- erase(x, int)
			x <- combine(x, int)
		}
	}
	x
} 
)



