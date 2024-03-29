\name{extract}

\docType{methods}

\alias{extract}
\alias{extract,SpatRaster,SpatVector-method}
\alias{extract,SpatRaster,matrix-method}
\alias{extract,SpatRaster,data.frame-method}
\alias{extract,SpatRaster,numeric-method}
\alias{extract,SpatVector,SpatVector-method}


\alias{[,SpatRaster,SpatVector,missing-method}
\alias{[,SpatRaster,missing,missing-method}
\alias{[,SpatRaster,numeric,missing-method}
\alias{[,SpatRaster,missing,numeric-method}
\alias{[,SpatRaster,numeric,numeric-method}
\alias{[,SpatRaster,SpatRaster,missing-method}


\title{Extract values from a SpatRaster}

\description{
Extract values from a SpatRaster for a set of locations. The locations can be a SpatVector (points, lines, polygons), a matrix with (x, y) or (longitude, latitude -- in that order!) coordinates, or a vector with cell numbers.  
} 

\usage{
\S4method{extract}{SpatRaster,SpatVector}(x, y, fun=NULL, method="simple", list=FALSE, factors=TRUE, 
        cells=FALSE, weights=FALSE, touches=is.lines(y), ...)

\S4method{extract}{SpatRaster,matrix}(x, y, ...)

\S4method{extract}{SpatRaster,numeric}(x, y, ...)
}

\arguments{
\item{x}{SpatRaster}
\item{y}{SpatVector (for points, lines, polygons), or for points, 2-column matrix or data.frame (x, y) or (lon, lat), or a vector with cell numbers}
\item{fun}{function to summarize the data by geometry (e.g. polygon)}
\item{...}{additional arguments to \code{fun} if \code{y} is a SpatVector or arguments passed to the \code{SpatRaster,SpatVector} method if \code{y} is a matrix (i.e., the \code{method} and \code{cells} arguments)}
\item{method}{character. method for extracting values with points. The default is "simple", the alternative is "bilinear"}
\item{list}{logical. If \code{FALSE} the output is simplified to a matrix (if \code{fun=NULL})}
\item{factors}{logical. If \code{TRUE} the categories are returned as factors instead of their numerical representation. The value returned becomes a data.frame if it otherwise would have been a matrix, even if there are no factors}
\item{cells}{logical. If \code{TRUE} the cell numbers are also returned, unless \code{fun} is not \code{NULL}. Also see \code{\link{cells}}}
\item{weights}{logical. If \code{TRUE} and \code{y} has polygons, the fraction of each cell that is covered is returned as well, to compute a weighted mean. If \code{fun} is not \code{NULL}, the weighted mean is returned}
\item{touches}{logical. If \code{TRUE}, values for all cells touched by lines or polygons are extracted, not just those on the line render path, or whose center point is within the polygon. Not relevant for points}
}

\value{matrix, list, or data.frame}

\seealso{\link{values}}

\examples{
r <- rast(ncol=5, nrow=5, xmin=0, xmax=5, ymin=0, ymax=5)
values(r) <- 1:25
xy <- rbind(c(0.5,0.5), c(2.5,2.5))
p <- vect(xy, crs="+proj=longlat +datum=WGS84")

extract(r, xy)
extract(r, p)

r[1,]
r[5]
r[,5]

r[c(0:2, 99:101)]

f <- system.file("ex/test.tif", package="terra")
r <- rast(f)

xy <- cbind(179000, 330000)
xy <- rbind(xy-100, xy, xy+1000)
extract(r, xy)

p <- vect(xy)
g <- geom(p)
g

extract(r, p)

x <- r + 10
extract(x, p)

i <- cellFromXY(r, xy)
x[i]
r[i]

y <- c(x,x*2,x*3)
y[i]

## extract with a polygon
f <- system.file("ex/lux.shp", package="terra")
v <- vect(f)
v <- v[1:2,]
z <- rast(v, res=.1)
values(z) <- 1:ncell(z)
#e <- extract(z, v)
#e
#tapply(e[,2], e[,1], mean)

#ee <- extract(z, v, list=TRUE)
#rapply(ee, mean)

#x <- c(z, z*2, z/3)
#names(x) <- letters[1:3]

#e <- extract(x, v)
#de <- data.frame(e)
#aggregate(de[,2:4], de[,1,drop=FALSE], mean)

#ee <- extract(x, v, list=TRUE)
#matrix(rapply(ee, mean), ncol=nlyr(x), byrow=TRUE)

### SpatVector-SpatVector


}

\keyword{methods}
\keyword{spatial}

