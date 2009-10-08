\name{dist}
\Rdversion{1.1}

\alias{distCosine}

\title{
Great circle distance, 'law of cosines' method
}

\description{
This function calculates great-circle distances between the two points -- that is, the shortest distance over the earth's surface according to the 'law of the cosines'.
This method assumes a spherical earth, ignoring ellipsoidal effects -- which is accurate enough for most purposes, giving an 'as-the-crow-flies' distance between the two points (ignoring any hills!).
}

\usage{
distCosine(p1, p2, R=6378137)
}

\arguments{
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should be of same length of p1, or a single point (or vice versa when p1 is a single point}
  \item{R}{radius of the earth}
}


\details{
}

\value{
distance value in meters
}


\references{
\url{http://www.movable-type.co.uk/scripts/latlong.html}
}

\author{
Chris Veness
}


\seealso{
\code{link[geosphere]{distHaversine}, link[geosphere]{distVincenty}}
}

\examples{
distCosine(c(0,0),c(90,90))
}

\keyword{ spatial }
