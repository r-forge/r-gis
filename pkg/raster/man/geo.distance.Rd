\name{geo.distance}
\alias{distance.euclidean.xy}
\alias{distance.greatcircle.xy}
\title{ Calculate geographic distance }
\description{
  Calculate geographic distance between two points on a sphere (distance.greatcircle.xy) or on a plane (distance.euclidean.xy).
}
\usage{
distance.euclidean.xy(x1, y1, x2, y2)
distance.greatcircle.xy(x1, y1, x2, y2, r = 6378137)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{x1}{  x coordinate of first point, in degrees for greatcircle, in meters (or similar) for euclidean }
  \item{y1}{  y coordinate of first point, in degrees for greatcircle, in meters (or similar) for euclidean  }
  \item{x2}{  x coordinate of second point, in degrees for greatcircle, in meters (or similar) for euclidean  }
  \item{y2}{  y coordinate of second point, in degrees for greatcircle, in meters (or similar) for euclidean  }
  \item{r}{  radius of the world (modeled as a sphere), in meters }
}
\details{
  A sphere is an approximation for the earth (a spheroid) and distance.greatcircle.xy can thus be used with geographic 
  coordinates (latitude & longitude). You can use distance.euclidean.xy for coordinates of a map projection such as UTM (but note
  that in some projections distance is distorted).
}
\value{
  Distance in meters (great circle distance) or map-units (typically meters)
}
\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}


\examples{
   distance.euclidean.xy(0, 0, 1, 1)
   distance.greatcircle.xy(0, 0, 1, 1)
}
\keyword{ spatial }
