\name{raster.get}
\alias{raster.get.data}
\alias{raster.get.ncols}
\alias{raster.get.nrows}
\alias{raster.get.ncells}
\alias{raster.get.xres}
\alias{raster.get.yres}
\alias{raster.get.col.from.cell}
\alias{raster.get.row.from.cell}
\alias{raster.get.cell.from.rowcol}
\alias{raster.get.col.from.x}
\alias{raster.get.row.from.y}
\alias{raster.get.cell.from.xy}
\alias{raster.get.cell.from.x.y}
\alias{raster.get.x.from.col}
\alias{raster.get.y.from.row}
\alias{raster.get.xy.from.cell}
\alias{raster.get.cxy.from.box}
\alias{raster.is.valid.cell}

  
\title{ Get raster property values or compute column, row, or cell number of a raster from coordinates and vice versa }
\description{
  raster.get.data returns datavalues that are associated with the raster object (e.g. after raster.read.* has been used). Data are returned as a vector. 
  raster.get.matrix will return a matrix, optionally with the row and col numbers as names of the whole or part of the data that has been previously 
  raster.get.ncells, nrows, ncols, xres, yres simply take the values from the data slots in the Raster or RasterStack object. It is advisable to use these and other 'get' and 'set' functions rather than dirctly accessing the slots of an object. This will ensure object integrity and ensure that code will not break in the future, even if the underlying class definitions change. 
  raster.get.col.from.cell etc. get the column, row, or cell number of a raster (or rasterstack) for a x and/or y coordinate or get the coordinates of the center of a raster cell from a column, or cell number(s)
}

\usage{
raster.get.data(raster, format='vector', names=FALSE)
raster.get.ncols(raster)
raster.get.nrows(raster)
raster.get.ncells(raster)
raster.get.xres(raster)
raster.get.yres(raster)
raster.get.col.from.cell(raster, cell)
raster.get.row.from.cell(raster, cell)
raster.get.cell.from.rowcol(raster, rownr, colnr)
raster.get.col.from.x(raster, x)
raster.get.row.from.y(raster, y)
raster.get.cell.from.x.y(raster, x, y)
raster.get.cell.from.xy(raster, xy)
raster.get.x.from.col(raster, colnr)
raster.get.y.from.row(raster, rownr)
raster.get.xy.from.cell(raster, cell)
raster.get.cxy.from.box(raster, xmin=raster@xmin, xmax=raster@xmax, ymin=raster@ymin, ymax=raster@ymax)
raster.is.valid.cell(raster, cell) 
}

\arguments{
  \item{raster}{ raster or rasterstack object }
  \item{format}{ use \code{vector} to get the data as a single vector or \code{matrix} to get them as a matrix }
  \item{names}{ If TRUE, row and col names are provided }
  \item{x}{  x coordinate(s) }
  \item{y}{  y coordinate(s) }
  \item{xy}{ matrix of x and y coordinates }
  \item{colnr}{  column number(s) }
  \item{rownr}{  row number(s) }
  \item{cell}{  cell number(s) }
  \item{xmin}{ minimum x coordinate of bounding box to get cell numbers for }
  \item{xmax}{ maximum x coordinate of bounding box to get cell numbers for }
  \item{ymin}{ minimum y coordinate of bounding box to get cell numbers for }
  \item{ymax}{ maximum y coordinate of bounding box to get cell numbers for }
  
 }
  
\details{
  The get.col.from.cell and similar functions accept a single value (or x, y pair), or a vector or list of these values,
  Cell numbers start at 1 in the upper left corner, and increase from left to right, and then from top to bottom
  The last cell number equals the number of cells of the raster.
}
\value{
  row, col or cell number(s) 
  x or y coordinate(s)
  matrix(x,y) of pairs of coordinates 
  matrix(cell, x, y) of cellnumbers and x and y coordinates
  TRUE of FALSE for raster.is.valid.cell
}
\author{Robert J. Hijmans  \email{r.hijmans@gmail.com}}
\examples{
#using a new default raster (1 degree global)
rs <- raster.create.new()
raster.get.ncells(rs)
raster.get.col.from.cell(rs, 10000)
raster.get.row.from.cell(rs, 10000)
raster.get.col.from.x(rs, 0.5)
raster.get.row.from.y(rs, 0.5)
raster.get.cell.from.x.y(rs, 0.5, 0.5)
raster.get.cell.from.xy(rs, c(0.5, 0.5))
raster.get.x.from.col(rs, c(1, 120, 180))
raster.get.y.from.row(rs, 90)
raster.get.xy.from.cell(rs, 10000)
raster.get.xy.from.cell(rs, c(0, 1, 32581, rs@ncells, rs@ncells+1))

#using a file from disk
rs <- raster.create.from.file(system.file("external/test.ag", package="sp"))
rs
raster.get.cell.from.x.y(rs, 180000, 330000)
#xy for corners of grid:
raster.get.xy.from.cell(rs, c(1, rs@ncols, rs@nrows, rs@ncells))
}
\keyword{ spatial }
