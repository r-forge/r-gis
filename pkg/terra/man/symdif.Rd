\name{symdif}

\docType{methods}

\alias{symdif}
\alias{symdif,SpatVector,SpatVector-method}

\title{ 
Symetrical difference
}

\description{
Symetrical difference of polygons
}

\usage{
\S4method{symdif}{SpatVector,SpatVector}(x, y, ...)
}

\arguments{
  \item{x}{SpatVector}
  \item{y}{SpatVector}
  \item{...}{Additional arguments. None implemented} 
}

\value{
SpatVector
}


\seealso{
\code{\link{erase}} 
}

\examples{
p <- vect(system.file("ex/lux.shp", package="terra"))
b <- as.polygons(ext(6, 6.4, 49.75, 50))
sd <- symdif(p, b)
plot(sd, col="red")
}

\keyword{methods}
\keyword{spatial}

