\name{costDistance}
\alias{costDistance}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
Calculates the shortest cost-distance between points. }
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
Distance is calculated in cost units specified in the distance matrix. \n
}
\value{
distance matrix
}
\references{ }
\author{ Jacob van Etten }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ \code{\link{transition.solidify}}, ~~~ }
\examples{}
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
