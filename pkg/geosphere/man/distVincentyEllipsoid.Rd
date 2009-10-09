\name{distVincentyEllipsoid}
\Rdversion{1.1}

\alias{distVincentyEllipsoid}

\title{
Great circle distance, 'Vincenty' method using an ellipsoid
}

\description{
This function calculates great-circle distances between the two points -- that is, the shortest distance over the earth's surface -- according to the 'Vincenty' method. 
This method uses an ellipsoid and the results are accurate to witin 1 mm. The method is computationally more intensive than the other methods in this package. 
}

\usage{
distVincentyEllipsoid(p1, p2, a=6378137, b=6356752.3142, f=1/298.257223563)
}

\arguments{
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should have same length as p1, or a single point (or vice versa when p1 is a single point}
  \item{a}{Equatorial axis of ellipsoid}
  \item{b}{Polar axis of ellipsoid}
  \item{f}{Inverse flattening of ellipsoid}
}

\details{

WGS84 is the best available global ellipsoid, but for some areas other ellipsoids could be preferable. Here are parameters for some commonly used ellipsoids:

\tabular{rllll}{
\tab \code{ellipsoid}   \tab \code{a}      \tab \code{b}      \tab \code{f}        \cr
\tab WGS84	            \tab 6378137      \tab 6356752.3142   \tab 1/298.257223563 \cr
\tab GRS80	            \tab 6378137      \tab 6356752.3141   \tab 1/298.257222101 \cr
\tab Airy 1830        \tab 6377563.396  \tab 6356256.909    \tab 1/299.3249646   \cr
\tab International 1924 \tab 6378388      \tab 6356911.946    \tab 1/297           \cr
\tab Clarke 1880      \tab 6378249.145  \tab 6356514.86955  \tab 1/293.465       \cr
\tab Clarke 1866      \tab 6378206.4    \tab 6356583.8      \tab 1/294.9786982   \cr
\tab Bessel 1841        \tab 6377397.155  \tab 6356078.965    \tab 1/299.1528434   \cr
\tab Krasovsky 1940     \tab 6378245      \tab 6356863        \tab 1/298.2997381   \cr
\tab GRS-67             \tab 6378160      \tab 6356774.719    \tab 1/298.25        \cr
}

more info: \url{http://en.wikipedia.org/wiki/Reference_ellipsoid}
				
}

\value{
Distance value in the same units as the ellipsoid (default is meters)
}


\references{
Vincenty, T. 1975. Direct and inverse solutions of geodesics on the ellipsoid with applicaiton of nested equations. Survey Review Vol. 23, No. 176, pp88-93.

\url{http://www.movable-type.co.uk/scripts/latlong-vincenty.html}
}

\author{
Chris Veness and Robert Hijmans
}


\seealso{
\code{\link[geosphere]{distVincentySphere}, \link[geosphere]{distHaversine}, \link[geosphere]{distCosine}}
}

\examples{
distVincentyEllipsoid(c(0,0),c(90,90))
# on a Clarke 1880 ellipsoid
distVincentyEllipsoid(c(0,0),c(90,90), a=6378249.145, b=6356514.86955, f=1/293.465)
}

\keyword{ spatial }

