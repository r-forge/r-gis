\name{Arith-methods}

\docType{methods}

\alias{Arith-methods}

\alias{+,SpatialPolygons,SpatialPolygons-method}
\alias{-,SpatialPolygons,SpatialPolygons-method}
\alias{*,SpatialPolygons,SpatialPolygons-method}
\alias{^,SpatialPolygons,SpatialPolygons-method}

\title{Algebra (notation) for manipulating SpatialPolygons* }

\description{
Given SpatialPolygons* objects \code{x} and \code{y}

\code{x+y} This is the same as \code{\link{merge}(x, y)}

\code{x*y} This is the same as \code{\link{intersect}(x, y)}

\code{x^y} This is the same as \code{\link{crop}(x, y)}

\code{x-y} This is the same as \code{\link{erase}(x, y)}

These functions are based on functions from rgeos, with some added functionality to, among other things, avoid polygon duplication and to keep the attributes.
}



\author{Robert J. Hijmans}

\keyword{methods}
\keyword{spatial}
