\name{names}

\alias{names}
\alias{names<-}
\alias{names,GeoRaster-method}
\alias{names<-,GeoRaster-method}

  
\title{Names of GeoRaster objects}

\description{
Get or set the names of the layers of a GeoRaster object.
}

\usage{
\S4method{names}{GeoRaster}(x)
\S4method{names}{GeoRaster}(x)<-value
}

\arguments{
  \item{x}{For names: GeoRaster object. For validNames: character}
  \item{value}{character (vector)}
}

\value{
Character 
}


\examples{
s <- georst(ncols=5, nrows=5, nlayer=3)
nlayer(s)
names(s)
names(s) <- c('a', 'b', 'c')
# space is not valid
names(s)[2] <- 'hello world'
names(s)

# two invalid names
names(s) <- c('a', '  a  ', '3')
s

}

\keyword{spatial}
