# Author: Robert J. Hijmans
# Date :  October 2017
# Version 0.9
# Licence GPL v3


if ( !isGeneric("georaster") ) {
	setGeneric("georaster", function(x, ...)
		standardGeneric("georaster"))
}

setMethod('georaster', signature(x='missing'), 
	function(nrows=180, ncols=360, xmn=-180, xmx=180, ymn=-90, ymx=90, crs, ext, resolution, vals=NULL) {

		r <- methods::new('GeoRaster')
		r@ptr <- GeoRaster$new()
		return(r)
		
		if (missing(ext)) {
			ext <- extent(xmn, xmx, ymn, ymx)
		}
	
		if (missing(crs)) {
			if (ext@ptr$xmin > -360.01 & ext@ptr$xmax < 360.01 & ext@ptr$ymin > -90.01 & ext@ptr$ymax < 90.01) { 
				crs <- "+proj=longlat +datum=WGS84"
			} else {
				# if sp >= 1.2.1  crs <- CRS(as.character(NA), doCheckCRSArgs=FALSE)
				crs <- as.character(NA)
			}
		} else {
			crs <- as.character(crs)
		}
		if (missing(resolution)) {
			nrows <- as.integer(max(1, round(nrows)))
			ncols <- as.integer(max(1, round(ncols)))
			# r <- methods::new('RasterLayer', extent=ext, nrows=nrows, ncols=ncols, crs=crs)
		} else {
			#r <- methods::new('RasterLayer', extent=ext, crs=crs)
			#res(r) <- resolution
		}
#		if (!is.null(vals)) {
#			return( setValues(r, vals) )
#		} else {
			return( r )
#		}
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



