\name{plot}

\docType{methods}

\alias{plot}
\alias{plot,GeoRaster,ANY-method}

\title{Plot a GeoRaster object}

\description{
Plot (that is, make a map of) the values of a GeoRaster object
}

\usage{
\S4method{plot}{Raster,ANY}(x, y, maxpixels=500000, ...)
}


\arguments{
  \item{x}{Raster* object}
  \item{y}{missing}
  \item{maxpixels}{integer > 0. Maximum number of cells to use for the plot}
}


\examples{ 
r <- rst(nrows=10, ncols=10)
values(r) <- 1:ncell(r)
plot(r)
}

\keyword{methods}
\keyword{spatial}

