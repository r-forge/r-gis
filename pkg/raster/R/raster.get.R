# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  October 2008
# Version 0,2
# Licence GPL v3


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

