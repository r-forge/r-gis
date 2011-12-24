\name{gvector-package}

\alias{gvector}

\docType{package}

\title{ 
Geographic Vector (points, lines, polygons) data manipulation
}

\description{

The gvector package has functions to manipulate geographic vector data. It builds on the functionality provided by the \code{rgeos} package. \code{rgeos} has functions to manipulate geometries ("spatial features"). \code{gvector} makes it easier to do for complex polygons with attribute data. Attribute data are kept, or combined.


Comparison of terminology for polygon manipulation methods used in ArcGIS and in this package (gvector)

\tabular{rll}{
  \tab \bold{ArcGIS}    \tab  \bold{raster} \cr
  \tab Erase     \tab  erase or "-" \cr
  \tab Identity  \tab  ident \cr
  \tab Intersect \tab  intersect \cr
  \tab Union     \tab  union or "+" \cr
  \tab Update    \tab  update \cr
  \tab Symmetrical Difference \tab  symdif \cr 
  \tab Append    \tab  combine \cr
  \tab Dissolve  \tab  aggregate  \cr
  \tab Explode   \tab  disaggregate  \cr
  \tab Join table \tab  merge  \cr
  \tab Clip      \tab  crop or "*" \cr
  \tab Select    \tab  select \cr
  \tab "i"       \tab  click \cr
}

For spatial-join and other spatial queries, see sp \link[sp]{over}
}


\keyword{package}
\keyword{spatial}
