\name{plot}

\docType{methods}

\alias{plot}
\alias{plot,GeoRaster,missing-method}

\title{Plot a GeoRaster object}

\description{
Plot (that is, make a map of) the values of a GeoRaster object
}

\usage{
\S4method{plot}{GeoRaster,missing}(x, y, maxpixels=500000, ...)
}

\arguments{
  \item{x}{Raster* object}
  \item{y}{missing}
  \item{maxpixels}{integer > 0. Maximum number of cells to use for the plot}
  \item{...}{dot dot dot}  
}


\examples{ 
f <- system.file("external/test.grd", package="geo") 
r <- georst(f)
plot(r)
}

\keyword{methods}
\keyword{spatial}

