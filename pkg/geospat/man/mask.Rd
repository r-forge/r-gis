\name{mask}

\docType{methods}

\alias{mask}
\alias{mask,GeoRaster,GeoRaster-method}

\title{Mask values in a GeoRaster object}

\description{
Create a new GeoRaster* object that has the same values as \code{x}, except for the cells that are \code{NA} in another GeoRaster (the 'mask'). These cells become \code{NA}.
} 

\usage{
\S4method{mask}{GeoRaster,GeoRaster}(x, mask, filename="", ...)
}

\arguments{
\item{x}{GeoRaster object}
\item{mask}{GeoRaster object}
\item{filename}{character. Optional output filename}
\item{...}{additional arguments as in \code{\link{writeRaster}}}
}

\value{GeoRaster object}

\seealso{\link{crop}}


\examples{
r <- georst(ncol=10, nrow=10)
m <- georst(ncol=10, nrow=10)
values(r) <- 1:100
x <- runif(ncell(r))
x[x < 0.5] <- NA
values(m) <- x
mr <- mask(r, m)
}

\keyword{methods}
\keyword{spatial}

