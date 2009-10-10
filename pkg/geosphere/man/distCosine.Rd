\name{dist}
\Rdversion{1.1}

\alias{distCosine}

\title{
'Law of cosines' great circle distance
}

\description{
This function calculates great-circle distances between the two points (that is the shortest distance over the earth's surface, 'as the crow flies'), according to the 'law of the cosines'.
This method assumes a spherical earth, ignoring ellipsoidal effects -- which is accurate enough for most purposes, giving an 'as-the-crow-flies' distance between the two points (ignoring any hills!).
}

\usage{
distCosine(p1, p2, r=6378137)
}

\arguments{
  \item{p1}{longitude/latitude of point(s); can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should have same length as p1, or a single point (or vice versa when p1 is a single point}
  \item{r}{radius of the earth}
}


\value{
Distance value in the same unit as \code{r} (default is meters)
}

\references{
\url{http://www.movable-type.co.uk/scripts/latlong.html}

\url{http://en.wikipedia.org/wiki/Great_circle_distance}
}

\author{
Chris Veness; ported to R by Robert Hijmans
}


\seealso{
\code{\link[geosphere]{distHaversine}, \link[geosphere]{distVincentySphere}, \link[geosphere]{distVincentyEllipsoid}}
}

\examples{
distCosine(c(0,0),c(90,90))
}

\keyword{ spatial }
