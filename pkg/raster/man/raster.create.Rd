\name{raster}
\alias{raster.new}
\alias{raster.file}
\title{ Create a new raster object }
\description{
  This function let you create a new raster object, either from scratch "new" or from file.
  The raster object does not contain the data, only the parameters that describe it
}
\usage{
	raster.new(xmin = -180, xmax = 180, ymin = -90, ymax = 90, nrows = 180, ncols = 360, projection = "+proj=longlat +datum=WGS84")
	raster.file(filename, band=1)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{filename}{ name of raster data file  }
  \item{band}{ band number in case of a file of multiple bands, default = 1 }
  \item{xmin}{ minimum x coordinate or raster (left border) }
  \item{xmax}{ maximum x coordinate of raster (right border) }
  \item{ymin}{ minimum y coordinate or raster (bottom border) }
  \item{ymax}{ maximum y coordinate of raster (top border) }
  \item{nrows}{ number of rows on raster }
  \item{ncols}{ number of columns on raster }
  \item{projection}{ map projection of raster data }
}
\details{
  raster.file uses "GDALinfo" from the rgdal package
  see the rgdal help for supported file types
}

\value{
  raster object
}
\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}

\seealso{  \code{\link[gdal]{rgdal}} }
\examples{
  raster1 <- raster.new(nrows=1080, ncols=2160)
  raster1
  raster2 <- raster.file(system.file("external/test.ag", package="sp"))
  raster2
}
\keyword{ spatial }
