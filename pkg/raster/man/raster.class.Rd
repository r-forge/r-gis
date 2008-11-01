\name{Raster-class}
\docType{class}
\alias{Raster-class}
\alias{show,Raster-method}

\title{Class "Raster" }
\description{	Class for handling Raster (grid) data  }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("Raster", ...)}.
	 }
\section{Slots}{
	 \describe{
	\item{\code{title}:}{Object of class \code{"character"}. Short name for raster } 
	\item{\code{file}:}{ Object of class \code{"RasterFile"}} 
	\item{\code{data}:}{ Object of class \code{"RasterData"}} 
	\item{\code{history}:}{Object of class \code{"character"}} 
    \item{\code{ncols}:}{Object of class \code{"integer"} number of columns }
    \item{\code{nrows}:}{Object of class \code{"integer"} number of rows }
    \item{\code{bbox}:}{Object of class \code{"maxtrix"} min and max x and y coordiantes }
    \item{\code{proj4string}:}{Object of class \code{"CRS"} }
  }
}
\section{Methods}{
  \describe{
    \item{show}{\code{signature(object = "Raster")}: ... }
    \item{hist}{\code{signature(object = "Raster")}: ... }
	
 	 }
}
\references{ ~put references to the literature/web site here ~ }
\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}

\note{  }

\examples{
showClass("Raster")
}
\keyword{classes}
\keyword{spatial}
