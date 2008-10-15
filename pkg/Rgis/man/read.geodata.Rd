\name{read.adm}
\alias{read.adm}
\alias{list.adm}
\alias{remove.adm}
\alias{list.ISO3}
\alias{read.srtm}


\title{ Read geographic data into an object (and download the data first if necessary) }
\description{
	read.adm - Load (if necessary after downloading) adminstrative boundaries into a SpatialPolygonsDataFrame.
	The boundaries are available at different levels. They range from 0 to 2. 0 is country, 1 is first level of subdivision, etc. 
		Not all levels are available for all countries.
	list.adm shows which data layers are locally available (have been downloaded)
	remove.adm can be used to remove layers from the local disk
	
	list.ISO3 shows the ISO3 codes for all countries
	
	read.srtm reads (after download) SRTM elevation data (90 m resolution) by 5 x 5 degrees tile. Only available between 60 S and 60 N

}
\usage{
read.adm(ISO3="ABW", level = 0, download=TRUE)
list.adm(ISO3=NA, level=NA)
remove.adm(ISO3=NA, level=NA)
list.ISO3(start=1, end=243)
read.srtm(x=106, y=-6, download=TRUE)
}

\arguments{
  \item{ISO3}{ The \code{ISO3} code for a country }
  \item{level}{ The \code{level} of administrative division; 0 is country, 1 is first level of subdivision, etc. }
  \item{download}{ if \code{download} is TRUE, the data are downloaded to the local system if they are not there. }
  \item{start}{ an integer between 1 and 243 that can be used to display a subset of the country names and ISO3 codes }
  \item{end}{ an integer between 1 and 243 that can be used to display a subset of the country names and ISO3 codes }
  \item{x}{ x coordinate that should fall within the SRTM tile }  
  \item{y}{ y coordinate that should fall within the SRTM tile }    
}
\details{
	In remove.adm the keyword \code{ALL} can be used as a value for ISO3 to remove all adm files on disk.
}
\value{
	Returns a SpatialPolygonsDataFrame (see package sp)
}
\references{ 
	Admin boundary data, GADM: \url{http://biogeo.berkeley.edu/gadm/} 
	SRTM elevation data: \url{http://srtm.csi.cgiar.org/} }

\author{ \author{ Robert J. Hijmans \email{r.hijmans@gmail.com} } }
\examples{
	x <- read.adm()
	plot(x)
	list.adm()
	remove.adm()
}
\keyword{ spatial }
