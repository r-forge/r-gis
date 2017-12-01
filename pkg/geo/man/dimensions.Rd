\name{dimensions}

\alias{ncol}
\alias{nrow}
\alias{ncell}
\alias{nlayer}
\alias{dim}
\alias{ncell,ANY-method}
\alias{nrow,GeoRaster-method}
\alias{ncol,GeoRaster-method}
\alias{nlayer,GeoRaster-method}
\alias{ncell,GeoRaster-method}
\alias{length,GeoRaster-method}
\alias{nrow<-}
\alias{ncol<-}
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
ncol(x)
nrow(x)
ncell(x)
nlayer(x)
res(x)
xres(x)
yres(x)

ncol(x) <- value
nrow(x) <- value
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

