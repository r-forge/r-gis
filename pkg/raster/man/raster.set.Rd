\name{raster.set}
\alias{raster.set.filename}
\alias{raster.set.datatype}

\title{ Set properties of a raster object }

\description{
  Use these functions to set name and datatype properties of a raster object. While you can access the 
  slots of the object directly, you would do that at your own peril. These methods are safer as the change in
  the value of one raster property can affect values in other properties
}

\usage{
raster.set.filename(raster, filename)
raster.set.datatype(raster, datatype, datasize)
}

\arguments{
  \item{raster}{ ~~Describe \code{raster} here~~ }
  \item{filename}{ ~~Describe \code{filename} here~~ }
  \item{datatype}{ ~~Describe \code{filename} here~~ }
  \item{datasize}{ ~~Describe \code{filename} here~~ }
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
