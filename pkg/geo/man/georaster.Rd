\name{rst}

\docType{methods}

\alias{rst}
\alias{rst,missing-method}
\alias{rst,character-method}
\alias{rst,GeoRaster-method}

\title{Create a GeoRaster object}

\description{
Methods to create a GeoRaster object. RasterLayer objects can be created from scratch or a file.

A GeoRaster represents a geospatially references surface divided into rows, columns, and layers.

When a GeoRaster is created from a file, it does (initially) not contain any cell (pixel) values in (RAM) memory, it only has the parameters that describe the RasterLayer. You can access cell-values with \code{\link[raster]{values}, \link[raster]{extract}} and related functions. You can assign new values with  \code{\link[raster]{values}}.

}


\usage{

\S4method{rst}{missing}(nrow=180, ncol=360, nlayer=1, xmin=-180, xmax=180, ymin=-90, ymax=90, crs, extent, resolution, ...)

\S4method{rst}{character}(x, ...)

\S4method{rst}{GeoRaster}(x, ...) 

}

\arguments{
\item{x}{filename (character), Extent, GeoRaster object. Or character (filename)}
\item{...}{Additional arguments, see Details }  
\item{nrow}{positive integer. Number of rows}
\item{ncol}{postive integer. Number of columns}
\item{nlayer}{postive integer. Number of layers}
\item{xmin}{minimum x coordinate (left border)}
\item{xmax}{maximum x coordinate (right border)}
\item{ymin}{minimum y coordinate (bottom border)}
\item{ymax}{maximum y coordinate (top border)}
\item{extent}{object of class Extent. If present, the arguments xmn, xmx, ymn and ynx are ignored}
\item{crs}{character. PROJ.4 type description of a Coordinate Reference System (map projection). If this argument is missing, and the x coordinates are within -360 .. 360 and the y coordinates are within -90 .. 90, "+proj=longlat +datum=WGS84" is used. Also see under Details if \code{x} is a character (filename)}
\item{resolution}{numeric vector of length 1 or 2 to set the resolution (see \code{\link{res}}). If this argument is used, arguments \code{ncol} and \code{nrow} are ignored }
}


\value{
GeoRaster
}


\examples{
# Create a GeoRaster object from scratch
r1 <- rst(nrow=108, ncol=21, xmin=0, xmax=10)

# Create a GeoRaster object from a file
#   N.B.: For your own files, omit the 'system.file' and 'package="geo"' bits
#   these are just to get the path to files installed with the package

f <- system.file("external/test.grd", package="geo")
f
r <- rst(f)

logo <- rst(system.file("external/rlogo.grd", package="raster"))   
}


\keyword{methods}
\keyword{spatial}

