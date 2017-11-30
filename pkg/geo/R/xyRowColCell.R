# Author: Robert J. Hijmans
# Date :  October 2008
# Version 1.0
# Licence GPL v3

yRow <- function(obj, row) {
	obj@ptr$yFromRow(row - 1)
}	

xCol <- function(obj, col) {
	obj@ptr$xFromCol(col - 1)
}  

colX <- function(obj, x)	{
	obj@ptr$colFromX(x) + 1
}

rowY <- function(obj, y)	{
	obj@ptr$rowFromY(y) + 1
}	
	
cellXY <- function(obj, xy) {
	obj@ptr$cellFromXY(xy[,1], xy[,2]) + 1
}

cellRowCol <- function(obj, row, col) {
	obj@ptr$cellFromRowCol(row-1, col-1)
}
	
xyCell <- function(obj, cell) {
	xy <- obj@ptr$xyFromCell(cell-1)
	do.call(cbind, xy)
}

yCell <- function(obj, cell) {
	xyCell(obj, cell-1)[,2]
}  
	
xCell <- function(obj, cell) {
	xyCell(obj, cell-1)[,1]
}  


rowcolCell <- function(obj, cell) {
	rc <- obj@ptr$rowColFromCell(cell-1)
	do.call(cbind, rc)
}
	
rowCell <- function(obj, cell) {
	rowcolCell(obj, cell-1)[,1]
}

colCell <- function(obj, cell) {
	rowcolCell(obj, cell-1)[,2]
}


