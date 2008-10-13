\name{raster.change}
\alias{raster.change.aggregate}
\alias{raster.change.cut}

\title{ Change raster database }
\description{
  Change the basic parameters of a raster such as its resolution or extent
}
\usage{
raster.change.aggregate(raster, fun = mean, factor = 2, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
raster.change.cut(raster, xmin, xmax, ymin, ymax, filename="", overwrite=FALSE) 
}

\arguments{
  \item{raster}{ a raster object }
  \item{filename}{ output filename for a new raster }
  \item{fun}{ the function should return one number. E.g. mean or max }
  \item{factor}{ degree of aggregation expressed as number of cells (horizontally). I.e. \code{factor = 2} will result in a grid with 2 x 2 = 4 times fewer cells }
  \item{expand}{ if \code{expand == TRUE} grids will get larger if \code{factor} if the number of the division of the columns or rows with factor does not return an integer }
  \item{rm.NA}{ if \code{rm.NA == TRUE}, remove NA cells from calculations }
  \item{INT}{ }
  \item{overwrite}{ if TRUE, "filename" will be overwritten if it exists }
  \item{xmin}{ minimum x coordinate of bounding box to cuty a piece from a raster }
  \item{xmax}{ maximum x coordinate of bounding box to cut a piece from a raster }
  \item{ymin}{ minimum y coordinate of bounding box to cut a piece from a raster }
  \item{ymax}{ maximum y coordinate of bounding box to cut a piece from a raster }
}

\details{
}
\value{
  a new raster object (in the R environment) and in some cases which is in some cases written to disk 
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }


\examples{
}
\keyword{ spatial }
