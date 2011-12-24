# Author: Robert J. Hijmans
# Date: December 2011
# Version 1.0
# Licence GPL v3

if (!isGeneric('buffer')) {
	setGeneric('buffer', function(x, ...)
		standardGeneric('buffer'))
}	


setMethod('buffer', signature(x='Spatial'), 
function(x, width=0, ...) { 
	y <- gBuffer(x, byid=TRUE, id=NULL, width=width, ...)
	row.names(y) <- row.names(x)
	if (.hasSlot(x, 'data')) {
		y <- SpatialPolygonsDataFrame(y, x@data)
	}
	y
}
)


setMethod('buffer', signature(x='SpatialPixels'), 
function(x, width=0, ...) { 
	x <- brick(x)
	buffer(x, width=width, ...)
}
)

setMethod('buffer', signature(x='SpatialGrid'), 
function(x, width=0, ...) { 
	x <- brick(x)
	buffer(x, width=width, ...)
}
)
