\name{Arith-methods}

\docType{methods}

\alias{Arith-methods}

\alias{+,SpatialPolygons,SpatialPolygons-method}
\alias{+,SpatialPolygonsDataFrame,data.frame-method}
\alias{-,SpatialPolygons,SpatialPolygons-method}
\alias{*,SpatialPolygons,SpatialPolygons-method}
\alias{^,SpatialPolygons,SpatialPolygons-method}

\title{Algebra (notation) for manipulating SpatialPolygons* }

\description{
These funcitons are experimental. Under development!

Given SpatialPolygons* object \code{x} and \code{y}

\code{x+y} This is the same as \code{\link{merge}(x, y)}

\code{x*y} This is the same as \code{\link{crop}(x, y)}

\code{x-y} Erase the area covered by \code{y} from \code{x}

These functions are based on functions from rgeos, with some added functionality to, among other things, avoid polygon duplication and to keep the attributes.

See \link[raster]{Arith-methods} for similar arithmetic with Raster objects
}


\details{

Comparison of terminology for polygon manipulation methods used in ArcGIS and in this package (gvector)

\tabular{rll}{
  \tab \bold{ArcGIS}    \tab  \bold{raster} \cr
  \tab Erase     \tab  erase or "-" \cr
  \tab Identity  \tab  ident \cr
  \tab Intersect \tab  intersect \cr
  \tab Union     \tab  union or "+" \cr
  \tab Update    \tab  update \cr
  \tab Append    \tab  combine \cr
  \tab Dissolve  \tab  aggregate  \cr
  \tab Explode   \tab  disaggregate  \cr
  \tab Join table \tab  merge  \cr
  \tab Clip      \tab  crop or "*" \cr
  \tab Select    \tab  select \cr
  \tab "i"       \tab  click \cr

  \tab Spatial Join \tab  (to be done) \cr  
  \tab Symmetrical Difference \tab  "^" (to be done) \cr 
  
}

For spatial-join and other spatial queries, see sp \link[sp]{over}
}

\author{Robert J. Hijmans}

\keyword{methods}
\keyword{spatial}
