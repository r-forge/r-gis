\name{distRhumb}
\Rdversion{1.1}

\alias{distRhumb}

\title{
Distance along a 'rhumb line'
}

\description{
A 'rhumb line' (or loxodrome) is a path of constant bearing, which crosses all meridians at the same angle.
}

\usage{
distRhumb(p1, p2, R = 6378137)
}

\arguments{
  \item{p1}{longitude/latitude of point(s) 1; can be a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
  \item{p2}{as above. Should be of same length of p1, or a single point (or vice versa when p1 is a single point}
  \item{R}{radius of the earth}
}

\details{
Sailors used to (and sometimes still) navigate along rhumb lines since it is easier to follow a constant compass bearing than to continually adjust the bearing as is needed to follow a great circle, though they are normally longer than great-circle (orthodrome) routes. Rhumb lines are straight lines on a Mercator Projection map.
If you maintain a constant bearing along a rhumb line, you will gradually spiral in towards one of the poles.
}

\value{
 ...
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
\code{link[geosphere]{distCosine}, link[geosphere]{distVincenty}, [geosphere]{distHaversine}}
}

\examples{
distRhumb(c(0,0),c(90,90))
}

\keyword{ spatial  }

