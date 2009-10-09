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
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{longitude/latitude of point(s) 2; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
}


\value{
A bearing in degrees
}


\author{
Chris Veness
}


\seealso{
\code{ \link[geosphere]{brngRhumb}  }
}

\examples{
bearing(c(0,0),c(90,90))
}

\keyword{ spatial }

