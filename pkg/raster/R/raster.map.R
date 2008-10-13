# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.map <- function(raster, col = rev(terrain.colors(25)), subsample=TRUE, maxdim=500, ...) {
#    z <- raster.read.rows(raster, 1, raster@nrows)
	if (length(raster@data@values) != raster@ncells) { 
		if (subsample) {
			m <- raster.read.skip(raster, maxdim) 
			xres <- (raster@xmax - raster@xmin) / dim(m)[2]
			yres <- (raster@ymax - raster@ymin) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + raster@xmin 
			y <- (0:dim(m)[1]) * yres + raster@ymin 
		} else {
			raster <- raster.read.all(raster)
			m <- raster.get.matrix(raster)
			x <- (0:raster@ncols) * raster@xres + raster@xmin 
			y <- (0:raster@nrows) * raster@yres + raster@ymin 
		}	
	} else {
		m <- raster.get.matrix(raster) 
		x <- (0:raster@ncols) * raster@xres + raster@xmin 
		y <- (0:raster@nrows) * raster@yres + raster@ymin 
	}

	z <- t(m[nrow(m):1,])
	image.plot(x, y, z, col=col, axes = TRUE, xlab="", ylab="", legend.width = 0.8, ...)
	
#	image(x, y, z, col=col, axes = FALSE, xlab="", ylab="")
#	contour(x, y, z, add = TRUE, col = "peru")
#	xincr <- (raster@xmax - raster@xmin) / 12
#	yincr <- (raster@ymax - raster@ymin) / 10
#	axis(1, at = seq(raster@xmin, raster@xmax, by = xincr))
#	axis(2, at = seq(raster@ymin, raster@ymax, by = yincr))
	box()
	raster@data@values <- vector(length=0)
#	title(main = raster@file@shortname, font.main = 4)
}	

