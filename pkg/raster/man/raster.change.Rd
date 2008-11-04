\name{change}
\alias{r.aggregate}
\alias{r.disaggregate}
\alias{r.cut}
\alias{r.cut.bbox}
\alias{r.merge}
\alias{r.expand}

\title{ Change raster database }
\description{
	Use existing raster(s) to create a new raster with different spatial extent or resolution
}
\usage{
r.aggregate(raster, factor = 2, fun = mean, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
r.disaggregate(raster, factor=2, filename="", overwrite=FALSE) 
r.cut(raster, boundingbox, filename="", overwrite=FALSE) 
r.expand(raster, boundingbox, filename="", overwrite=FALSE)
r.merge(rasters, filename, overwrite=FALSE) 
}

\arguments{
  \item{raster}{ a RasterLayer object }
  \item{rasters}{ a list of RasterLayer objects }
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
 Objects that have bounding boxes include RasterLayer, and other objects descending from the Spatial class in the sp package. 
 You can check this with boundingbox(object)
 They can be created with the function new.boundingbox
}

\value{
  a new raster object (in the R environment) and in some cases which is in some cases written to disk 
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{
	rs <- raster.new()
	rs <- set.values(rs, runif(ncells(rs)))
#	raster.map(rs)
	rsa <- r.aggregate(rs, fact=10, fun=max)
#	raster.map(rsa)
	bb1 <- new.boundingbox(-180, -150, 60, 90)
	rsc1 <- r.cut(rsa, bb1)	
	bb2 <- new.boundingbox(0, 50, 0, 90)
	rsc2 <- r.cut(rsa, bb2)	
	rsc <- r.merge(c(rsc1, rsc2))
#	raster.map(rsc)
#	rs provides the bounding box for expand
	rse <- r.expand(rsc, rs)
	rsd <- r.disaggregate(rse, 3)
#   rsn <- r.neighborhood(rse)

}

\keyword{ spatial }
