\name{values}

\docType{methods}


\alias{values}
\alias{values,GeoRaster-method}
\alias{values<-}
\alias{values<-,GeoRaster,numeric-method}
  
\title{Get cell values}

\description{
values returns all cell values of a GeoRaster object.
}

\usage{
\S4method{values}{GeoRaster}(x,...)
\S4method{values}{GeoRaster,numeric}(x,...)<-value
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
r <- georst(system.file("external/test.grd", package="geo"))
r
v <- values(r)
values(r) <- v * 10
r
}

\keyword{spatial}
\keyword{methods}
