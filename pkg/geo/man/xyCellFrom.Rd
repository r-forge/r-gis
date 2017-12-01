\name{xyRowColCell}

\alias{xFromCol}
\alias{xFromCol,GeoRaster,numeric-method}
\alias{yFromRow}
\alias{yFromRow,GeoRaster,numeric-method}
\alias{xyFromCell}
\alias{xyFromCell,GeoRaster,numeric-method}
\alias{xFromCell}
\alias{xFromCell,GeoRaster,numeric-method}
\alias{yFromCell}
\alias{yFromCell,GeoRaster,numeric-method}
\alias{cellFromRowCol}
\alias{cellFromRowCol,GeoRaster,numeric,numeric-method}
\alias{colFromX}
\alias{colFromX,GeoRaster,numeric-method}
\alias{rowFromY}
\alias{rowFromY,GeoRaster,numeric-method}
\alias{cellFromXY}
\alias{cellFromXY,GeoRaster,matrix-method}
\alias{rowFromCell}
\alias{rowFromCell,GeoRaster,numeric-method}
\alias{colFromCell}
\alias{colFromCell,GeoRaster,numeric-method}
\alias{rowColFromCell}
\alias{rowColFromCell,GeoRaster,numeric-method}
\alias{cellFromXY}
\alias{cellFromXY,GeoRaster,matrix-method}

  
\title{Coordinates from a row, column or cell number and vice versa}

\description{
Get coordinates of the center of raster cells for a row, column, or cell number of a GeoRaster object.
Or get row, column, or cell numbers from coordinates or from each other.

Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom.
The last cell number equals the number of cells of the GeoRaster object.
row numbers start at 1 at the top, column numbers start at 1 at the left.
}

\usage{
\S4method{xFromCol}{GeoRaster,numeric}(object, col)
\S4method{yFromRow}{GeoRaster,numeric}(object, row)
\S4method{xyFromCell}{GeoRaster,numeric}(object, cell, ...)
\S4method{xFromCell}{GeoRaster,numeric}(object, cell)
\S4method{yFromCell}{GeoRaster,numeric}(object, cell)
\S4method{colFromX}{GeoRaster,numeric}(object, x)
\S4method{rowFromY}{GeoRaster,numeric}(object, y)
\S4method{cellFromRowCol}{GeoRaster,numeric,numeric}(object, row, col)
\S4method{rowFromCell}{GeoRaster,numeric}(object, cell)
\S4method{colFromCell}{GeoRaster,numeric}(object, cell)
\S4method{rowColFromCell}{GeoRaster,numeric}(object, cell)
\S4method{cellFromXY}{GeoRaster,matrix}(object, xy)
}


\arguments{
  \item{object}{GeoRaster objectect}
  \item{cell}{integer. cell number(s)}
  \item{col}{integer. column number(s)}
  \item{row}{integer row number(s)}
  \item{x}{x coordinate(s)}
  \item{y}{y coordinate(s)}
  \item{xy}{matrix of x and y coordinates}
  \item{...}{additional arguments. None implemented}  
}
  
\details{
Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom.
The last cell number equals the number of cells of the GeoRaster objectect.
}

\value{
xFromCol, yFromCol, xFromCell, yFromCell: vector of x or y coordinates 

xyFromCell: matrix(x,y) with coordinate pairs 

colFromX, rowFromY, cellFromXY, cellFromRowCol, rowFromCell, colFromCell: vector of row, column, or cell numbers

rowColFromCell: matrix of row and column numbers
}


\examples{
r <- georst()

xFromCol(r, c(1, 120, 180))
yFromRow(r, 90)
xyFromCell(r, 10000)
xyFromCell(r, c(0, 1, 32581, ncell(r), ncell(r)+1))

cellFromRowCol(r, 5, 5)
cellFromRowCol(r, 1:2, 1:2)
cellFromRowCol(r, 1, 1:3)

colFromX(r, 10)
rowFromY(r, 10)
cellFromXY(r, cbind(c(10,5), c(15, 88)))
}

\keyword{spatial}
