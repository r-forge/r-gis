\name{soilGo}

\alias{soilGo}

\title{ import & process STATGO or SSURGO data }

\description{
STATSGO and SSURGO are soil survey database for the Unites States
}

\usage{
soilGo(dat, dpfrom=0, dpto=15, props=c("om_r", "claytotal_h"), sp=TRUE, raster=FALSE, filename='', overwrite=FALSE,  verbose=TRUE, ... ) 
}


\arguments{
  \item{dat}{ Either a .zip file or an access database (mdb) file with a single SSURGO/STATSGO data set}
  \item{dpfrom}{ upper soil depth over which to average the values }
  \item{dpto}{ lower soil depth over which to average the values }
  \item{props}{ soil proporties requested }
  \item{sp}{ Logical. Should values be returned as a SpatialPolygonsDataFrame (and should a shapefile be written, if a filename is supplied)}
  \item{raster}{ RasterLayer with MUKEY values. If sp=FALSE, a RasterBrick will be returned }
  \item{filename}{ filename }
  \item{overwrite}{ overwrite existing files? }  
  \item{verbose}{ verbose feedback }  
  \item{...}{ nada }
}

\value{
data.frame, SpatialPolygonsDataFrame, or RasterBrick
}

\author{ Robert J Hijmans }


\keyword{ spatial }
