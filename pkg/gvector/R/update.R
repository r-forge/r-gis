# Author: Robert J. Hijmans
# Date : December 2011
# Version 1.0
# Licence GPL v3


setMethod('update', signature(object='SpatialPolygonsDataFrame'), 
function(object, ...) {


	yy <- list(...)
	if (is.null(yy)) {
		return(object)
	}

	i <- which(sapply(yy, function(x) inherits(x, 'SpatialPolygonsDataFrame')))
	if (length(i)==0) {
		stop('additional arguments should be of class SpatialPolygonsDataFrame')
	} else if (length(i) < length(yy)) {
		warning('additional arguments that are not of class SpatialPolygonsDataFrame are ignored')
		yy <- yy[i]
	} 
	
	require(rgeos)

	haswarned <- FALSE
	for (y in yy) {
		if (! identical(projection(x), projection(y)) ) {
			if (!haswarned) {
				warning('non identical CRS')
				haswarned <- TRUE
			}
			y@proj4string <- x@proj4string
		}	
		
		i <- gIntersects(x, y)
		if (!i) {
			next
		}
	
		x <- spChFIDs(x, as.character(1:length(row.names(x))))
		y <- spChFIDs(y, as.character(1:length(row.names(y))))

		xnames <- colnames(x@data)
		ynames <- colnames(y@data)
		yinx <- which(ynames %in% xnames)
		doAtt <- TRUE
		if (length(yinx) == 0) {
			doAtt <- FALSE
		}
		
		subs <- gIntersects(x, y, byid=TRUE)

		subsx <- apply(subs, 2, any)
		subsy <- apply(subs, 1, any)
		
		x <- x - int
		if (is.null(x)) {
			x <- int
		} else {
			int <- y - x
			x <- append(x, int)			
		}
	}
	x
} 
)



