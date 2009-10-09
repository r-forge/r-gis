\name{brngRhumb}
\Rdversion{1.1}

\alias{brngRhumb}

\title{
Rhumbline bearing
}

\description{
Bearing along a rhumb line
}

\usage{
brngRhumb(p1, p2)
}

\arguments{
  \item{p1}{longitude/latitude of point(s); can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should have same length as p1, or a single point (or vice versa when p1 is a single point}
}


\value{
A bearing in degrees
}

\references{
\url{http://www.movable-type.co.uk/scripts/latlong.html}
}

\author{
Chris Veness
}


\seealso{
\code{ \link[geosphere]{bearing}  }
}

\examples{
brngRhumb(c(0,0),c(90,90))
}

\keyword{ spatial }

