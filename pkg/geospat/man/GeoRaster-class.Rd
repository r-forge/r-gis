\name{GeoRaster-class}

\docType{class}

\alias{GeoRaster}
\alias{GeoRaster-class}
\alias{Rcpp_GeoRaster-class}

\alias{show,GeoRaster-method}


\title{ GeoRaster class}

\description{
A raster is a database organized as a rectangular grid that is sub-divided into rectangular cells of equal area (in terms of the units of the coordinate reference system) and layers. 

An object of the \code{GeoRaster} class can point to one or more files on disk that holds the values of the raster cells, or hold these values in memory. Or it can not have any associated values at all.

Objects can be created with the \code{\link[geo]{georst}} function.
 
The 'geo' package defines the GeoRaster "S4 class" to manipulate such data. The R object only contains a pointer to the C++ class "Rcpp_GeoRaster". 
}


\section{Objects from the Class}{
Objects can be created with the \code{georst} function.
}

\section{Slots}{
Slots for GeoRaster objects
	\describe{
    \item{\code{ptr}:}{pointer to the C++ class} 
}
}


\examples{
georst()
}

\keyword{classes}
\keyword{spatial}
