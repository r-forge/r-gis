\name{xyCell}

\alias{xCol}
\alias{yRow}
\alias{xyCell}
\alias{xCell}
\alias{yCell}

\alias{cellRowCol}
\alias{colX}
\alias{rowY}
\alias{cellXY}
\alias{rowCell}
\alias{colCell}
\alias{rowcolCell}


  
\title{Coordinates from a row, column or cell number and vice versa}

\description{
Get coordinates of the center of raster cells for a row, column, or cell number of a GeoRaster object.
Or get row, column, or cell numbers from coordinates or from each other.

Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom.
The last cell number equals the number of cells of the GeoRaster object.
row numbers start at 1 at the top, column numbers start at 1 at the left.
}

\usage{
xCol(obj, col)
yRow(obj, row)
xyCell(obj, cell)
xCell(obj, cell)
yCell(obj, cell)
colX(obj, x)
rowY(obj, y)
cellXY(obj, xy)
cellRowCol(obj, row, col)
rowCell(obj, cell)
colCell(obj, cell)
rowcolCell(obj, cell)
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
xCol, yCol, xCell, yCell: vector of x or y coordinates 

xyCell: matrix(x,y) with coordinate pairs 
}


\seealso{
\code{\link{cellXY}}
}

\examples{
r <- rst()

xCol(r, c(1, 120, 180))
yRow(r, 90)
xyCell(r, 10000)
xyCell(r, c(0, 1, 32581, ncell(r), ncell(r)+1))

cellRowCol(r, 5, 5)
cellRowCol(r, 1:2, 1:2)

colX(r, 10)
rowY(r, 10)
cellXY(r, cbind(c(10,5), c(15, 88)))

}

\keyword{spatial}
