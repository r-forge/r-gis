
.getFilename <- function(x, converttogdal=TRUE, nl=Inf) {
	if (is.character(x)) {
		stopifnot(file.exists(x))
	} else {
		if (inherits(x, 'SpatialGrid')) {	
			x <- as(x, 'RasterBrick')
		}
		if (inherits(x, 'Raster')) {
			if (nlayers(x) > nl) {
				stop('number of layers is greater than:', nl)
			}
			if (! fromDisk(x)) {
				fn <- extension(rasterTmpFile(), '.tif')
				x <- writeRaster(x, filename=fn)
				x <- filename(x)
			} else {
				if (raster:::.driver(x) != 'gdal') {
					if (converttogdal) {
						fn <- extension(rasterTmpFile(), '.tif')
						x <- writeRaster(x, filename=fn)
					} else {
						stop('this is not a gdal based object')
					}
				} 
				x <- filename(x)
			}
		} else {
			stop('the object is not of a recognized class')
		}
	}
	return(x)
}

