# Author: Robert J. Hijmans
# Date: September 2009
# Version 1.0
# Licence GPL v3



setMethod('writeRaster', signature(x='GeoRaster', filename='character'), 
function(x, filename, ...) {
	if (!hasValues(x)) {
		warning('all cell values are NA')
	}
	r <- x@ptr$writeRaster(filename)
	return(invisible(r))
}	
)

