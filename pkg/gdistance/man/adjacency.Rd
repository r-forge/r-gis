\name{adjacency}
\alias{adjacency}

\title{ adjacency }
\description{
	calculate adjacent cells of a vector of cells
}
\usage{
adjacency(raster, fromCells, toCells, mode, outerMeridianConnect) 
}

\arguments{
  \item{raster}{ an object of the raster family }
  \item{fromCells}{ a vector of cell numbers for which adjacent cells should be calculated }
  \item{toCells}{ a second vector of cell numbers from which adjacent cells are selected (can be identical to fromCells) }
  \item{directions}{ in how many direction cells should be connected:  4 (one-cell rook moves), 8 (one-cell queen moves), or 16 (knight and one-cell queen moves) }
  \item{outerMeridianConnect}{ logical value indicating whether the outer columns of the raster should be connected as a torus}
}

\details{
The main use of calculating adjacent cells is to provide indices for transition matrices (Transition-class). 
In the case of geometric and cost distances the highest number of directions is recommended.
In the case of resistance distance and flow calculations 4 directions are recommended.
}

\value{
  a two column matrix with each row containing a pair of adjacent cells. 
}
\author{ Jacob van Etten \email{jacobvanetten@yahoo.com} }

\examples{
	rs <- newRaster()
	adjacency(raster = rs, fromCells = c(1:5), toCells = c(1:ncells(rs)), directions=16, outerMeridianConnect = TRUE) 
}

\keyword{ spatial }