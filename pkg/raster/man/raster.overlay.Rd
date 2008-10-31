\name{r.overlay}
\alias{r.overlay}
\alias{r.cover}

\title{ Raster overlay calculation }
\description{
  Calculate values for a new raster object, based on two other rasters.  
}
\usage{
	r.overlay(raster1, raster2, fun=function(x,y){return(x+y)}, filename="") 
	r.cover(raster1, raster2, filename="") 
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{raster1}{ a raster object }
  \item{raster2}{ a raster object }
  \item{fun}{ the function to be applied, for \code{raster.calc} this should be a function that takes a single number as an argument }
  \item{filename}{ filename for the output raster. A valid filename must be provided when the data of the input rasters are on disk }
}

\details{
  The default function of r.overlay sums the two rasters. Here are some other useful functions that you can use:
  substract: fun=function(x,y){return(x-y)}
  multiply: fun=function(x,y){return(x*y)}
  divide: fun=function(x,y){return(x/y)}
  
  r.cover returns the values of the first raster, except where the first raster values are NA
}
\value{
  a new raster object (if a filename is provided, a file on disk) 
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{
}
\keyword{ spatial }
