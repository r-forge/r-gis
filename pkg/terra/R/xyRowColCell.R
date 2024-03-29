# Author: Robert J. Hijmans
# Date :  October 2017
# Version 1.0
# License GPL v3

setMethod("yFromRow", signature(object="SpatRaster", row="numeric"), 
	function(object, row) {
		object@ptr$yFromRow(row - 1)
	}
)

setMethod(xFromCol, signature(object="SpatRaster", col="numeric"), 
	function(object, col) {
		object@ptr$xFromCol(col - 1)
	}  
)

setMethod(colFromX, signature(object="SpatRaster", x="numeric"), 
	function(object, x)	{
		cols <- object@ptr$colFromX(x) + 1
		cols[cols==0] <- NA
		cols
	}
)

setMethod(rowFromY, signature(object="SpatRaster", y="numeric"), 
	function(object, y)	{
		rows <- object@ptr$rowFromY(y) + 1
		rows[rows==0] <- NA
		rows
	}
)

setMethod(cellFromXY, signature(object="SpatRaster", xy="matrix"), 
	function(object, xy) {
		stopifnot(ncol(xy) == 2)
		#.checkXYnames(colnames(xy))
		object@ptr$cellFromXY(xy[,1], xy[,2]) + 1
	}
)

setMethod(cellFromRowCol, signature(object="SpatRaster", row="numeric", col="numeric"), 
	function(object, row, col, ...) {
		object@ptr$cellFromRowCol(row-1, col-1) + 1
	}
)

setMethod(cellFromRowColCombine, signature(object="SpatRaster", row="numeric", col="numeric"), 
	function(object, row, col, ...) {
		object@ptr$cellFromRowColCombine(row-1, col-1) + 1
	}
)


setMethod(xyFromCell, signature(object="SpatRaster", cell="numeric"), 
	function(object, cell, ...) {
		xy <- object@ptr$xyFromCell(cell-1)
		xy <- do.call(cbind, xy)
		colnames(xy) <- c("x", "y")
		xy
	}
)

setMethod(yFromCell, signature(object="SpatRaster", cell="numeric"), 
	function(object, cell) {
		xyFromCell(object, cell)[,2]
	}  

)

setMethod(xFromCell, signature(object="SpatRaster", cell="numeric"), 
	function(object, cell) {
		xyFromCell(object, cell)[,1]
	}  
)

setMethod(rowColFromCell, signature(object="SpatRaster", cell="numeric"), 
	function(object, cell) {
		rc <- object@ptr$rowColFromCell(cell-1)
		rc <- do.call(cbind, rc)
		rc[rc < 0] <- NA
		rc+1
	}
)

setMethod(rowFromCell, signature(object="SpatRaster", cell="numeric"), 
	function(object, cell) {
		rowColFromCell(object, cell)[,1]
	}
)

setMethod(colFromCell, signature(object="SpatRaster", cell="numeric"), 
	function(object, cell) {
		rowColFromCell(object, cell)[,2]
	}
)

