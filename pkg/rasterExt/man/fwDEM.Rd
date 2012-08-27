\name{fwDEM}


\alias{fwDEM}

\title{dem processing}

\description{
Derive slope, aspect, etcetera from an elevation raster (elevation rasters are sometimes referred to with the awkward term "DEM", or "digigal elevation model")
}


\usage{
fwDEM(dem, type='slope', filename="", options=NULL, format='GTiff')
}

\arguments{
  \item{dem}{filename, RasterLayer, or SpatialGridDataFrame. If the object has multiple layers, the first is assumed to have the elevation data}
  \item{type}{Character. One of: "hillshade", "slope", "aspect", "color-relief", "TRI", "TPI", "roughness"}
  \item{filename}{Character. Output filename (optional)}  
  \item{options}{options. See \url{http://www.gdal.org/gdaldem.html} }
  \item{format}{Character. GDAL \href{http://www.gdal.org/formats_list.html}{format code} } 
}


\value{
RasterLayer
}

\seealso{
\url{http://www.gdal.org/gdaldem.html} 
}


\author{Lyndon Estes and Robert J. Hijmans}



\keyword{spatial}

