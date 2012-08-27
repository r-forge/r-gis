
# not tested
fwPolygonize <- function(x, options=NULL) {
	fwp <- paste('python ' , fwPath(), 'gdal_polygonize.py', sep='')
	x <- .getFilename(x)
	format='ESRI Shapefile'
	out <- extension(rasterTmpFile, '.shp')
	fullcall <- paste(fwp, shQuote(x), '-f', format, shQuote(out), options)
	system(fullcall)
	fn <- extension(basename(out), "")
    vec <- readOGR(dirname(out), fn)
    return(vec)
}

