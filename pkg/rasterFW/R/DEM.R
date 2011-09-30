# Author: Lyndon Estes
# Changes by Robert Hijmans

fwDEM <- function(dem, type='slope', filename="", options=NULL, format, ...) {
# Runs gdaldem to create hillshade, slope, aspect, color-relief, TRI, TPI, or roughness surfaces from a DEM
# See http://www.gdal.org/gdaldem.html for more details
	fwp <- paste(FWpath(), 'gdaldem', sep='')
	stopifnot(type %in% c("hillshade", "slope", "aspect", "color-relief", "TRI", "TPI", "roughness"))
	
	dem <- .getFilename(dem)
	if (trim(filename) == "") {
		filename <- rasterTmpFile()
		extension(filename) <- 'tif'
		format <- 'GTiff'
	} else if (missing(format)) {
		format <- 'GTiff'	
	}
	fullcall <- paste(fwp, type, dem, filename, "-of", format, options)
	system(fullcall)
	raster(filename)
}

