\name{soilGo}

\alias{soilGo}
\alias{soilGoMZ}

\title{ import & process STATGO or SSURGO data }

\description{
STATSGO and SSURGO are soil survey database for the Unites States
}

\usage{
soilGo(dat, depth=10, props=c("om_r", "claytotal_h"), filename='', overwrite=FALSE, sp = NULL, raster=NULL, verbose=TRUE, ... ) 
soilGoMZ(zipdat, depth=10, props=c("om_r", "claytotal_h"), tofile=TRUE, sp = NULL, verbose=TRUE, ... ) 

}
\arguments{
  \item{dat}{ Either a .zip file or an access database (mdb) file with a single SSURGO/STATSGO data set}
  \item{zipdat}{ A .zip file with a multiple SSURGO/STATSGO data sets (each in a zip file themselves) }
  \item{depth}{ soil depth over which to average the values }
  \item{props}{ soil proporties requested }
  \item{filename}{ filename }
  \item{overwrite}{ overwrite existing files? }  
  \item{tofile}{ save results to a file? }  
  \item{sp}{ SpatialPolygons with MUKEY field}
  \item{raster}{ RasterLayer with MUKEY values}
  \item{verbose}{ verbose feedback }  
  \item{...}{ nada }
}

\value{
data.frame, SpatialPolygonsDataFrame, or RasterBrick
}

\author{ Robert J Hijmans }


\keyword{ spatial }
