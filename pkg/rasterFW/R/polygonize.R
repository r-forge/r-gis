
fwPolygonize <- function(x, options=NULL, ...) {
	fwp <- paste(python, ' ' , FWpath(), 'gdal_polygonize.py', sep='')
	x <- .getFilename(x)
	format='ESRI Shapefile'
	out <- extension(rasterTmpFile, '.shp')
	fullcall <- paste(fwp, x, -f format, out, options)
	system(fullcall)
	fn <- extension(basename(out), "")
    vec <- readOGR(dirname(out), fn)
    return(vec)
}

