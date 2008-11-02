# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date : June 2008
# Version 0,1
# Licence GPL v3

.stack.read.all <- function(rstack) {
	rstack <- .stack.read.part.of.row(rstack, rownumber=-1)
	return(rstack)
}


.stack.read.row <- function(rstack, rownumber) {
	return(.stack.read.part.of.row(rstack, rownumber))
}


.stack.read.part.of.row <- function(rstack, rownumber, startcol=1, ncolumns=(ncols(rstack)-startcol+1)) {
	for (i in 1:length(rstack@rasters)) {
		rs <- .raster.read.part.of.row(rstack@rasters[[i]], rownumber, startcol, ncolumns)
		if ( i == 1 )  {
			rstack@data@values <- as.matrix( values(rs) )
		}
		else {
			rstack@data@values <- cbind(values(rstack), values(rs)) 
		}	   
	}
	rstack@data@content <- data.content(rs)
	rstack@data@indices <- data.indices(rs)
	return(rstack)
}


stack.read.xy <- function(rstack, xy) {
	cells <- get.cell.from.xy(rstack, xy)
	return(stack.read.cells(rstack, cells))
}


stack.read.cells <- function(rstack, cells) {
	for (i in 1:length(rstack@rasters)) {
		v <- read.cells(rstack@rasters[[i]], cells)
		if (i == 1) {
			result <- v
		} else {
			result <- cbind(result, v[,2])
#			colnames(result)[length(result[1,])] <- rstack@rasters[[i]]@file@shortname
		}
	}
	rstack@data@values <- as.matrix(result)
	return(rstack)
}


