# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

rasterstack.calc <- function(rasterstack, fun, filename=NA, overwrite=FALSE, ForceIntOutput=FALSE) {
	if (length(fun(seq(1:10))) > 1) { stop("function 'fun' used returns more than one value") }

	out.raster <- rasterstack@rasters[[1]]
	if (is.na(filename)) {
		out.raster <- raster.set.filename(out.raster, "")
		rasterstack <- rasterstack.read.all(rasterstack)
		out.raster <- raster.set.data(out.raster, apply(rasterstack@data@values, 1, fun)) 
	} else {
		out.raster <- raster.set.filename(out.raster, filename)
		if (ForceIntOutput) { out.raster <- raster.set.datatype(out.raster, "integer") }
		for (r in 1:rasterstack@nrows) {
			rasterstack <- rasterstack.read.row(rasterstack, r)
			out.raster <- raster.set.data.row(out.raster, apply(rasterstack@data@values, 1, fun), rownr=r) 
			raster.write.row(out.raster, overwrite)
		}
	}		
	return(out.raster)
}

#		res <- vector(mode = "numeric", length = rasterstack@ncols)

#		for (cl in 1:rasterstack@ncols) {
#			celldata <- na.omit([cl,]) 
#			if (length(celldata) == 0) { res[cl] <- NA }
#			else { res[cl] <- fun(celldata) } 
#		}	
