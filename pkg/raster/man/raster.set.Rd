\name{raster.set}
\alias{raster.set.filename}
\alias{raster.set.datatype}
\alias{raster.set.data}
\alias{raster.set.data.row}
\alias{raster.set.data.block}
\alias{raster.set.data.sparse}
\alias{raster.set.rowcol}
\alias{raster.set.bbox}

\title{ Set properties of a raster object }

\description{
  Use these functions to set name and datatype properties of a raster object. While you can access the 
  slots of the object directly, you would do that at your own peril. These methods are safer as the change in
  the value of one raster property can affect values in other properties
}

\usage{
raster.set.filename(raster, filename)
raster.set.datatype(raster, datatype, datasize)
raster.set.data(raster, data) 
raster.set.data.row(raster, rowdata, rownr) 
raster.set.data.block(raster, blockdata, firstcell, lastcell) 
raster.set.data.sparse(raster, sparsedata, indices) 
raster.set.rowcol(raster, nrows=raster@nrows, ncols=raster@ncols) 
raster.set.bbox(raster, xmin=raster@xmin, xmax=raster@xmax, ymin=raster@ymin, ymax=raster@ymax)
}

\arguments{
  \item{raster}{ ~~Describe \code{raster} here~~ }
  \item{filename}{ ~~Describe \code{filename} here~~ }
  \item{datatype}{ ~~Describe \code{filename} here~~ }
  \item{datasize}{ ~~Describe \code{filename} here~~ }
  \item{data}{ ~~Describe \code{filename} here~~ }
  \item{rowdata}{ ~~Describe \code{filename} here~~ }
  \item{rownr}{ ~~Describe \code{filename} here~~ }
  \item{blockdata}{ ~~Describe \code{filename} here~~ }
  \item{firstcell}{ ~~Describe \code{filename} here~~ }
  \item{lastcell}{ ~~Describe \code{filename} here~~ }
  \item{sparsedata}{ ~~Describe \code{filename} here~~ }
  \item{indices}{ ~~Describe \code{filename} here~~ }
  \item{nrows}{ ~~Describe \code{filename} here~~ }
  \item{ncols}{ ~~Describe \code{filename} here~~ }  
  \item{xmin}{ ~~Describe \code{filename} here~~ }
  \item{xmax}{ ~~Describe \code{filename} here~~ }
  \item{ymin}{ ~~Describe \code{filename} here~~ }
  \item{ymax}{ ~~Describe \code{filename} here~~ }
}

\details{
}

\value{
	a raster object
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{ 
}

\keyword{ spatial }
