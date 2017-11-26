# Author: Robert J. Hijmans
# Date :  October 2017
# Version 0.9
# Licence GPL v3


if ( !isGeneric("georaster") ) {
	setGeneric("georaster", function(x, ...)
		standardGeneric("georaster"))
}

setMethod('georaster', signature(x='missing'), 
	function(nrow=180, ncol=360, nlayer=1, xmin=-180, xmax=180, ymin=-90, ymax=90, crs, ext, resolution, ...) {

		if (missing(ext)) {	ext <- extent(xmin, xmax, ymin, ymax) }
	
		if (missing(crs)) {
			if (ext@xmin > -360.01 & ext@xmax < 360.01 & ext@ymin > -90.01 & ext@ymax < 90.01) { 
				crs <- "+proj=longlat +datum=WGS84"
			} else {
				crs <- as.character(NA)
			}
		} else {
			crs <- as.character(crs)
		}
		

		r <- methods::new('GeoRaster')
		r@ptr <- GeoRaster$new(c(nrow, ncol, nlayer), as.vector(ext), crs)
		
		if (!missing(resolution)) {
			res(r) <- resolution
		}

		return(r)
	}
)


.fullFilename <- function(x, expand=FALSE) {
	x <- trim(x)
	if (identical(basename(x), x)) {
		x <- file.path(getwd(), x)
	}
	if (expand) {
		x <- path.expand(x)
	}
	return(x)
}

setMethod('georaster', signature(x='character'), 
	function(x, band=1, ...) {
		f <- .fullFilename(x)
		r <- methods::new('GeoRaster')
		r@ptr <- GeoRaster$new(f)
		return(r)
	}
)


setMethod('georaster', signature(x='GeoRaster'), 
	function(x, ...) {
		r <- methods::new('GeoRaster')
		r@ptr <- GeoRaster$new(dim(r), as.vector(extent(r)), crs(r))
		# also need the keep the names ?
		return(r)
	}
)

