\name{union}

\docType{methods}

\alias{union,SpatialPolygons,SpatialPolygons-method}

\title{ 
Union Spatial* objects
}

\description{
Union Spatial* objects. Overlapping polygons are intersected, other spatial objects are appended. Tabular attributes are joined.
}

\usage{
\S4method{union}{SpatialPolygons,SpatialPolygons}(x, y)
}

\arguments{
  \item{x}{Spatial* object}
  \item{y}{Spatial* object}
}

\value{
Spatial*
}

\author{Robert J. Hijmans}

\seealso{
\code{\link{merge}} for merging a data.frame with attributes of Spatial objects

and \code{\link{+,SpatialPolygons,SpatialPolygons-method}} for an algebraic notation
}


\keyword{methods}
\keyword{spatial}

