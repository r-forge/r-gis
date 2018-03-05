# Author: Robert J. Hijmans
# Date : November 2009
# Version 1.0
# Licence GPL v3


setMethod('mask', signature(x='SpatRaster', y='SpatRaster'), 
function(x, y, filename="", ...) { 
    overwrite <- .overwrite(...)
    r <- methods::new("GeoRaster")
    r@ptr <- x@ptr$mask(mask@ptr, filename[1], overwrite)
    return(r)
}
)

