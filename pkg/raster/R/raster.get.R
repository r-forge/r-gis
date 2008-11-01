# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  October 2008
# Version 0,2
# Licence GPL v3


get.y.from.row <- function(raster, rownr) {
	rownr <- round(rownr)
	rownr[rownr < 1 | rownr > raster@nrows] <- NA
	y <- get.ymax(raster) - ((rownr-0.5) * get.yres(raster))
	return(y) }	
	
	
get.x.from.col <- function(raster, colnr) {
	colnr <- round(colnr)
	colnr[colnr < 1 | colnr > raster@ncols] <- NA
	x <- get.xmin(raster) + (colnr - 0.5) * get.xres(raster) 
	return(x) }  

	
get.row.from.cell <- function(raster, cell) {
	cell <- as.integer(round(cell))
	cell[cell < 1 | cell > get.ncells(raster)] <- NA
	rownr <- as.integer(trunc((cell-1)/raster@ncols) + 1)
#	rownr <- as.integer(trunc(cell / (raster@ncols+1)) + 1)
    return(rownr)
}


get.col.from.cell <- function(raster, cell) {
	cell <- as.integer(round(cell))
	cell[cell < 1 | cell > get.ncells(raster)] <- NA	
	rownr <- as.integer(trunc((cell-1)/raster@ncols) + 1)
	colnr <- as.integer(cell - ((rownr-1) * raster@ncols))
#	colnr <- as.integer(trunc(cell - (trunc(cell / (raster@ncols+1) )) * raster@ncols))
    return(colnr)
}


get.cell.from.x.y <- function(raster, x, y) {
	if (length(x) != length(y)) { stop("length(x) != length(y)") }
	cell <- vector(mode = "integer", length = length(x))
	cell[cell == 0] <- NA
	for (i in 1:length(x)) {
		colnr <- get.col.from.x(raster, x[i]) - 1
		rownr <- get.row.from.y(raster, y[i]) - 1
		if ((!is.na(colnr)) & (!is.na(rownr))) {
			cell[i] <- as.integer((rownr * raster@ncols + colnr) + 1)
		}
	}
	return(cell)
}
	
	
get.cell.from.xy <- function(raster, xy) {
	if (is.null(dim(xy))) { 
		x <- xy[1]
		y <- xy[2] }
	else { 
		x <- xy[,1]
		y <- xy[,2] }
	return( get.cell.from.x.y(raster, x, y) )
}


get.cell.from.rowcol <- function(raster, rownr, colnr) {
	rownr <- round(rownr)
	colnr <- round(colnr)
	rownr[rownr < 1 | rownr > raster@nrows] <- NA
	colnr[colnr < 1 | colnr > raster@ncols] <- NA	
	return((rownr-1) * raster@ncols + colnr)
}

get.col.from.x <- function ( raster, x )	{
	colnr <- (trunc((x - get.xmin(raster)) / get.xres(raster))) + 1 
	colnr[x == get.xmax(raster)] <- get.ncols(raster)
	colnr[x < get.xmin(raster) | x > get.xmax(raster) ] <- NA
	return(colnr) }
	
	
get.row.from.y <- function ( raster, y )	{
	rownr <- 1 + (trunc((get.ymax(raster) - y) / get.yres(raster)))
	rownr[y == get.ymin(raster) ] <- raster@nrows 
	rownr[y > get.ymax(raster) | y < get.ymin(raster)] <- NA
	return(rownr)
}	
	

get.xy.from.cell <- function(raster, cell) {
	cell <- round(cell)
	xy <- matrix(data = NA, ncol=2, nrow=length(cell))
	colnr <- get.col.from.cell(raster, cell)
	rownr <- get.row.from.cell(raster, cell)
	xy[,1] <- get.x.from.col(raster, colnr)
	xy[,2] <- get.y.from.row(raster, rownr) 		

	colnames(xy) <- c("x", "y")

	return(xy) }  
	
	
get.cxy.from.box <- function(raster, xmin=get.xmin(raster), xmax=get.xmax(raster), ymin=get.ymin(raster), ymax=get.ymax(raster)) {
	firstrow <- get.row.from.y(raster, ymax)
	lastrow <- get.row.from.y(raster, ymin)
	firstcol <- get.col.from.x(raster, xmin)
	lastcol <- get.col.from.x(raster, xmax)
	cells <- vector("integer", length=0)
# RH: ouch, this should be done with apply 	
	for (i in firstrow:lastrow) {
		firstcell <- (i-1) * raster@ncols + firstcol
		lastcell <- (i-1) * raster@ncols + lastcol
		cells <- append(cells, c(firstcell:lastcell))
	}
	cxy <- cbind(cells, get.xy.from.cell(raster, cells))
	return(cxy)
}


is.valid.cell <- function(raster, cell) {
	cell <- round(cell)
	validcell <- vector(length=length(cell))
	validcell[cell > 0 & cell <= get.ncells(raster)] <- TRUE
	return(validcell)
}

