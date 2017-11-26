# Author: Robert J. Hijmans
# Date :  October 2008
# Version 1.0
# Licence GPL v3

yRow <- function(obj, row) {
	obj@ptr$yFromRow(row)
}	

xCol <- function(obj, col) {
	obj@ptr$xFromCol(col)
}  

colX <- function(obj, x)	{
	obj@ptr$colFromX(x)
}

rowY <- function(obj, y)	{
	obj@ptr$rowFromY(y)
}	
	
cellXY <- function(obj, xy) {
	obj@ptr$cellFromXY(xy[,1], xy[,2])
}

cellRowCol <- function(obj, row, col) {
	obj@ptr$cellFromRowCol(row, col)
}
	
xyCell <- function(obj, cell) {
	xy <- obj@ptr$xyFromCell(cell)
	do.call(cbind, xy)
}

yCell <- function(obj, cell) {
	xyCell(obj, cell)[,2]
}  
	
xCell <- function(obj, cell) {
	xyCell(obj, cell)[,1]
}  


rowcolCell <- function(obj, cell) {
	rc <- obj@ptr$rowColFromCell(cell)
	do.call(cbind, rc)
}
	
rowCell <- function(obj, cell) {
	rowcolCell(obj, cell)[,1]
}

colCell <- function(obj, cell) {
	rowcolCell(obj, cell)[,2]
}


