\name{resistanceDistance}
\alias{ resistanceDistance }
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ Resistance distance }
\description{
Calculates the resistance distance between points. }
\usage{
resistanceDistance (transition, fromCoords, toCoords)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ transition object (Transition class) }
  \item{fromCoords}{ first set of point locations (of SpatialPoints class)}  
  \item{toCoords}{ second, optional set of point locations (of SpatialPoints class)}  

}
\details{
Resistance distance is equivalent to the expected random-walk commute time between nodes in a graph (Chandra et al. 1997).

The function implements the algorithm given by Fouss et al. (2007).

In the case of grid data for a large area in a geographic (latlon) projection, a projection correction is needed for accuracy (see function \code{\link{projectionCorrection}}). 
}
\value{
distance matrix
}
\references{ 
Chandra, A.K., Raghavan, P., Ruzzo, W.L., Smolensy, R. & Tiwari, P. 1996. The electrical resistance of a graph captures its commute and cover times. \emph{Computational Complexity}, 6(4), 312-340.

Fouss, F., Pirotte, A., Renders, J.-M. & Saerens, M. 2007. Random-walk computation of similarities between nodes of a graph with application to collaborative recommendation. \emph{IEEE Transactions on Knowledge and Data Engineering}, 19(3), 355-369.

McRae, B.H. 2006. Isolation by resistance. \emph{Evolution} 60(8), 1551-1561. 
\url{http://www.circuitscape.org}
}
\author{ Jacob van Etten <jacobvanetten@yahoo.com> }
\note{ 

}
\seealso{ \code{\link{projectionCorrection}}, ~~~ }
\examples{
raster1 <- newRaster(nrows=18, ncols=36)


}
\keyword{ spatial }

