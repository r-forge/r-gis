\name{intersect}

\docType{methods}

\alias{intersect,SpatialPolygons,SpatialPolygons-method}

\title{ 
Intersect SpatialPolygons
}

\description{
Intersect two SpatialPolygons* objects. Only the overlapping areas (if any) are returnred. For SpatialPolygonDataFrame objects, the data.frames are also merged. 
}

\usage{
\S4method{intersect}{SpatialPolygons,SpatialPolygons}(x, y)
}

\arguments{
  \item{x}{SpatialPolygons*}
  \item{y}{SpatialPolygons*}
} 



\value{
SpatialPolygons*
}

\author{Robert J. Hijmans}


\seealso{
\code{\link{union}}. Use \code{\link{crop}} if you want to intersect a Spatial* object with an Extent object.
}


\keyword{methods}
\keyword{spatial}

