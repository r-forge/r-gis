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
    \item{\code{filename}:}{Object of class \code{"character"} filename (including path) }
    \item{\code{rastername}:}{Object of class \code{"character"} short filename, used as variable name }
    \item{\code{filetype}:}{Object of class \code{"character"} type of grid data file format }
    \item{\code{valid}:}{Object of class \code{"logical"} indicates whether the object is valid or not }
    \item{\code{projection}:}{Object of class \code{"character"} map projection, as PROJ4 definition }
    \item{\code{nbands}:}{Object of class \code{"integer"} number of 'bands' (layers) in database }
    \item{\code{ncols}:}{Object of class \code{"integer"} number of columns }
    \item{\code{nrows}:}{Object of class \code{"integer"} number of rows }
    \item{\code{xres}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{yres}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{xmin}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{xmax}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{ymin}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{ymax}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{minvalue}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{maxvalue}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{nodatavalue}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{data}:}{Object of class \code{"array"} Slot to hold the data values (after raster.read. ) }
    \item{\code{rowdata}:}{Object of class \code{"array"} Slot to hold the data values for a single row (after raster.read.row ) }	

	
  }
}
\section{Methods}{
  \describe{
    \item{show}{\code{signature(object = "Raster")}: ... }
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
