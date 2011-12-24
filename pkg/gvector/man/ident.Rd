\name{ident}

\docType{methods}


\alias{ident}
\alias{ident,SpatialPolygons,SpatialPolygons-method}

\title{ 
Identity 
}

\description{
"identity" overlay of SpatialPolygonDataFrame objects. Areas of \code{x} that overlap with code{y} are intersected with code{y} and get the values of \code{y}. To replace rather than intersect, use \code{\link{update}}
}

\usage{
\S4method{ident}{SpatialPolygons,SpatialPolygons}(x, y, ...)
}

\arguments{
  \item{x}{SpatialPolygons}
  \item{y}{SpatialPolygons}
  \item{...}{Additional SpatialPolygon object(s)}
}

\value{
SpatialPolygons
}

\seealso{
\code{\link{update}, \link{union}}
}

\keyword{methods}
\keyword{spatial}

