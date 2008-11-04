\name{properties}
\alias{filename}
\alias{values}
\alias{ncols}
\alias{nrows}
\alias{ncells}
\alias{xres}
\alias{yres}
\alias{resolution}
\alias{xmin}
\alias{xmax}
\alias{ymin}
\alias{ymax}
\alias{projection}
\alias{boundingbox}
\alias{origin}
\alias{maxvalue}
\alias{minvalue}
\alias{data.indices}
\alias{data.content}
\alias{data.source}

  
  
\title{ Get raster properties }
\description{
  get.values returns data values that are associated with the raster object (e.g. after read.* has been used). Data are returned as a vector. 
  the option format='matrix' will return a matrix, optionally with the row and col numbers (names=TRUE). 
  get.col.from.cell etc. get the column, row, or cell number of a Raster (or RasterStack) for a x and/or y coordinate or get the coordinates of the center of a raster cell from a column, or cell number(s)
  use bbox() (form sp) to get the bounding box of a raster type object.
  
}

\usage{
filename(object)
values(object, format='vector', names=FALSE)
ncols(object)
nrows(object)
ncells(object)
xres(object)
yres(object)
resolution(object)
xmin(object)
xmax(object)
ymin(object)
ymax(object)
projection(object, asText=TRUE)
boundingbox(object)
origin(object)
minvalue(raster)
maxvalue(raster)
data.content(raster)
data.indices(raster)
data.source(raster)
}

\arguments{
  \item{raster}{ raster or stack object }
  \item{object}{ raster or stack object }
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
ncells(rs)
ncols(rs)
nrows(rs)
ncells(rs)
xres(rs)
yres(rs)
resolution(rs)
xmin(rs)
xmax(rs)
ymin(rs)
ymax(rs)
projection(rs)
origin(rs)
boundingbox(rs)

minvalue(rs)
maxvalue(rs)
data.content(rs)
data.indices(rs)
rs <- set.values(rs, 1:ncells(rs))
minvalue(rs)
maxvalue(rs)
data.source(rs)
data.content(rs)
data.indices(rs)

}
\keyword{ spatial }
