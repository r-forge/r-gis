\name{buffer}

\docType{methods}

\alias{buffer}
\alias{buffer,Spatial-method}
\alias{buffer,SpatialPixels-method}
\alias{buffer,SpatialGrid-method}

\title{ 
Buffer
}

\description{
Buffer around Spatial* objects. 
}

\usage{
\S4method{buffer}{Spatial}(x, width=0, ...)
}

\arguments{
  \item{x}{Spatial object}
  \item{width}{Buffer size}
  \item{...}{Additional arguments as in \code{\link[rgeos]{gBuffer}} (except for \code{byid} and \code{id} which cannot be used}  
}

\value{
SpatialPolygons*
}

\author{Robert J. Hijmans}

\seealso{
\code{\link[rgeos]{gBuffer}} 
}


\keyword{methods}
\keyword{spatial}

