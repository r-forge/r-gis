\name{sources}

\docType{methods}

\alias{sources}
\alias{sources,SpatRaster-method}
\alias{hasValues}
\alias{hasValues,SpatRaster-method}


\title{Data sources of a SpatRaster}

\description{
Get the data sources of a SpatRaster and the number of layers by source. Sources are either files (or similar resources) or "", meaning that they are in memory. You can use \code{hasValues} to check if in-memory layers actualy have values. 
}

\usage{
\S4method{sources}{SpatRaster}(x, ...)

\S4method{hasValues}{SpatRaster}(x, ...)
}

\arguments{
\item{x}{SpatRaster}
\item{...}{additional arguments. None implemented }  
}

\value{sources returns a data.frame with the source names (if any) and the number of layers by source}


\examples{
f <- system.file("ex/test.tif", package="terra")
r <- rast(f)
s <- rast(r)
values(s) <- 1:ncell(s)
rs <- c(r,r,s,r)
sources(rs)
hasValues(r)
x <- rast()
hasValues(x)

}


\keyword{methods}
\keyword{spatial}

