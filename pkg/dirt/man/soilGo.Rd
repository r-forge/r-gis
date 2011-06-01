\name{soilGo}
\alias{soilGo}

\title{ import & process STATGO or SSURGO data }

\description{
STATSGO and SSURGO are soil survey database for the Unites States
}

\usage{
soilGo(dat, depth=10, props=c("om_r", "claytotal_h", "claytotal_l"), filename='', sp = NULL, raster=NULL, ... ) 

}
\arguments{
  \item{dat}{ Either an Access database file, or the 'tabular' folder}
  \item{depth}{ soil depth over which to average the values }
  \item{props}{ soil proporties requested }
  \item{filename}{ filename !}
  \item{sp}{ SpatialPolygons with MUKEY field}
  \item{raster}{ RasterLayer with MUKEY values}
  \item{...}{ nada }
}

\value{
depends
}

\author{ Robert J Hijmans }


\keyword{ spatial }
