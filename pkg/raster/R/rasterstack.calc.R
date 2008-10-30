# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

rasterstack.calc <- function(rasterstack, fun, filename=NA, overwrite=FALSE, ForceIntOutput=FALSE) {
	if (length(fun(seq(1:5))) > 1) { stop("function 'fun' used returns more than one value") }

	outraster <- raster.set(rasterstack@rasters[[1]])
	outraster <- set.filename(outraster, filename)
	if (is.na(filename)) {
		rasterstack <- rasterstack.read.all(rasterstack)
		outraster <- raster.set.values(outraster, apply(rasterstack@data@values, 1, fun)) 
	} else {
		if (ForceIntOutput) { outraster <- raster.set.datatype(outraster, "integer") }
		for (r in 1:rasterstack@nrows) {
			rasterstack <- rasterstack.read.row(rasterstack, r)
			vals <- apply(rasterstack@data@values, 1, fun)
			outraster <- raster.set.values.row(outraster, vals, r) 
			outraster <- raster.write.row(outraster, overwrite)
		}
	}		
	return(outraster)
}

#		res <- vector(mode = "numeric", length = rasterstack@ncols)

#		for (cl in 1:rasterstack@ncols) {
#			celldata <- na.omit([cl,]) 
#			if (length(celldata) == 0) { res[cl] <- NA }
#			else { res[cl] <- fun(celldata) } 
#		}	
