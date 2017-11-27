\name{values}

\alias{values}
\alias{values,GeoRaster-method}
\alias{values<-}
\alias{values<-,GeoRaster,numeric-method}
  
\title{Get cell values}

\description{
values returns all cell values of a GeoRaster object.
}

\usage{
values(x, ...)

values(x, ...) <- value
}

\arguments{
 \item{x}{GeoRaster object}
 \item{value}{numeric}
 \item{...}{additional arguments. none implemented}
}

\value{
matrix
}


\examples{
r <- rst(system.file("external/test.grd", package="geo"))
r
v <- values(r)
values(r) <- v * 10
r
}

\keyword{spatial}
\keyword{methods}
