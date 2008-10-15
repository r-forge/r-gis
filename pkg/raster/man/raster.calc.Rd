\name{raster.calc}
\alias{raster.calc}
\alias{raster.calc.isNA}
\alias{raster.calc.setNA}
\alias{raster.calc.reclass}
\alias{raster.calc.init}
\alias{raster.calc.neighborhood}

\title{ Raster calculate }
\description{
  Calculate values on a single raster, through a 'scalar' calculation (e.g. add or arcsin). Also used to change between values to and from "NA". 
}
\usage{
raster.calc(raster, fun, filename=NA, overwrite=FALSE, INT = FALSE)
raster.calc.reclass(raster, rclmat, filename=NA, overwrite=FALSE, INT = FALSE)
raster.calc.isNA(raster, value = 0, filename=NA, overwrite=FALSE, INT = FALSE)
raster.calc.setNA(raster, operator = "<=", value = 0, filename=NA, overwrite=FALSE, INT = FALSE)
raster.calc.init(raster, fun=runif, filename=NA, overwrite=FALSE) 
raster.calc.neighborhood(raster, fun=mean, filename=NA, ngb=3, keepdata=TRUE, overwrite=FALSE) 
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{raster}{ a raster object }
  \item{fun}{ the function to be applied, for \code{raster.calc} this should be a function that takes a single number as an argument }
  \item{value}{ the (threshold) value to replace with null or that null should become }
  \item{operator}{ the operator in setnull relative to the \code{value}, to set e.g. all values <= 2 to NA}
  \item{rclmat}{ \code{rclmat} the function to be applied }
  \item{filename}{ output filename for a new raster; if NA the result is not written to a file but returned with the raster object, in the data slot }
  \item{overwrite}{ logical to indicate whether an existing output file should be overwritten }
  \item{INT}{ logical. If \code{TRUE}, output will be integer values }
  \item{ngb} {neighborhood size in number of cells}
  \item{keepdata} {logical. If \code{TRUE}, NA will be removed for neighborhood computations. The result will only be NA if all cells are NA }
}

\details{
  Use this function to calculate values for a new raster based on an existing single raster. E.g. to add, multiply or divide a number. 
  Create and pass the appropriate function as an argument. 
  raster.calc.init sets a value without reference to existing values. E.g. initialize with a single or random number.
}
\value{
  a new raster file (on disk) and associated object (in the R environment)
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{
}
\keyword{ spatial }
