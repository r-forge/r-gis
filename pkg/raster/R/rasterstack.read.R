# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date : June 2008
# Version 0,1
# Licence GPL v3

 rasterstack.read.all <- function(rasterstack) {
	rasterstack <- rasterstack.read.part.of.row(rasterstack, rownumber=-1)
	return(rasterstack)
}


 rasterstack.read.row <- function(rasterstack, rownumber) {
	return(rasterstack.read.part.of.row(rasterstack, rownumber))
}


 rasterstack.read.part.of.row <- function(rasterstack, rownumber, startcol=1, ncols=(rasterstack@ncols-startcol+1)) {
	for (i in 1:length(rasterstack@rasters)) {
		rs <- raster.read.part.of.row(rasterstack@rasters[[i]], rownumber, startcol, ncols)
		if ( i == 1 )  {
			rasterstack@data@values <- as.matrix(raster.values(rs))
		}
		else {
			rasterstack@data@values <- cbind(rasterstack@data@values, raster.values(rs)) 
		}	   
	}
	rasterstack@data@content <- rs@data@content
	rasterstack@data@indices <- rs@data@indices
	return(rasterstack)
}


rasterstack.read.xy <- function(rasterstack, xy) {
	for (i in 1:length(rasterstack@rasters)) {
		v <- raster.read.xy(rasterstack@rasters[[i]], xy)
		if (i == 1) {
			result <- v
		} else {
			result <- cbind(result, v[,2])
			colnames(result)[length(result[1,])] <- rasterstack@rasters[[i]]@file@shortname
		}
	}
	rasterstack@data@values <- as.array(result)
	return(rasterstack)
}


rasterstack.read.cell <- function(rasterstack, cell) {
	for (i in 1:length(rasterstack@rasters)) {
		v <- raster.read.cells(rasterstack@rasters[[i]], cell)
		if (i == 1) {
			result <- v
		} else {
			result <- cbind(result, v[,2])
			colnames(result)[length(result[1,])] <- rasterstack@rasters[[i]]@file@shortname
		}
	}
	rasterstack@data@values <- as.array(result)
	return(rasterstack)
}


