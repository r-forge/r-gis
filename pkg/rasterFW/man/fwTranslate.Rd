\name{fwTranslate}


\alias{fwTranslate}

\title{Change file format}

\description{
Save a raster dataset to another file format.
}


\usage{
fwTranslate(x, filename, format, options=NULL)
}

\arguments{
  \item{x}{Character (filename), Raster* or SpatialGrid* object}
  \item{filename}{Character. Output filename (optional)}  
  \item{format}{Character. GDAL \href{http://www.gdal.org/formats_list.html}{format code} } 
  \item{options}{options. See \url{http://www.gdal.org/gdal_translate.html} }  
}


\value{
Raster object
}

\seealso{
\url{http://www.gdal.org/gdal_translate.html} 
}


\author{Robert J. Hijmans}


\keyword{methods}
\keyword{spatial}

