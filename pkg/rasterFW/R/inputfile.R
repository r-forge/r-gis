
.getFilename <- function(x, covertogdal=TRUE) {
	if (is.character(x)) {
		stopifnot(file.exists(x))
	} else {
		if (inherits(x, 'SpatialGrid')) {	
			x <- as(x, 'RasterBrick')
		}
		if (inherits(x, 'Raster')) {
			stopifnot(nlayers(x) == 1)
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

