\name{geo.distance}
\alias{distance.euclidean.xy}
\alias{distance.greatcircle.xy}
\title{ Calculate geographic distance }
\description{
  Calculate geographic distance between two points on a sphere (distance.greatcircle.xy) or on a plane (distance.euclidean.xy).
}
\usage{
distance.euclidean.xy(point1, point2)
distance.greatcircle.xy(point1, point2, r = 6378137)
}
\arguments{
  \item{point1}{  x and y coordinate of first point, either as c(x, y) or as matrix(ncol=2) in degrees for greatcircle, in meters (or similar) for euclidean }
  \item{point2}{  x and y coordinate of first point. Like point1 }
  \item{r}{  radius of the world (modeled as a sphere), in meters }
}
\details{
  A sphere is an approximation for the earth (a spheroid) and distance.greatcircle.xy can thus be used with geographic 
  coordinates (latitude & longitude). There are probably better functions available, that use a datum, in other packages.
  You can use distance.euclidean.xy for coordinates of a map projection such as UTM (but note
  that in some projections distance is distorted). 
}
\value{
  Distance in meters (great circle distance) or map-units (typically meters)
}
\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}


\examples{
   distance.euclidean.xy(c(0, 0), c(1, 1))
   distance.greatcircle.xy(c(0, 0), c(1, 1))
}
\keyword{ spatial }
