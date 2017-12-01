\name{xyRowColCell}

\alias{xFromCol}
\alias{yFromRow}
\alias{xyFromCell}
\alias{xFromCell}
\alias{yFromCell}

\alias{cellFromRowCol}
\alias{colFromX}
\alias{rowFromY}
\alias{cellFromXY}
\alias{rowFromCell}
\alias{colFromCell}
\alias{rowcolFromCell}


  
\title{Coordinates from a row, column or cell number and vice versa}

\description{
Get coordinates of the center of raster cells for a row, column, or cell number of a GeoRaster object.
Or get row, column, or cell numbers from coordinates or from each other.

Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom.
The last cell number equals the number of cells of the GeoRaster object.
row numbers start at 1 at the top, column numbers start at 1 at the left.
}

\usage{
xFromCol(obj, col)
yFromRow(obj, row)
xyFromCell(obj, cell)
xFromCell(obj, cell)
yFromCell(obj, cell)
colFromX(obj, x)
rowFromY(obj, y)
cellFromXY(obj, xy)
cellFromRowCol(obj, row, col)
rowFromCell(obj, cell)
colFromCell(obj, cell)
rowcolFromCell(obj, cell)
}


\arguments{
  \item{obj}{GeoRaster object}
  \item{cell}{integer. cell number(s)}
  \item{col}{integer. column number(s)}
  \item{row}{integer row number(s)}
  \item{x}{x coordinate(s)}
  \item{y}{y coordinate(s)}
  \item{xy}{matrix of x and y coordinates}
}
  
\details{
Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom.
The last cell number equals the number of cells of the GeoRaster object.
}

\value{
xFromCol, yFromCol, xFromCell, yFromCell: vector of x or y coordinates 

xyFromCell: matrix(x,y) with coordinate pairs 

colFromX, rowFromY, cellFromXY, cellFromRowCol, rowFromCell, colFromCell: vector of row, column, or cell numbers

rowcolFromCell: matrix of row and column numbers
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
