\name{distVincentySphere}
\Rdversion{1.1}

\alias{distVincentySphere}

\title{
'Vincenty' (sphere) great circle distance
}

\description{
This function calculates great-circle distances between the two points (that is the shortest distance over the earth's surface, 'as the crow flies'), according to the 'Vincenty' method for a sphere (less accurate then the \code{distVicentyEllipsoid} method). 
}

\usage{
distVincentySphere(p1, p2, r=6378137)
}

\arguments{
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should have same length as p1, or a single point (or vice versa when p1 is a single point}
  \item{r}{radius of the earth}
}


\value{
Distance value in the same unit as \code{r} (default is meters)
}


\references{
\url{http://en.wikipedia.org/wiki/Great_circle_distance}
}

\author{
Robert Hijmans
}


\seealso{
\code{\link[geosphere]{distVincentySphere}, \link[geosphere]{distHaversine}, \link[geosphere]{distCosine}}
}

\examples{
distVincentySphere(c(0,0),c(90,90))
}

\keyword{ spatial }

