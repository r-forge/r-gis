\name{rasterstack.calc}
\alias{rasterstack.calc}
\title{ Cell based calculations for a rasterstack }
\description{
  Cell based calculations for a rasterstack (a collection of 2 or more rasters of the same extent and resolution), resulting in a single raster. 
  Any function that takes a one dimensional vector of values as in input can be passed as function.
}
\usage{
rasterstack.calc(rasterstack, fun, filename=NA, overwrite=FALSE, ForceIntOutput = FALSE)
}
\arguments{
  \item{rasterstack}{ \code{rasterstack} a stack object }
  \item{fun}{ \code{fun} function to be applied }
  \item{filename}{ \code{filename} output raster filename. If NA, no file is written and result return in the data slot of the raster object }
  \item{overwrite}{ if \code{overwrite==TRUE} the output file will be overwritten if it exists}
  \item{ForceIntOutput}{ if \code{ForceIntOutput==TRUE} the output will always be rounded to integer values}
}

\value{the function returns a raster object and (if \code{filename != NA}) a raster file on disk}

\author{Robert J. Hijmans  \email{r.hijmans@gmail.com}}

\seealso{ \code{\link{raster.calc}}, ~~~ }
\examples{

}
\keyword{ spatial }
