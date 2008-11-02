# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3


.hist.raster <- function(x, ...) {
	if (get.content(x) != 'all') {
		if (get.source(x) == 'disk') {
		# also make a function that does this by block and combines these for a single histogram
			x <- read.all(x)
		} else { stop('cannot do')}
	}
	hist(values(x), ...)
}

setMethod('hist', signature(x='Raster'), 
	function(x, ...){.hist.raster(x, ...)}
)


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
		m <- values(raster, format='matrix')
		if (max(ncols(raster), nrows(raster)) <= maxdim) { subsample=FALSE }
		
		if (subsample) {
			skip <- round(max(ncols(raster), nrows(raster)) / maxdim)
			cols <- (0:round(ncols(raster)/skip)) * skip + 1
			cols <- cols[ cols <= ncols(raster) ]
			rows <- (0:round(nrows(raster)/skip)) * skip + 1
			rows <- rows[ rows <= nrows(raster) ]
			
			m <- m[rows, cols]

			xres <- (xmax(raster) - xmin(raster) ) / dim(m)[2]
			yres <- (ymax(raster) - ymin(raster) ) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + xmin(raster) 
			y <- (0:dim(m)[1]) * yres + ymin(raster) 
 		} else {	
			x <- (0:ncols(raster)) * xres(raster) + xmin(raster) 
			y <- (0:nrows(raster)) * yres(raster) + ymin(raster) 	
		}	
	} else {
		if (subsample) {
			m <- .read.skip(raster, maxdim) 
			xres <- (xmax(raster) - xmin(raster)) / dim(m)[2]
			yres <- (ymax(raster) - ymin(raster) ) / dim(m)[1]
			x <- (0:dim(m)[2]) * xres + xmin(raster) 
			y <- (0:dim(m)[1]) * yres + ymin(raster) 
		} else {
			raster <- read.all(raster)
			m <- values(raster, format='matrix')
			x <- (0:ncols(raster)) * xres(raster) + xmin(raster) 
			y <- (0:nrows(raster)) * yres(raster) + ymin(raster) 
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

