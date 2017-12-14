\name{crop}

\docType{methods}

\alias{crop}
\alias{crop,GeoRaster-method}

\title{Crop}

\description{
crop returns a new GeoRaster that is the geographic subset of an object as specified by a GeoExtent object.
}

\usage{
\S4method{crop}{GeoRaster}(x, y, filename="", snap='near', ...)

}

\arguments{
  \item{x}{Raster* object or SpatialPolygons*, SpatialLines*, or SpatialPoints* object}
  \item{y}{Extent object, or any object from which an Extent object can be extracted (see Details)}
  \item{filename}{Character, output filename. Optional}
  \item{snap}{Character. One of 'near', 'in', or 'out'}  
  \item{...}{Additional arguments as for \code{\link{writeRaster}}}  
}



\value{
GeoRaster
}


\examples{
r <- georst(nrow=45, ncol=90)
values(r) <- 1:ncell(r)
e <- ext(-160, 10, 30, 60)
rc <- crop(r, e)
}

\keyword{spatial}
