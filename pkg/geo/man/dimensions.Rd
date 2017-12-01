\name{dimensions}

\docType{methods}

\alias{ncol}
\alias{nrow}
\alias{ncell}
\alias{nlayer}
\alias{dim}
\alias{ncol<-}
\alias{nrow<-}
\alias{ncell,ANY-method}
\alias{nrow,GeoRaster-method}
\alias{ncol,GeoRaster-method}
\alias{nlayer,GeoRaster-method}
\alias{ncell,GeoRaster-method}
\alias{length,GeoRaster-method}
\alias{nrow<-,GeoRaster-method}
\alias{ncol<-,GeoRaster-method}
\alias{dim,GeoRaster-method}
\alias{dim<-,GeoRaster-method}
\alias{length,GeoRaster-method}

\alias{res}
\alias{xres}
\alias{yres}
\alias{res,GeoRaster-method}
\alias{xres,GeoRaster-method}
\alias{yres,GeoRaster-method}


\title{Dimensions of a GeoRaster object}

\description{
Get or set the dimensions (number of rows, columns, cells, layers, length) of a GeoRaster object.
When setting dimensions, raster values are lost.
}

\usage{
\S4method{ncol}{GeoRaster}(x)
\S4method{nrow}{GeoRaster}(x)
\S4method{ncell}{GeoRaster}(x)
\S4method{nlayer}{GeoRaster}(x)
\S4method{res}{GeoRaster}(x)
\S4method{xres}{GeoRaster}(x)
\S4method{yres}{GeoRaster}(x)

\S4method{ncol}{GeoRaster}(x)<-value
\S4method{nrow}{GeoRaster}(x)<-value

}


\arguments{
\item{x}{GeoRaster object}
\item{value}{For ncol and nrow: postive integer. For res: one or two postive numbers }  
}

\value{
integer
}

\seealso{ \link{ext}}


\examples{
r <- georst()
ncell(r)
ncol(r)
nrow(r)
dim(r)

# nrow(r) <- 18
# ncol(r) <- 36
# equivalent to
# dim(r) <- c(18, 36) 

dim(r)
#dim(r) <- c(10, 10, 5)
dim(r)

xres(r)
yres(r)
res(r)

#res(r) <- 1/120
# set yres differently
#res(r) <- c(1/120, 1/60)
}

\keyword{spatial}

