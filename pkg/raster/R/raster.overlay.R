# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3


calc.overlay <- function(raster1, raster2, fun=function(x,y){return(x+y)}, filename="", overwrite=TRUE) {
	if (class(raster1) != 'Raster' | class(raster2) != 'Raster') {
		stop('first two arguments should be objects of class "Raster"')
	}
	if (!compare(c(raster1, raster2))) { 
		stop() 
	}
	outraster <- set.raster(raster1)
	outraster <- set.filename(outraster, filename)
	if ( get.content(raster1) == 'all' &  get.content(raster2) == 'all') {
		vals <- fun( get.values(raster1), get.values(raster2) )
		outraster <- set.values(outraster, vals)
		if (filename != "") { write.raster(outraster, overwrite=overwrite) }
	} else if ( get.source(raster1) == 'disk' &  get.source(raster2) == 'disk') {
		for (r in 1:get.nrows(outraster)) {
			raster1 <- read.row(raster1, r)
			raster2 <- read.row(raster2, r)
			vals <- fun(get.values(raster1), get.values(raster2))
			outraster <- set.values.row(outraster, vals, r)
			outraster <- write.row(outraster, overwrite=overwrite)
		}
	} else {
		stop('data must be either in memory or on disk')
	}
	return(outraster)
}


calc.cover <- function(raster1, raster2, filename="", overwrite=TRUE) {
	if (class(raster1) != 'Raster' | class(raster2) != 'Raster') {
		stop('first two arguments should be objects of class "Raster"')
	}
	if (!compare(c(raster1, raster2))) { 
		stop() 
	}
	outraster <- set.raster(raster1)
	outraster <- set.filename(outraster, filename)
	if ( get.content(raster1) == 'all' &  get.content(raster2) == 'all') {
		vals <- get.values(raster1)
		vals[is.na(vals)] <- get.values(raster2) 
		outraster <- set.values(outraster, vals)
		if (filename != "") { write.raster(outraster, overwrite=overwrite) }
	} else if ( get.source(raster1) == 'disk' &  get.source(raster2) == 'disk') {
		for (r in 1:get.nrows(outraster)) {
			raster1 <- read.row(raster1, r)
			raster2 <- read.row(raster2, r)
			vals <- get.values(raster1)
			vals[is.na(vals)] <- get.values(raster2) 
			outraster <- set.values.row(outraster, vals, r)
			outraster <- write.row(outraster, overwrite=overwrite)
		}
	} else {
		stop('data must be either in memory or on disk')
	}
	return(outraster)
}


