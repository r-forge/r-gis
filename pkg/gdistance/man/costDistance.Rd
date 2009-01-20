\name{costDistance}
\alias{costDistance}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Cost distance }
\description{
Calculates the least-cost distance between points. }
\usage{
costDistance(transition, fromCoords, toCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ transition matrix (class Transition) }
  \item{fromCoords}{ first set of point locations (of SpatialPoints class)}  
  \item{toCoords}{ second, optional set of point locations (of SpatialPoints class)}
}
\details{
Cost units between cells are defined as the reciprocal of the values in the transition matrix (in transition argument).

The function uses Dijkstra's algorithm, as implemented in the igraph package.

In the case of grid data for a large area in a geographic (latlon) projection, a projection correction is needed for accuracy (see function \code{\link{projectionCorrection}}). 
}
\value{
distance matrix
}
\references{ 
E.W. Dijkstra. 1959. A note on two problems in connexion with graphs. \emph{Numerische Mathematik} 1, 269–271.

}
\author{ Jacob van Etten <jacobvanetten@yahoo.com>}
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ \code{\link{projectionCorrection}}, ~~~ }
\examples{}
\keyword{ spatial }

