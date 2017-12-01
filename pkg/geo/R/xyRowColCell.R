# Author: Robert J. Hijmans
# Date :  October 2017
# Version 1.0
# Licence GPL v3

yFromRow <- function(obj, row) {
	obj@ptr$yFromRow(row - 1)
}	

xFromCol <- function(obj, col) {
	obj@ptr$xFromCol(col - 1)
}  

colFromX <- function(obj, x)	{
	obj@ptr$colFromX(x) + 1
}

rowFromY <- function(obj, y)	{
	obj@ptr$rowFromY(y) + 1
}	
	
cellFromXY <- function(obj, xy) {
	obj@ptr$cellFromXY(xy[,1], xy[,2]) + 1
}

cellFromRowCol <- function(obj, row, col) {
	obj@ptr$cellFromRowCol(row-1, col-1)
}
	
xyFromCell <- function(obj, cell) {
	xy <- obj@ptr$xyFromCell(cell-1)
	do.call(cbind, xy)
}

yFromCell <- function(obj, cell) {
	xyFromCell(obj, cell)[,2]
}  
	
xFromCell <- function(obj, cell) {
	xyFromCell(obj, cell)[,1]
}  


rowcolFromCell <- function(obj, cell) {
	rc <- obj@ptr$rowColFromCell(cell-1)
	do.call(cbind, rc)
}
	
rowFromCell <- function(obj, cell) {
	rowcolFromCell(obj, cell)[,1]
}

colFromCell <- function(obj, cell) {
	rowcolFromCell(obj, cell)[,2]
}


