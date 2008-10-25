# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.ncols <- function(object) {
	return(object@ncols)
}

raster.nrows <- function(object) {
	return(object@nrows)
}

raster.ncells <- function(object) {
	return( as.numeric(object@nrows) * object@ncols )
}

raster.xmin <- function(object) {
	return (object@bbox[1,1])
}

raster.xmax <- function(object) {
	return (object@bbox[1,2])
}

raster.ymin <- function(object) {
	return (object@bbox[2,1])
}

raster.ymax <- function(object) {
	return (object@bbox[2,2])
}

.raster.zmin <- function(object) {
	return (object@bbox[3,1])
}

.raster.zmax <- function(object) {
	return (object@bbox[3,2])
}

raster.xres <- function(object) {
	return ( (raster.xmax(object) - raster.xmin(object)) / raster.ncols(object)  )
}

raster.yres <- function(object) {
	return ( (raster.ymax(object) - raster.ymin(object)) / raster.nrows(object)  )
}

raster.content <- function(raster) {
	return(raster@data@content)
}

raster.indices <- function(raster) {
	return(raster@data@indices)
}

raster.source <- function(raster) {
	return(raster@data@source)
}


raster.values <- function(raster, format='vector', names=FALSE) {
	if (raster@data@content=="nodata") {stop("first read some data (e.g., raster.read.all()") }
	if (format=='matrix') {  return(.raster.get.matrix(raster, names)) 
	} else { return(raster@data@values) 
	}
}



raster.get.y.from.row <- function(raster, rownr) {
	rownr <- round(rownr)
	rownr[rownr < 1 | rownr > raster@nrows] <- NA
	y <- raster.ymax(raster) - ((rownr-0.5) * raster.yres(raster))
	return(y) }	
	
	
raster.get.x.from.col <- function(raster, colnr) {
	colnr <- round(colnr)
	colnr[colnr < 1 | colnr > raster@ncols] <- NA
	x <- raster.xmin(raster) + (colnr - 0.5) * raster.xres(raster) 
	return(x) }  

	
raster.get.row.from.cell <- function(raster, cell) {
	cell <- as.integer(round(cell))
	cell[cell < 1 | cell > raster.ncells(raster)] <- NA
	rownr <- as.integer(trunc((cell-1)/raster@ncols) + 1)
#	rownr <- as.integer(trunc(cell / (raster@ncols+1)) + 1)
    return(rownr)
}


raster.get.col.from.cell <- function(raster, cell) {
	cell <- as.integer(round(cell))
	cell[cell < 1 | cell > raster.ncells(raster)] <- NA	
	rownr <- as.integer(trunc((cell-1)/raster@ncols) + 1)
	colnr <- as.integer(cell - ((rownr-1) * raster@ncols))
#	colnr <- as.integer(trunc(cell - (trunc(cell / (raster@ncols+1) )) * raster@ncols))
    return(colnr)
}


raster.get.cell.from.x.y <- function(raster, x, y) {
	if (length(x) != length(y)) { stop("length(x) != length(y)") }
	cell <- vector(mode = "integer", length = length(x))
	cell[cell == 0] <- NA
	for (i in 1:length(x)) {
		colnr <- raster.get.col.from.x(raster, x[i]) - 1
		rownr <- raster.get.row.from.y(raster, y[i]) - 1
		if ((!is.na(colnr)) & (!is.na(rownr))) {
			cell[i] <- as.integer((rownr * raster@ncols + colnr) + 1)
		}
	}
	return(cell)
}
	
	
raster.get.cell.from.xy <- function(raster, xy) {
	if (is.null(dim(xy))) { 
		x <- xy[1]
		y <- xy[2] }
	else { 
		x <- xy[,1]
		y <- xy[,2] }
	return( raster.get.cell.from.x.y(raster, x, y) )
}


raster.get.cell.from.rowcol <- function(raster, rownr, colnr) {
	rownr <- round(rownr)
	colnr <- round(colnr)
	if (rownr < 1)  { stop(paste('rownr should be between 1 -',raster@nrows)) }
	if (rownr > raster@nrows) { stop(paste('rownr should be between 1 -',raster@nrows)) }
	if (colnr < 1)  { stop(paste('colnr should be between 1 -',raster@ncols)) }
	if (colnr > raster@ncols) { stop(paste('colnr should be between 1 -',raster@ncols)) }
	return((rownr-1) * raster@ncols + colnr)
}

raster.get.col.from.x <- function ( raster, x )	{
	colnr <- (trunc((x - raster.xmin(raster)) / raster.xres(raster))) + 1 
	colnr[x == raster.xmax(raster)] <- raster.ncols(raster)
	colnr[x < raster.xmin(raster) | x > raster.xmax(raster) ] <- NA
	return(colnr) }
	
	
raster.get.row.from.y <- function ( raster, y )	{
	rownr <- 1 + (trunc((raster.ymax(raster) - y) / raster.yres(raster)))
	rownr[y == raster.ymin(raster) ] <- raster@nrows 
	rownr[y > raster.ymax(raster) | y < raster.ymin(raster)] <- NA
	return(rownr)
}	
	

raster.get.xy.from.cell <- function(raster, cell) {
	cell <- round(cell)
	xy <- matrix(data = NA, ncol=2, nrow=length(cell))
	colnames(xy) <- c("x", "y")
	colnr <- raster.get.col.from.cell(raster, cell)
	rownr <- raster.get.row.from.cell(raster, cell)
	xy[,1] <- raster.get.x.from.col(raster, colnr)
	xy[,2] <- raster.get.y.from.row(raster, rownr) 		
	return(xy) }  
	
	
raster.get.cxy.from.box <- function(raster, xmin=raster.xmin(raster), xmax=raster.xmax(raster), ymin=raster.ymin(raster), ymax=raster.ymax(raster)) {
	firstrow <- raster.get.row.from.y(raster, ymax)
	lastrow <- raster.get.row.from.y(raster, ymin)
	firstcol <- raster.get.col.from.x(raster, xmin)
	lastcol <- raster.get.col.from.x(raster, xmax)
	cells <- vector("integer", length=0)
# RH: ouch, this should be done with apply 	
	for (i in firstrow:lastrow) {
		firstcell <- (i-1) * raster@ncols + firstcol
		lastcell <- (i-1) * raster@ncols + lastcol
		cells <- append(cells, c(firstcell:lastcell))
	}
	cxy <- cbind(cells, raster.get.xy.from.cell(raster, cells))
	return(cxy)
}


raster.is.valid.cell <- function(raster, cell) {
	cell <- round(cell)
	validcell <- vector(length=length(cell))
	validcell[cell > 0 & cell <= raster.ncells(raster)] <- TRUE
	return(validcell)
}


.raster.get.matrix <- function(raster, names=FALSE) {
	if (raster@data@content=="nodata") {stop("first read some data (e.g., raster.read.all() or raster.read.row()") }
	
	if (raster@data@content=="all") {
		mdata <- matrix(raster@data@values, nrow=raster@nrows, ncol=raster@ncols, byrow=TRUE)
		if (names) {
			colnames(mdata) <- seq(1:raster@ncols)
			rownames(mdata) <- seq(1:raster@nrows)
		}	
		return(mdata)

	} else if (raster@data@content=="sparse") {
		stop("sparse data matrix not implemented yet")

	} else if (raster@data@content=="row") {
		mdata <- matrix(raster@data@values, nrow=1, ncol=raster@ncols, byrow=TRUE)
		if (names) {
			colnames(mdata) <- seq(1:raster@ncols)
			therow <- raster.get.row.from.cell(raster, raster@data@indices[1])
			rownames(mdata) <- therow
		}
		return(mdata)
		
	} else if (raster@data@content=="block") {
		startrow <- raster.get.row.from.cell(raster, raster@data@indices[1])
		startcol <- raster.get.col.from.cell(raster, raster@data@indices[1])
		endrow <- raster.get.row.from.cell(raster, raster@data@indices[2])
		endcol <- raster.get.col.from.cell(raster, raster@data@indices[2])
		ncols <- 1 + endcol - startcol
		nrows <- 1 + endrow - startrow
		
		mdata <- as.matrix(t(raster@data@values[1:ncols]))
		if (nrows > 1) {
			for (i in 2:nrows) {
				arow <- raster@data@values[((i-1)*ncols+1):((i-1)*ncols+ncols)]
				mdata <- rbind(mdata, t(arow))
			}
		}
		if (names) {
			rowlist <- list()
			for (i in 1:nrows) {
				r <- startrow + i - 1
				rowlist[i] <- paste(r, sep="")
				rownames(mdata) <- rowlist
				colnames(mdata) <- seq(1:ncols)+startcol-1
			}	
		}
		return(mdata)
	}	
}

