# Author: Robert J. Hijmans
# Date : December 2009
# Version 1.0
# Licence GPL v3

if (!isGeneric("crop")) {
	setGeneric("crop", function(x, y, ...)
		standardGeneric("crop"))
}	


setMethod('crop', signature(x='GeoRaster', y='ANY'), 
function(x, y, filename='', snap='near', ...) {

	r <- methods::new('GeoRaster')
	r@ptr <- x@ptr$crop(y@ptr, filename, snap)
	r
	
}
)


