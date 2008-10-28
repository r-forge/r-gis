\name{raster.utilities}
\alias{raster.compare}
\alias{create.CRS}
  
\title{ Compare rasters }
\description{
  raster.compare evaluates whether a list of rasters has the same origin, resolution, number of rows and columns, and projection (or a subset thereof).
  create.CRS attempts to coerce a string into a CRS (proj4 type projection description) object. There is a warning if this fails. 
}

\usage{
raster.compare(rasters, origin=TRUE, resolution=TRUE, rowcol=TRUE, projection=TRUE, slack=0.01, stopiffalse=TRUE) 
create.CRS(projection)
}

\arguments{
  \item{rasters} {}
  \item{origin} {}
  \item{resolution}{}
  \item{rowcol}{}
  \item{projection}{}
  \item{slack} {}
  \item{stopiffalse}{}
 }
  
\value{
}

\author{Robert J. Hijmans  \email{r.hijmans@gmail.com}}
\examples{
}
\keyword{ spatial }
