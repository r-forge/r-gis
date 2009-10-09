\name{polePoint}
\Rdversion{1.1}

\alias{polePoint}


\title{
Destination given bearing and distance, when following a great circle
}
\description{
Clairaut's formula. Given a latitude and its bearing, what is the polarmost point that will be reached following a great circle?
}

\usage{
polePoint(lat, brng)
}

\arguments{
  \item{lat}{latitude of point(s)}
  \item{brng}{bearing}
}


\value{
A pair of coordinates (longitude/latitude)
}

\references{
\url{http://williams.best.vwh.net/ftp/avsig/avform.txt}

\url{http://www.movable-type.co.uk/scripts/latlong-vincenty.html}
}

\author{
Chris Veness
}


\examples{
polePoint(c(5,52),30)
}

\keyword{ spatial  }

