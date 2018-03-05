# Author: Robert J. Hijmans
# Date : November 2009
# Version 1.0
# Licence GPL v3


setMethod('rasterize', signature(x='SpatPolygons', y='SpatRaster'), 
function(x, y, filename="", ...) { 
	overwrite <- .overwrite(...)
	r <- methods::new('SpatRaster')
	r@ptr <- y@ptr$rasterizePolygons(x@ptr, filename[1], overwrite)
	return(r)
}
)
r = georst()
r@ptr = r@ptr$rasterizePolygons(ppp, "", TRUE)
image(r)
z = lapply(x, lines)

