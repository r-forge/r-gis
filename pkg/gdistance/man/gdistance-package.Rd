\name{gdistance-package}
\alias{gdistance-package}
\alias{gdistance}
\docType{package}
\title{
gdistance: geographic distance calculations

}
\description{
The gdistance package calculates advanced geographic distances, based on graph theory and random-walk theory. This includes cost distance, resistance distance, and joint-trajectory distance (a new distance measure).
}
\details{
\tabular{ll}{
Package: \tab gdistance\cr
Type: \tab Package\cr
Version: \tab 1.0\cr
Date: \tab 2008-09-26\cr
License: \tab What license is it under?\cr
LazyLoad: \tab yes\cr
}
Distances between spatial points are obtained in two steps. 
The first step is to construct an object of the class Transition from grid data. This object holds basic geographic information about the grid and a matrix with transition values for movements between grid cells. 
The second step is to calculate mutual distances between spatial points from the Transition object and coordinate data. 
}
\author{
Jacob van Etten

Maintainer: Jacob van Etten <jacobvanetten@yahoo.com>

}
\references{
Ray, N. 2005. PATHMATRIX: a geographical information system tool to compute effective distances among samples. Molecular Ecology Notes 5, 177–180.
http://cmpg.unibe.ch/software/pathmatrix/

McRae, B.H. Isolation by resistance. Evolution 60(8), 1551-1561.
http://www.circuitscape.org

}
~~ Optionally other standard keywords, one per line, from file KEYWORDS in ~~
~~ the R documentation directory ~~
\keyword{ package }
\seealso{
~~ Optional links to other man pages, e.g. ~~
~~ \code{\link[<pkg>:<pkg>-package]{<pkg>}} ~~
}
\examples{
}
