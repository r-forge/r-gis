\name{names}

\alias{names}
\alias{names<-}
\alias{names,GeoRaster-method}
\alias{names<-,GeoRaster-method}
\alias{validNames}

  
\title{Names of GeoRaster objects}

\description{
Get or set the names of the layers of a GeoRaster object.

\code{validNames} create a set of valid names (trimmed, no duplicates, not starting with a number). 
}

\usage{
\S4method{names}{GeoRaster}(x)

\S4method{names}{GeoRaster}(x)<-value

validNames(x, prefix='lyr')
}

\arguments{
  \item{x}{For names: GeoRaster object. For validNames: character}
  \item{value}{character (vector)}
  \item{prefix}{character string used if x is an empty character string}   
}

\value{
Character 
}


\examples{
s <- rst(ncols=5, nrows=5, nlayer=3)
nlayer(s)
names(s)
names(s) <- c('a', 'b', 'c')
names(s)[2] <- 'hello world'
names(s)
s
validNames(c('a', 'a', '', '1', NA, '  b  ', '  a'))
}

\keyword{spatial}
