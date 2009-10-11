\name{greatCircle}
\Rdversion{1.1}

\alias{greatCircle}

\title{
Intersecting radials
}

\description{
Get points on a great circle inbetween two points
}

\usage{
greatCircle(p1, p2, f=50, r=6378137) 
}

\arguments{
  \item{p1}{Longitude/latitude of a single point; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{As above}
  \item{f}{The requested number of points on the Great Circle}
  \item{r}{radius of the earth; default = 6378137 m}  
}


\value{
a matrix of points
}

\references{
\url{http://williams.best.vwh.net/avform.htm#Intersection}
}

\author{
Robert Hijmans
}


\examples{
greatCircle(c(5,52), c(-120,37), f=10)
}

\keyword{ spatial }
