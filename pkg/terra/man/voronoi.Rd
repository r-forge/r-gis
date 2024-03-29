\name{voronoi}

\alias{delauny}
\alias{voronoi}
\alias{voronoi,SpatVector-method}
\alias{delauny,SpatVector-method}


\title{voronoi diagram and delauny triangles}

\description{
Get a voronoi diagram or delauny triangles for points, or nodes of lines or polygons
}

\usage{
\S4method{voronoi}{SpatVector}(x, bnd=NULL, tolerance=0, as.lines=FALSE, ...) 

\S4method{delauny}{SpatVector}(x, tolerance=0, as.lines=FALSE, ...) 
}


\arguments{
\item{x}{SpatVector}
\item{bnd}{SpatVector to set the outer boundary of the voronoi diagram}
\item{tolerance}{numeric >= 0, snapping tolerance (0 is no snapping)}
\item{as.lines}{logical. If \code{TRUE}, lines are returned without the outer boundary}
\item{...}{additional arguments. None implemented}  
}


\value{SpatVector}


\examples{
wkt <- c("MULTIPOLYGON ( ((40 40, 20 45, 45 30, 40 40)), 
  ((20 35, 10 30, 10 10, 30 5, 45 20, 20 35),(30 20, 20 15, 20 25, 30 20)))", 
  "POLYGON ((0 -5, 10 0, 10 -10, 0 -5))")
x <- vect(wkt)
v <- voronoi(x)
v

plot(v, lwd=2, col=rainbow(15))
lines(x, col="gray", lwd=2)
points(x)
}

\keyword{spatial}

