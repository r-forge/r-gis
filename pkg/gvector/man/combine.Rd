\name{combine}

\docType{methods}

\alias{combine}
\alias{combine,SpatialPolygons,SpatialPolygons-method}

\title{ 
combine parts of a Spatial* object
}

\description{
Combine (append) Spatial* objects into a single object. All objects must be of the same base class (SpatialPoints, SpatialLines, SpatialPolygons)
}

\usage{
\S4method{combine}{SpatialPolygons,SpatialPolygons}(x, y, ..., keepnames=FALSE)
}

\arguments{
 \item{x}{Spatial* object}
 \item{y}{Spatial* object}
 \item{...}{Additional Spatial* objects}
 \item{keepnames}{Logical. If \code{TRUE} the row.names are kept (if unique)} 
}

\value{
Spatial* obbject
}

\author{Robert J. Hijmans}


\keyword{methods}
\keyword{spatial}
