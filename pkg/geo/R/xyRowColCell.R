# Author: Robert J. Hijmans
# Date :  October 2008
# Version 1.0
# Licence GPL v3

yFromRow <- function(obj, row) {
	obj@ptr$yFromRow(row)
}	

xFromCol <- function(obj, col) {
	obj@ptr$xFromCol(col)
}  

colFromX <- function(obj, x)	{
	obj@ptr$colFromX(x)
}

rowFromY <- function(obj, y)	{
	obj@ptr$rowFromY(y)
}	
	
cellFromXY <- function(obj, xy) {
	obj@ptr$cellFromXY(xy[,1], xy[,2])
}

cellFromRowCol <- function(obj, rownr, colnr) {
	obj@ptr$cellFromRowCol(rownr, colnr)
}
	
xyFromCell <- function(obj, cell) {
	xy <- obj@ptr$xyFromCell(cell)
	do.call(cbind, xy)
}

yFromCell <- function(obj, cell) {
	xyFromCell(obj, cell)[,2]
}  
	
xFromCell <- function(obj, cell) {
	xyFromCell(obj, cell)[,1]
}  


rowColFromCell <- function(obj, cell) {
	rc <- obj@ptr$rowColFromCell(cell)
	do.call(cbind, rc)
}
	
rowFromCell <- function(obj, cell) {
	rowColFromCell(obj, cell)[,1]
}

colFromCell <- function(obj, cell) {
	rowColFromCell(obj, cell)[,2]
}

