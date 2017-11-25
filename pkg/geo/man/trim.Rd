\name{trim}

\alias{trim}
\alias{trim,Raster-method}
\alias{trim,character-method}
\alias{trim,matrix-method}
\alias{trim,data.frame-method}

\title{Trim}

\description{
Trim (shrink) a GeoRaster object by removing outer rows and columns that all have the same value (e.g. NA).

Or remove the whitespace before or after a string of characters (or a matrix, or the character values in a data.frame).
}

\usage{
\S4method{trim}{GeoRaster}(x, padding=0, values=NA, filename='', ...)
\S4method{trim}{character}(x, internal=FALSE, ...)
}

\arguments{
  \item{x}{GeoRaster, string, matrix, or data.frame}
  \item{values}{numeric. Value(s) based on which a GeoRaster should be trimmed}
  \item{padding}{integer. Number of outer rows/columns to keep}
  \item{filename}{character. Optional output filename}
  \item{internal}{logical. If \code{TRUE}, sequential internal spaces are replaced by a single space}
  \item{...}{If \code{x} is a GeoRaster object: additional arguments as for \code{\link{writeRaster}}}
}


\value{
Same as \code{x}.
}

\author{Robert J. Hijmans and Jacob van Etten}

\examples{
r <- raster(ncol=18,nrow=18)
r[39:49] <- 1
r[113:155] <- 2
r[200] <- 6
s <- trim(r) 


trim("    hi folks    !   ")
}

\keyword{spatial}

