\name{raster.properties}
\alias{raster.filename}
\alias{raster.values}
\alias{raster.maxvalue}
\alias{raster.minvalue}
\alias{raster.indices}
\alias{raster.content}
\alias{raster.source}
\alias{raster.ncols}
\alias{raster.nrows}
\alias{raster.ncells}
\alias{raster.xres}
\alias{raster.yres}
\alias{raster.resolution}
\alias{raster.boundingbox}
\alias{raster.xmin}
\alias{raster.xmax}
\alias{raster.ymin}
\alias{raster.ymax}
\alias{raster.projection}
\alias{raster.origin}

  
\title{ Get raster properties }
\description{
  raster.values returns data values that are associated with the raster object (e.g. after raster.read.* has been used). Data are returned as a vector. 
  the option format='matrix' will return a matrix, optionally with the row and col numbers (names=TRUE). 
  raster.get.col.from.cell etc. get the column, row, or cell number of a raster (or rasterstack) for a x and/or y coordinate or get the coordinates of the center of a raster cell from a column, or cell number(s)
}

\usage{
raster.filename(object)
raster.values(raster, format='vector', names=FALSE)
raster.minvalue(raster)
raster.maxvalue(raster)
raster.content(raster)
raster.indices(raster)
raster.source(raster)
raster.ncols(object)
raster.nrows(object)
raster.ncells(object)
raster.xres(object)
raster.yres(object)
raster.resolution(object)
raster.xmin(object)
raster.xmax(object)
raster.ymin(object)
raster.ymax(object)
raster.boundingbox(object)
raster.projection(object, asText=FALSE)
raster.origin(object)
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
raster.ncells(rs)
raster.get.col.from.cell(rs, 10000)
raster.get.row.from.cell(rs, 10000)
raster.get.col.from.x(rs, 0.5)
raster.get.row.from.y(rs, 0.5)
raster.get.cell.from.x.y(rs, 0.5, 0.5)
raster.get.cell.from.xy(rs, c(0.5, 0.5))
raster.get.x.from.col(rs, c(1, 120, 180))
raster.get.y.from.row(rs, 90)
raster.get.xy.from.cell(rs, 10000)
raster.get.xy.from.cell(rs, c(0, 1, 32581, raster.ncells(rs), raster.ncells(rs)+1))

#using a file from disk
rs <- raster.from.file(system.file("external/test.ag", package="sp"))
rs
raster.get.cell.from.x.y(rs, 180000, 330000)
#xy for corners of grid:
raster.get.xy.from.cell(rs, c(1, raster.ncols(rs), raster.nrows(rs), raster.ncells(rs)))
}
\keyword{ spatial }
