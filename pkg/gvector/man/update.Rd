\name{update}

\docType{methods}

\alias{update,SpatialPolygons,SpatialPolygons-method}

\title{ 
Union Spatial* objects
}

\description{
Update Spatial* objects. Areas of \code{x} that overlap with \code{y} are replaced by \code{y}. To intersect rather than replace, use \code{\link{ident}}
}

\usage{
\S4method{update}{SpatialPolygons,SpatialPolygons}(object, ...)
}

\arguments{
  \item{object}{SpatialPolygons* object}
  \item{...}{Additional SpatialPolygons* object(s)}
}

\value{
SpatialPolygons*
}

\author{Robert J. Hijmans}

\seealso{
\code{\link{ident}, \link{union}, \link{intersect}}
}


\keyword{methods}
\keyword{spatial}

