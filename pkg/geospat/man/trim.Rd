\name{trim}

\alias{trim}
\alias{trim,GeoRaster-method}

\title{Trim a GeoRaster}

\description{
Trim (shrink) a GeoRaster object by removing outer rows and columns that are \code{NA}.
}

\usage{
\S4method{trim}{GeoRaster}(x, padding=0, filename='', ...)
}

\arguments{
  \item{x}{GeoRaster}
  \item{padding}{integer. Number of outer rows/columns to keep}
  \item{filename}{character. Optional output filename}
  \item{...}{additional arguments as for \code{\link{writeRaster}}}
}


\value{
GeoRaster
}


\examples{
r <- georst(ncol=18,nrow=18)
v <- rep(NA, ncell(r))
v[39:40] <- 1
v[205] <- 2
values(r) <- v
s <- trim(r) 
}

\keyword{spatial}

