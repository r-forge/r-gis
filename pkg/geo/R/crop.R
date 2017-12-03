# Author: Robert J. Hijmans
# Date : December 2009
# Version 1.0
# Licence GPL v3



setMethod('crop', signature(x='GeoRaster', y='ANY'), 
function(x, y, filename="", snap="near", ...) {

	if (!inherits(y, 'GeoExtent')) {
		y <- ext(y)
	}
	
	overwrite <- .overwrite(...)
	r <- methods::new('GeoRaster')
	
	ptr <- try(x@ptr$crop(y@ptr, filename, snap, overwrite))
	if (class(ptr) == 'try-error') { stop("crop error") } else { r@ptr <- ptr }

	r	
}
)


