\name{raster.utilities}
\alias{raster.compare}
\alias{create.CRS}
\alias{create.boundingbox}

  
\title{ Compare rasters }
\description{
  raster.compare evaluates whether a list of rasters has the same origin, resolution, number of rows and columns, and projection (or a subset thereof).
  create.CRS is a helper function to create a CRS map projection object.
  create.boundingbox creates a new bounding box (a "Spatial" object) that can be used to....
}

\usage{
raster.compare(rasters, origin=TRUE, resolution=TRUE, rowcol=TRUE, projection=TRUE, slack=0.01, stopiffalse=TRUE) 
create.CRS(projection)
create.boundingbox(xmin, xmax, ymin, ymax, projection="")

}

\arguments{
  \item{rasters} {}
  \item{origin} {}
  \item{resolution}{}
  \item{rowcol}{}
  \item{projection}{ logical in raster.compare. If \code{TRUE} rasters projections are compared. In create.CRS it is a proj4 type string. }
  \item{slack} {}
  \item{stopiffalse}{}
  
  \item{xmin}{ the minimum x coordinate of the bounding box }
  \item{xmax}{ the maximum x coordinate of the bounding box }
  \item{ymin}{ the minimum y coordinate of the bounding box }
  \item{ymax}{ the maximum y coordinate of the bounding box }
 }
  
\value{
}

\author{Robert J. Hijmans  \email{r.hijmans@gmail.com}}
\examples{
}
\keyword{ spatial }
