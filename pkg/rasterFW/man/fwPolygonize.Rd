\name{fwPolygonize}


\alias{fwPolygonize}

\title{Convert raster to pplygons}

\description{
Save a raster dataset to another file format.
}


\usage{
fwPolygonize(x, options=NULL) 
}

\arguments{
  \item{x}{Character (filename), Raster* or SpatialGrid* object}
  \item{options}{options. See \url{http://www.gdal.org/gdal_polygonize.html} }  
}


\value{
SpatialPolygonsDataFrame
}

\seealso{
\url{http://www.gdal.org/gdal_polygonize.html} 
}


\author{Robert J. Hijmans}



\keyword{spatial}

