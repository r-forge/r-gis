
fwTranslate <- function(x, filename, format, options=NULL) {

	fwp <- paste(fwPath(), 'gdal_translate', sep='')
	
	x <- .getFilename(x)
	if (trim(filename) == "") {
		filename <- rasterTmpFile()
		extension(filename) <- 'tif'
		format <- 'GTiff'
	} else if (missing(format)) {
		format <- 'GTiff'	
	}
	fullcall <- paste(fwp, options, x, shQuote(filename), "-of", format)
	system(fullcall)
	raster(filename)
}

