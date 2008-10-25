\name{raster.set}
\alias{raster.set}
\alias{raster.set.filename}
\alias{raster.set.datatype}
\alias{raster.set.data}
\alias{raster.set.data.row}
\alias{raster.set.data.block}
\alias{raster.set.data.sparse}
\alias{raster.clear.data}
\alias{raster.set.rowcol}
\alias{raster.set.bbox}
\alias{raster.set.minmax}

\title{ Set properties of a raster object }

\description{
Use these functions to set name and datatype properties of a raster object. While you can access the slots of the object directly, you would do that at your own peril because the value of one raster property can affect values in other properties, and changing slot values may thus break the integrity of the objects. Using slots directly may also lead to code to break in the future if underlying class definitions change. 
  
}

\usage{
raster.set(raster, filename=NA)
raster.set.filename(raster, filename)
raster.set.datatype(raster, datatype, datasize)
raster.set.data(raster, data) 
raster.set.data.row(raster, rowdata, rownr) 
raster.set.data.block(raster, blockdata, firstcell, lastcell) 
raster.set.data.sparse(raster, sparsedata, indices) 
raster.clear.data(raster)
raster.set.rowcol(raster, nrows=raster.nrows(raster), ncols=raster.ncols(raster)) 
raster.set.bbox(raster, xmin=raster.xmin(raster), xmax=raster.xmax(raster), ymin=raster.ymin(raster), ymax=raster.ymax(raster))
raster.set.minmax(raster)
}

\arguments{
  \item{raster}{ A \code{Raster} object }
  \item{filename}{ filename of raster, can be blank }
  \item{datatype}{ the type of data ('numeric' or 'integer' that will be written to disk }
  \item{datasize}{ The size, in number of bytes, that wil be written to disk. typically 4 for integer, and 8 for numeric datatype }
  \item{data}{ Data values to associate with the raster object. There should be values for all cells }
  \item{rowdata}{ Data values to associate with the raster object for a single row }
  \item{rownr}{ row number, between 1 and raster@nrows }
  \item{blockdata}{ Data values to associate with the raster object for a block of data, i.e. a rectangular area within the entire raster }
  \item{firstcell}{ first cell (upper left corner) of the blockdata }
  \item{lastcell}{ last cell (upper left corner) of the blockdata }
  \item{sparsedata}{ not implemented yet -- sparse data values. I.e. values for a number of raster cells }
  \item{indices}{ the cell numbers corresponding to the sparse data }
  \item{nrows}{ the new number of rows for the raster }
  \item{ncols}{ the new number of cols for the raster }  
  \item{xmin}{ the new minimum x coordinate of the raster }
  \item{xmax}{ the new maximum x coordinate of the raster }
  \item{ymin}{ the new minimum y coordinate of the raster }
  \item{ymax}{ the new maximum y coordinate of the raster }
}

\details{
raster.set copies the parameters of a Raster object to a new object, but does not copy the filename nor the data associated with the original raster. 
}

\value{
	a raster object
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{ 
	rs <- raster.new()
	rs
	rs <- raster.set.filename(rs, "c:/test.grd")
	rs <- raster.set.rowcol(rs, nrows=18, ncols=36) 
	rs
}

\keyword{ spatial }
