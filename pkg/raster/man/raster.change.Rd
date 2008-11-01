\name{change}
\alias{change.aggregate}
\alias{change.disaggregate}
\alias{change.cut}
\alias{change.cut.bbox}
\alias{change.merge}
\alias{change.expand}

\title{ Change raster database }
\description{
	Use existing raster(s) to create a new raster with different spatial extent or resolution
}
\usage{
change.aggregate(raster, factor = 2, fun = mean, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
change.disaggregate(raster, factor=2, filename="", overwrite=FALSE) 
change.cut(raster, boundingbox, filename="", overwrite=FALSE) 
change.expand(raster, boundingbox, filename="", overwrite=FALSE)
change.merge(rasters, filename, overwrite=FALSE) 
}

\arguments{
  \item{raster}{ a Raster object }
  \item{rasters}{ a list of Raster objects }
  \item{boundingbox} {bounding box used to cut a raster. Any object that is or has a bounding box (see below) }
  \item{filename}{ output filename for a new raster }
  \item{fun}{ function used to aggregate values. It should return one number. E.g. mean or max }
  \item{factor}{ degree of aggregation or disaggregation expressed as number of cells (horizontally). I.e. \code{factor = 2} will result in a grid with 2 x 2 = 4 times fewer cells }
  \item{expand}{ if \code{expand == TRUE} grids will get larger if \code{factor} if the number of the division of the columns or rows with factor does not return an integer }
  \item{rm.NA}{ if \code{rm.NA == TRUE}, remove NA cells from calculations }
  \item{INT}{ logical. If \code{TRUE} the values will be rounded and stored as integer }
  \item{overwrite}{ if TRUE, "filename" will be overwritten if it exists }
}

\details{
 Objects that have bounding boxes include Raster, and other objects descending from the Spatial class in the sp package. 
 You can check this with get.boundingbox(object)
 They can be created with the function new.boundingbox
}

\value{
  a new raster object (in the R environment) and in some cases which is in some cases written to disk 
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{
	rs <- raster.new()
	rs <- set.values(rs, runif(get.ncells(rs)))
#	raster.map(rs)
	rsa <- change.aggregate(rs, fact=10, fun=max)
#	raster.map(rsa)
	bb1 <- new.boundingbox(-180, -150, 60, 90)
	rsc1 <- change.cut(rsa, bb1)	
	bb2 <- new.boundingbox(0, 50, 0, 90)
	rsc2 <- change.cut(rsa, bb2)	
	rsc <- change.merge(c(rsc1, rsc2))
#	raster.map(rsc)
#	rs provides the bounding box for expand
	rse <- change.expand(rsc, rs)
	rsd <- change.disaggregate(rse, 3)
#   rsn <- calc.neighborhood(rse)

}

\keyword{ spatial }
