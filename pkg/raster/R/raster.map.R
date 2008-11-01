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
		raster <- set.values(raster, rasterstack@data@values[i,])
	}
	raster.map(raster, col=col, subsample=subsample, maxdim=maxdim, ...)
}


raster.map <- function(raster, col = rev(terrain.colors(25)), subsample=TRUE, maxdim=500, ...) {
#TODO if xlim and/or ylim are used, only read (and sample) for those areas.
#	require(fields)

	if ( get.content(raster) == 'all') {
		m <- get.values(raster, format='matrix')
		if (max(get.ncols(raster), get.nrows(raster)) <= maxdim) { subsample=FALSE }
		
		if (subsample) {
			skip <- round(max(get.ncols(raster), get.nrows(raster)) / maxdim)
			cols <- (0:round(get.ncols(raster)/skip)) * skip + 1
			cols <- cols[ cols <= get.ncols(raster) ]
			rows <- (0:round(get.nrows(raster)/skip)) * skip + 1
			rows <- rows[ rows <= get.nrows(raster) ]
			
			m <- m[rows, cols]

			xres <- (get.xmax(raster) - get.xmin(raster) ) / dim(m)[2]
			yres <- (get.ymax(raster) - get.ymin(raster) ) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + get.xmin(raster) 
			y <- (0:dim(m)[1]) * yres + get.ymin(raster) 
 		} else {	
			x <- (0:get.ncols(raster)) * get.xres(raster) + get.xmin(raster) 
			y <- (0:get.nrows(raster)) * get.yres(raster) + get.ymin(raster) 	
		}	
	} else {
		if (subsample) {
			m <- .read.skip(raster, maxdim) 
			xres <- (get.xmax(raster) - get.xmin(raster)) / dim(m)[2]
			yres <- (get.ymax(raster) - get.ymin(raster) ) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + get.xmin(raster) 
			y <- (0:dim(m)[1]) * yres + get.ymin(raster) 
		} else {
			raster <- read.all(raster)
			m <- get.values(raster, format='matrix')
			x <- (0:get.ncols(raster)) * get.xres(raster) + get.xmin(raster) 
			y <- (0:get.nrows(raster)) * get.yres(raster) + get.ymin(raster) 
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

