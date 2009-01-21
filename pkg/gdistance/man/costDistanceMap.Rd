\name{costDistanceMap}
\alias{costDistanceMap}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Cost-distance map }
\description{
Calculates the shortest cost-distance from one or more origins to each cell of a raster. }
\usage{
costDistanceMap(transition, fromCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ object of class Transition }
  \item{fromCoords}{ origin point locations }
}
\details{
If more than more coordinate is supplied in fromCoords, the function calculates the minimum cost distance from any origin point.

The function uses Dijkstra's algorithm, as implemented in the igraph package.

In the case of grid data for a large area in a geographic (latlon) projection, a projection correction is needed for accuracy (see function \code{\link{projectionCorrection}}). 
}
\value{
RasterLayer
}
\references{
E.W. Dijkstra. 1959. A note on two problems in connexion with graphs. \emph{Numerische Mathematik} 1, 269–271.
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com}}
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ \code{\link{projectionCorrection}}, \code{\link{costDistance}} }
\examples{


}
\keyword{ spatial }
