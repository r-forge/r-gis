\name{range}

\alias{range}
\alias{setRange}
\alias{range,GeoRaster-method}
\alias{setRange,GeoRaster-method}

\title{get or compute min and max values}

\description{
The minimum and maximum value of a GeoRaster are computed (from a file on disk if necessary) and stored in the object. 
}

\usage{
\S4method{setRange}{GeoRaster}(x)
\S4method{range}{GeoRaster}(x, ..., na.rm=TRUE)
}

\arguments{
  \item{x}{ GeoRaster object }
  \item{...}{ additional arguments. None implemented }
  \item{na.rm}{ ignored }
}

\value{
getRange: nothing. Used for the side-effect of setting the range on a GeoRaster object

range: numeric matrix of min and max values
}


\examples{ 
r <- georst(system.file("external/test.grd", package="geospat"))
range(r)
}

\keyword{ spatial }
\keyword{ methods }

