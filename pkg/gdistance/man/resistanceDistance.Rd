\name{resistanceDistance}
\alias{ resistanceDistance }
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
Calculates the resistance distance between points. }
\usage{
resistanceDistance (transition, fromCoords, toCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ transition object (transition class) }
  \item{fromCoords}{ first set of point locations (of SpatialPoints class)}  
  \item{toCoords}{ second, optional set of point locations (of SpatialPoints class)}  

}
\details{
Resistance distance is equivalent to the expected random-walk commute time between nodes in a graph (Chandra et al. 1997). The graph is represented by a transition matrix. The function issues a warning if one or more point locations are not present in the transition matrix or if locations are not connected.\n
}
\value{
distance matrix
}
\references{ Fouss, F., Pirotte, A., Renders, J.-M. & Saerens, M. 2007. Random-walk computation of similarities between nodes of a graph with application to collaborative recommendation. IEEE Transactions on Knowledge and Data Engineering, 19(3), 355-369.

Chandra, A.K., Raghavan, P., Ruzzo, W.L., Smolensy, R. & Tiwari, P. 1996. The electrical resistance of a graph captures its commute and cover times. Computational Complexity, 6(4), 312-340.

McRae, B.H. Isolation by resistance. Evolution 60(8), 1551-1561. }
\author{ Jacob van Etten }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ \code{\link{transition.solidify}}, ~~~ }
\examples{}
\keyword{ spatial }

