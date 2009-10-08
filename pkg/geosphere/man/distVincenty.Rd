\name{distVincenty}
\Rdversion{1.1}

\alias{distVincenty}

\title{
Great circle distance, Vincenty method
}

\description{
This function calculates great-circle distances between the two points -- that is, the shortest distance over the earth's surface -- according to the 'Vincenty' method. 
This method uses an ellipsoid and the results are accurate to witin 1 mm. The method is computationally more intensive than the other methods in this package. 
}

\usage{
distVincenty(p1, p2, a=6378137, b=6356752.3142, f=1/298.257223563)
}

\arguments{
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should be of same length of p1, or a single point (or vice versa when p1 is a single point}
  \item{a}{ellipsoid parameter}
  \item{b}{ellipsoid parameter}
  \item{f}{'flattening', ellipsoid parameter}
}

\details{
Parameters for commonly uses ellipsoids

\tabular{rllll}{
\tab \code{ellipsoid}   \tab \code{a}      \tab \code{b}      \tab \code{f}        \cr
\tab WGS-84	            \tab 6378137      \tab 6356752.3142   \tab 1/298.257223563 \cr
\tab GRS-80	            \tab 6378137      \tab 6356752.3141   \tab 1/298.257222101 \cr
\tab Airy (1830)        \tab 6377563.396  \tab 6356256.909    \tab 1/299.3249646   \cr
\tab International 1924 \tab 6378388      \tab 6356911.946    \tab 1/297           \cr
\tab Clarke (1880)      \tab 6378249.145  \tab 6356514.86955  \tab 1/293.465       \cr
\tab GRS-67             \tab 6378160      \tab 6356774.719    \tab 1/298.25        \cr
}

}

\value{
distance value in meters
}


\references{
Vincenty, T. 1975. Direct and inverse solutions of geodesics on the ellipsoid with applicaiton of nested equations. Survey Review Vol. 23, No. 176, pp88-93.
\url{http://www.movable-type.co.uk/scripts/latlong-vincenty.html}
}

\author{
Chris Veness
}


\seealso{
\code{link[geosphere]{distHaversine}, link[geosphere]{distCosine}}
}

\examples{
distVincenty(c(0,0),c(90,90))
# on Clarke 1880 ellipsoid
distVincenty(c(0,0),c(90,90), a=6378249.145, b=6356514.86955, f=1/293.465)
}

\keyword{ spatial }

