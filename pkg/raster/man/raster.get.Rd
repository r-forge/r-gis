\name{raster.get}
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


\title{ Get column, row, or cell number from coordinates and vice versa }
\description{
  Get the column, row, or cell number of a raster (or rasterstack) for a x and/or y coordinate or
  get the coordiantes of the center of a raster cell from a column, or cell number(s)
  There are relatively low-level operations that most users will not use. 
  They are needed for manipulating grids and point to grid conversion
}
\usage{
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

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{raster}{ raster or rasterstack object }
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
  All these functions accept a single value (or x, y pair), or a vector or list of these values,
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
rs
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
