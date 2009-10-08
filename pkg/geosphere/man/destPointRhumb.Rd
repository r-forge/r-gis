\name{destPointRhumb}
\Rdversion{1.1}
\alias{destPointRhumb}

\title{
Destination given bearing and distance, when following a rhumb line
}

\description{
Given a start point, initial bearing, and distance, this will calculate the destination point and final bearing travelling along a 'rhumb line'.
}

\usage{
destPointRhumb(p, brng, dist, R = 6378137)
}

\arguments{
  \item{p}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{brng}{bearing (in degrees)}
  \item{dist}{distance (in the same unit as R)}
  \item{R}{radius of the earth}
}

\details{
}

\value{
}

\references{
\url{http://www.movable-type.co.uk/scripts/latlong-vincenty.html}
}

\author{
Chris Veness
}

\note{
}


\seealso{
}

\examples{
}

\keyword{ spatial  }

