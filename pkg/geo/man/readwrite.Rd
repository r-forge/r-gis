\name{read and write}

\docType{methods}

\alias{readStart}
\alias{readStop}
\alias{writeStart}
\alias{writeStop}
\alias{writeValues}

\alias{readStart,GeoRaster-method}
\alias{readStop,GeoRaster-method}
\alias{writeStart,GeoRaster,character-method}
\alias{writeStop,GeoRaster-method}
\alias{writeStop,GeoRaster-method}
\alias{writeValues,GeoRaster,vector-method}

\title{read from or write to file}

\description{
Methods to read from or write chunks of values to or from a file. These are low level methods for programmers. Use writeRaster if you want to save an entire GeoRaster to file. 

Functions for writing chunks has to start at the first cell of a row (identified with argument \code{row}) and the values written must represent 1 or more entire rows. Begin by opening a file with \code{writeStart}, then write values to it in chunks. When writing is done close the file with \code{writeStop}. 

If you want to write all values of a Raster* object at once, you can also use \code{\link{writeRaster}} which is easier to use but more limited. 
}


\usage{
\S4method{readStart}{GeoRaster}(x, ...)
\S4method{readStop}{GeoRaster}(x)
\S4method{writeStart}{GeoRaster,character}(x, filename="", overwrite=FALSE, ...)
\S4method{writeStop}{GeoRaster}(x)
\S4method{writeValues}{GeoRaster,vector}(x, v, start)
}

\arguments{
  \item{x}{GeoRaster object}
  \item{filename}{character. Output file name}
  \item{overwrite}{logical. If \code{TRUE} an existing file with the same name will be overwritten}
  \item{...}{additional arguments as for \code{\link{writeRaster}}}
  \item{v}{vector with cell values to be written}
  \item{start}{integer. Row number (counting starts at 1) from where to start writing \code{v}}

}


\value{
\code{writeStart} returns a list that can be used for processing the file in chunks.

The other methods invisibly return a logical value indicating whether they were succesful or not. Their purpose is the side-effect of opening or closing files. 
}

\keyword{ spatial }
\keyword{ methods }
