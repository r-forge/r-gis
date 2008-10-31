# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3


r.overlay <- function(raster1, raster2, fun=function(x,y){return(x+y)}, filename="") {
	if (class(raster1) != 'Raster' | class(raster2) != 'Raster') {
		stop('first two arguments should be objects of class "Raster"')
	}
	if (!raster.compare(c(raster1, raster2))) { 
		stop() 
	}
	outraster <- raster.set(raster1)
	outraster <- set.filename(outraster, filename)
	if (raster.content(raster1) == 'all' & raster.content(raster2) == 'all') {
		vals <- fun( values(raster1), values(raster2) )
		outraster <- raster.set.values(outraster, vals)
		if (filename != "") { raster.write(outraster) }
	} else if (raster.source(raster1) == 'disk' & raster.source(raster2) == 'disk') {
		for (r in 1:nrows(outraster)) {
			raster1 <- raster.read.row(raster1, r)
			raster2 <- raster.read.row(raster2, r)
			vals <- fun(values(raster1), values(raster2))
			outraster <- raster.set.values.row(outraster, vals, r)
			outraster <- raster.write.row(outraster)
		}
	} else {
		stop('data must be either in memory or on disk')
	}
	return(outraster)
}


r.cover <- function(raster1, raster2, filename="") {
	if (class(raster1) != 'Raster' | class(raster2) != 'Raster') {
		stop('first two arguments should be objects of class "Raster"')
	}
	if (!raster.compare(c(raster1, raster2))) { 
		stop() 
	}
	outraster <- raster.set(raster1)
	outraster <- set.filename(outraster, filename)
	if (raster.content(raster1) == 'all' & raster.content(raster2) == 'all') {
		vals <- values(raster1)
		vals[is.na(vals)] <- values(raster2) 
		outraster <- raster.set.values(outraster, vals)
		if (filename != "") { raster.write(outraster) }
	} else if (raster.source(raster1) == 'disk' & raster.source(raster2) == 'disk') {
		for (r in 1:nrows(outraster)) {
			raster1 <- raster.read.row(raster1, r)
			raster2 <- raster.read.row(raster2, r)
			vals <- values(raster1)
			vals[is.na(vals)] <- values(raster2) 
			outraster <- raster.set.values.row(outraster, vals, r)
			outraster <- raster.write.row(outraster)
		}
	} else {
		stop('data must be either in memory or on disk')
	}
	return(outraster)
}


