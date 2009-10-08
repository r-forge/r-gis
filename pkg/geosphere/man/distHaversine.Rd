\name{distHaversine}
\Rdversion{1.1}

\alias{distHaversine}

\title{
Great circle distance, 'Haversine' method
}

\description{
This function calculates great-circle distances between the two points, that is, the shortest distance over the earth's surface, according to the 'haversine' method.
The 'haversine' method assumes a spherical earth, ignoring ellipsoidal effects, which is accurate enough for most purposes, giving an 'as-the-crow-flies' distance between the two points (ignoring any hills!).
}

\usage{distHaversine(p1, p2, R=6378137)
}

\arguments{
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should be of same length of p1, or a single point (or vice versa when p1 is a single point}
  \item{R}{radius of the earth}
}


\details{
The Haversine ('half-versed-sine') formula 'remains particularly well-conditioned for numerical computation even at small distances' -- unlike calculations based on the spherical law of cosines. It was published by R.W. Sinnott in 1984, although it has been known  for much longer. When Sinnott devised the Haversine formula, computational precision was limited. Nowadays, computers can use 15 significant figures of precision. With this precision, the simple spherical law of cosines formula gives good results down to distances as small as around 1 meter. In view of this it is probably worth, in most situations, using either the simpler law of cosines or the more accurate ellipsoidal \code{link[geosphere]{distVincenty}} formula in preference to haversine! 

Since the earth is not quite a sphere, there are small errors in using spherical geometry; the earth is actually roughly ellipsoidal (or more precisely, oblate spheroidal) with a radius varying between about 6378km (equatorial) and 6357km (polar), and local radius of curvature varying from 6336km (equatorial meridian) to 6399 km (polar). This means that errors from assuming spherical geometry might be up to 0.55\% crossing the equator, though generally below 0.3\%, depending on latitude and direction of travel. An accuracy of better than 3m in 1km is often good enough, but if you want greater accuracy, you could use the \code{link[geosphere]{distVincenty}} method for calculating geodesic distances on ellipsoids, which gives results accurate to within 1mm.
}

\value{
distance value in meters
}


\references{
Sinnott, R.W, 1984. Virtues of the Haversine. Sky and Telescope 68(2): 159
\url{http://www.movable-type.co.uk/scripts/latlong.html}
}

\author{
Chris Veness
}


\seealso{
\code{link[geosphere]{distCosine}, link[geosphere]{distVincenty}}
}

\examples{
distHaversine(c(0,0),c(90,90))
}

\keyword{ spatial }


