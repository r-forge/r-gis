\name{cellFrom}

\alias{cellFromRowCol}
\alias{colFromX}
\alias{rowFromY}
\alias{cellFromXY}
\alias{rowFromCell}
\alias{colFromCell}
\alias{rowColFromCell}



  
\title{Get cell, row, or column number}

\description{
Get cell, row, or column number(s) for a GeoRaster from cell, row and/or column numbers, or from coordinates.   
Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom.
The last cell number equals the number of cells of the GeoRaster object.
row numbers start at 1 at the top, column numbers start at 1 at the left.
}

\usage{
cellFromRowCol(obj, rownr, colnr)
cellFromRow(obj, rownr)
cellFromCol(obj, colnr)
colFromX(obj, x)
rowFromY(obj, y)
cellFromXY(obj, xy)
rowFromCell(obj, cell)
colFromCell(obj, cell)
rowColFromCell(obj, cell)
}

\arguments{
  \item{obj}{GeoRaster object}
  \item{colnr}{column number; or vector of column numbers}
  \item{rownr}{row number; or vector of row numbers}
  \item{x}{x coordinate(s)}
  \item{y}{y coordinate(s)}
  \item{xy}{matrix of x and y coordinates}
}
  

\value{
vector of row, column or cell numbers, or matrix with coordinates. 
}

\seealso{
\code{\link{xyFromCell}}
}


\examples{
r <- georaster(ncols=10, nrows=10)
cellFromRowCol(r, 5, 5)
cellFromRowCol(r, 1:2, 1:2)
cellFromCol(r, 1)
cellFromRow(r, 1)

colFromX(r, 0.5)
rowFromY(r, 0.5)
cellFromXY(r, cbind(c(0.5,5), c(15, 88)))
}

\keyword{spatial}

