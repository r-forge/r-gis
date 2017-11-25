\name{extent}

\alias{extent}
\alias{extent,GeoExtent-method}
\alias{extent,GeoRaster-method}

\alias{xmin}
\alias{xmax}
\alias{ymin}
\alias{ymax}
\alias{xmin<-}
\alias{xmax<-}
\alias{ymin<-}
\alias{ymax<-}

\alias{xmin,GeoRaster-method}
\alias{xmax,GeoRaster-method}
\alias{ymin,GeoRaster-method}
\alias{ymax,GeoRaster-method}
\alias{xmin,GeoExtent-method}
\alias{xmax,GeoExtent-method}
\alias{ymin,GeoExtent-method}
\alias{ymax,GeoExtent-method}

  
\title{extent}

\description{
Get a GeoExtent object of a GeoRaster object, or coordinates from such an object. Or create a GeoExtent object from a vector (length=4; order= xmin, xmax, ymin, ymax)
}

\usage{
extent(x, ...)

xmin(x)
xmax(x)
ymin(x)
ymax(x)

xmin(x) <- value
xmax(x) <- value
ymin(x) <- value
ymax(x) <- value
}

\arguments{
  \item{x}{GeoRaster or a GeoExtent object or a vector of four numbers}
  \item{value}{number. x or y coordinate}  
  \item{...}{Additional arguments. None implemented }
}
 
\value{
GeoExtent object or numeric coordinate
}
  
\author{Robert J. Hijmans}


\examples{
r <- GeoRaster()
extent(r)
extent(c(0, 20, 0, 20))

r <- GeoRaster(xmn=-0.5, xmx = 9.5, ncols=10)
xmin(r)
xmax(r)
ymin(r)
ymax(r)
xmin(r) <- -180
xmax(r) <- 180


}

\keyword{spatial}

