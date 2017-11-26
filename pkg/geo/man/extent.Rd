\name{extent}

\alias{ext}
\alias{ext<-}
\alias{ext,GeoExtent-method}
\alias{ext,GeoRaster-method}
\alias{ext<-,GeoRaster,GeoExtent-method}
\alias{ext,numeric-method}
\alias{ext,missing-method}

  
\title{ext}

\description{
Get a GeoExtent object of a GeoRaster object, or coordinates from such an object. Or create a GeoExtent object from a vector (length=4; order= xmin, xmax, ymin, ymax)
}

\usage{
ext(x, ...)

ext(x) <- value

}

\arguments{
  \item{x}{GeoRaster object}
  \item{value}{GeoExtent object}  
  \item{...}{Additional arguments. None implemented }
}
 
\value{
GeoExtent object or numeric coordinate
}
  
\author{Robert J. Hijmans}


\examples{
r <- rst()
ext(r)
ext(c(0, 20, 0, 20))

}

\keyword{spatial}

