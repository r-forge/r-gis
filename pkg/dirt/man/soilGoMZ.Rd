\name{soilGoMZ}

\alias{soilGoMZ}

\title{ Import & process STATGO or SSURGO data }

\description{
STATSGO and SSURGO are soil survey database for the Unites States
}

\usage{
soilGoMZ(zipdat, dpfrom=0, dpto=15, props=c("om_r", "claytotal_h"), sp=FALSE, tofile=TRUE, overwrite=FALSE, verbose=TRUE, ... ) 

}
\arguments{
  \item{zipdat}{ A .zip file with a multiple SSURGO/STATSGO data sets (each in a zip file themselves) }
  \item{dpfrom}{ upper soil depth over which to average the values }
  \item{dpto}{ lower soil depth over which to average the values }
  \item{props}{ soil proporties requested }
  \item{sp}{ Logical. Should values be returned as a SpatialPolygonsDataFrame (and should a shapefile be written, if a filename is supplied)}
  \item{tofile}{ save results to a file? }  
  \item{overwrite}{ Logical }
  \item{verbose}{ verbose feedback }  
  \item{...}{ nada }
}

\value{
data.frame, SpatialPolygonsDataFrame, or RasterBrick
}

\author{ Robert J Hijmans }


\keyword{ spatial }
