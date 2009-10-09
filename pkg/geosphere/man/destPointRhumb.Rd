\name{destPointRhumb}
\Rdversion{1.1}
\alias{destPointRhumb}

\title{
Destination given bearing and distance, when following a rhumb line
}

\description{
Given a start point, initial bearing, and distance, this will calculate the destination point when travelling along a 'rhumb line'.
}

\usage{
destPointRhumb(p, brng, dist, R = 6378137)
}

\arguments{
  \item{p}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{brng}{bearing in degrees}
  \item{dist}{distance; in the same unit as R (default is meters)}
  \item{R}{radius of the earth}
}


\value{
Coordinates (longitude/latitude) of a point
}

\references{
\url{http://www.movable-type.co.uk/scripts/latlong-vincenty.html}
}

\author{
Chris Veness
}

\note{
The bearing changes when traveling along a rhumb line. The final bearing is not the same as the initial bearing. You can comute the final bearing with \code{bearing(destpoint,p)} (see examples)
}


\examples{
# intial bearing is 30 degrees moving 100 km away from (0,0) 
d <- destPointRhumb(c(0,0), 30, 100000, R = 6378137)
#final bearing, from endpoint back to beginning: 
brngRhumb(d, c(0,0))
}

\keyword{ spatial  }

