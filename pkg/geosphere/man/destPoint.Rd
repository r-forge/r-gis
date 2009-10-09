\name{destPoint}
\Rdversion{1.1}
\alias{destPoint}

\title{
Destination given bearing and distance, when following a great circle
}

\description{
Given a start point, initial bearing, and distance, this will calculate the destination point and final bearing travelling along a (shortest distance) great circle arc.
}

\usage{
destPoint(p, brng, d, R = 6378137)
}

\arguments{
  \item{p}{longitude/latitude of point(s); can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{brng}{bearing}
  \item{d}{distance}
  \item{R}{radius of the earth}
}


\value{
A pair of coordinates (longitude/latitude)
}

\references{
\url{http://www.movable-type.co.uk/scripts/latlong-vincenty.html}
}

\author{
Chris Veness
}


\examples{
destPoint(c(5,52),30,10000)
}

\keyword{ spatial  }

