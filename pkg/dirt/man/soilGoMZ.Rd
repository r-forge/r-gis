\name{soilGoMZ}

\alias{soilGoMZ}

\title{ Import & process STATGO or SSURGO data }

\description{
STATSGO and SSURGO are soil survey database for the Unites States
}

\usage{
soilGoMZ(zipdat, depth=10, props=c("om_r", "claytotal_h"), tofile=TRUE, sp = NULL, verbose=TRUE, ... ) 

}
\arguments{
  \item{zipdat}{ A .zip file with a multiple SSURGO/STATSGO data sets (each in a zip file themselves) }
  \item{depth}{ soil depth over which to average the values }
  \item{props}{ soil proporties requested }
  \item{tofile}{ save results to a file? }  
  \item{sp}{ SpatialPolygons with MUKEY field}
  \item{verbose}{ verbose feedback }  
  \item{...}{ nada }
}

\value{
data.frame, SpatialPolygonsDataFrame, or RasterBrick
}

\author{ Robert J Hijmans }


\keyword{ spatial }
