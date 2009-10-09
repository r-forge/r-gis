\name{bearing}
\Rdversion{1.1}

\alias{bearing}

\title{
Bearing
}

\description{
Get the bearing to go from point1 to point2
}

\usage{
bearing(p1, p2)
}

\arguments{
  \item{p1}{longitude/latitude of point(s); can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should have same length as p1, or a single point (or vice versa when p1 is a single point}
}


\value{
A bearing in degrees
}


\author{
Chris Veness; ported to R by Robert Hijmans;
}


\seealso{
\code{ \link[geosphere]{brngRhumb}  }
}

\examples{
bearing(c(0,0),c(90,90))
}

\keyword{ spatial }

