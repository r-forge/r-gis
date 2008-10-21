# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

rasterstack.map <- function(rasterstack, index=1, col = rev(terrain.colors(25)), subsample=TRUE, maxdim=500, ...) {
	index <- round(index)
	i <- min(max(1, index), rasterstack@nrasters)
	if (i != index) {stop("index should be >= 1 and <= rasterstack@nrasters")}
	raster <- rasterstack@rasters[[i]]
	if (rasterstack@data@content == 'all') {
		raster <- raster.set.data(raster, rasterstack@data@values[i,])
	}
	raster.map(raster, col=col, subsample=subsample, maxdim=maxdim, ...)
}	


raster.map <- function(raster, col = rev(terrain.colors(25)), subsample=TRUE, maxdim=500, ...) {
	if (raster@data@content == 'all') {
		m <- raster.data(raster, format='matrix')
		if (subsample) {
			skip <- round(max(raster.ncols(raster), raster.nrows(raster)) / maxdim)
			cols <- (0:round(raster.ncols(raster)/skip)) * skip + 1
			rows <- (0:round(raster.nrows(raster)/skip)) * skip + 1
			m <- m[rows, cols]

			xres <- (raster@xmax - raster@xmin) / dim(m)[2]
			yres <- (raster@ymax - raster@ymin) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + raster@xmin 
			y <- (0:dim(m)[1]) * yres + raster@ymin 
 		} else {	
			x <- (0:raster@ncols) * raster@xres + raster@xmin 
			y <- (0:raster@nrows) * raster@yres + raster@ymin 	
		}	
	} else {
		if (subsample) {
			m <- .raster.read.skip(raster, maxdim) 
			xres <- (raster@xmax - raster@xmin) / dim(m)[2]
			yres <- (raster@ymax - raster@ymin) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + raster@xmin 
			y <- (0:dim(m)[1]) * yres + raster@ymin 
		} else {
			raster <- raster.read.all(raster)
			m <- raster.data(raster, format='matrix')
			x <- (0:raster@ncols) * raster@xres + raster@xmin 
			y <- (0:raster@nrows) * raster@yres + raster@ymin 
		}	
	} 
	z <- t(m[nrow(m):1,])
	image.plot(x, y, z, col=col, axes = TRUE, xlab="", ylab="", legend.width = 0.8, ...)
	box()
#	image(x, y, z, col=col, axes = FALSE, xlab="", ylab="")
#	contour(x, y, z, add = TRUE, col = "peru")
#	xincr <- (raster@xmax - raster@xmin) / 12
#	yincr <- (raster@ymax - raster@ymin) / 10
#	axis(1, at = seq(raster@xmin, raster@xmax, by = xincr))
#	axis(2, at = seq(raster@ymin, raster@ymax, by = yincr))
#	title(main = raster@file@shortname, font.main = 4)
}	

