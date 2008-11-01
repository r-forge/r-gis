\name{properties}
\alias{get.filename}
\alias{get.values}
\alias{get.ncols}
\alias{get.nrows}
\alias{get.ncells}
\alias{get.xres}
\alias{get.yres}
\alias{get.resolution}
\alias{get.xmin}
\alias{get.xmax}
\alias{get.ymin}
\alias{get.ymax}
\alias{get.projection}
\alias{get.origin}
\alias{get.boundingbox}
\alias{get.maxvalue}
\alias{get.minvalue}
\alias{get.indices}
\alias{get.content}
\alias{get.source}

  
  
\title{ Get raster properties }
\description{
  get.values returns data values that are associated with the raster object (e.g. after read.* has been used). Data are returned as a vector. 
  the option format='matrix' will return a matrix, optionally with the row and col numbers (names=TRUE). 
  get.col.from.cell etc. get the column, row, or cell number of a raster (or rasterstack) for a x and/or y coordinate or get the coordinates of the center of a raster cell from a column, or cell number(s)
  use bbox() (form sp) to get the bounding box of a raster type object.
  
}

\usage{
get.filename(object)
get.values(object, format='vector', names=FALSE)
get.ncols(object)
get.nrows(object)
get.ncells(object)
get.xres(object)
get.yres(object)
get.resolution(object)
get.xmin(object)
get.xmax(object)
get.ymin(object)
get.ymax(object)
get.projection(object, asText=TRUE)
get.origin(object)
get.boundingbox(object)
get.minvalue(raster)
get.maxvalue(raster)
get.content(raster)
get.indices(raster)
get.source(raster)
}

\arguments{
  \item{raster}{ raster or rasterstack object }
  \item{object}{ raster or rasterstack object }
  \item{format}{ use \code{vector} to get the data as a single vector or \code{matrix} to get them as a matrix }
  \item{asText} { logical. If \code{TRUE}, the projection is returned as text. Otherwise a CRS object is returned}
  \item{names}{ If TRUE, row and col names are provided }
 }
  

\note{
  Some of these functions simply take the values from the data slots in the Raster or RasterStack object. It is advisable to use these and other 'get' and 'set' functions rather than dirctly accessing the slots of an object. This will ensure object integrity and ensure that code will not break in the future, even if the underlying class definitions change. 
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
rs <- raster.new()
get.ncells(rs)
get.col.from.cell(rs, 10000)
get.row.from.cell(rs, 10000)
get.col.from.x(rs, 0.5)
get.row.from.y(rs, 0.5)
get.cell.from.x.y(rs, 0.5, 0.5)
get.cell.from.xy(rs, c(0.5, 0.5))
get.x.from.col(rs, c(1, 120, 180))
get.y.from.row(rs, 90)
get.xy.from.cell(rs, 10000)
get.xy.from.cell(rs, c(0, 1, 32581, get.ncells(rs), get.ncells(rs)+1))

#using a file from disk
rs <- raster.from.file(system.file("external/test.ag", package="sp"))
rs
get.cell.from.x.y(rs, 180000, 330000)
#xy for corners of grid:
get.xy.from.cell(rs, c(1, get.ncols(rs), get.nrows(rs), get.ncells(rs)))
}
\keyword{ spatial }
