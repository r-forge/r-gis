\name{pointsToMatrix}
\Rdversion{1.1}

\alias{pointsToMatrix}

\title{
Coerce data to points
}

\description{
Simple helper function to coerce into a two column matrix of longitude / latitude. 
}

\usage{
pointsToMatrix(p)
}

\arguments{
  \item{p}{a vector of two numbers, a matrix of 2 columns (first one is longitude, second is latitude) or a spatialPoints* object}
}


\value{
 a matrix with two columns representing longitude and latitude.
}


\author{
Robert Hijmans and Jacob van Etten
}


\keyword{ spatial  }

