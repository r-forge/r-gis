\name{fwPath}


\alias{fwPath}

\title{Set (or get) the FWtools path}

\description{
Set or get the path to the FWtools 'bin' folder
}

\usage{
fwPath(x=NULL, save=TRUE)
}

\arguments{
  \item{x}{Character. Path to the FWtools bin folder. If the folder is in your "path", you can set this value to ""}
  \item{save}{Boolean. If \code{TRUE} and \code{x} is not \code{NULL}, the FWtools path is saved to file (if you have write access to the R program folder) }
}


\value{
character vector 
}

\seealso{
\url{http://www.gdal.org/gdalinfo.html} 
}


\author{Robert J. Hijmans}


\keyword{spatial}

