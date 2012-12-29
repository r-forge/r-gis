
\name{getWthPower}

\alias{getWthPower}


\title{ Get weather data }

\description{
Get weather data from the NASA Power database. The function returns data for (tiles of) indivual grid cells on a 1 degree global grid. Daily data from 1 Jan 1983 to present (see Details).
}

\usage{
getWthPower(lon, lat, overwrite=FALSE, tile=FALSE, folder=getwd(), quiet, ...) 
}

\arguments{
\item{lon}{numeric between -180 and 180 (degrees latitude)}
\item{lat}{numeric between -90 and 90 (degrees longitude)}
\item{overwrite}{ logical. If \code{TRUE} previously downloaded files are overwritten }
\item{tile}{logical. If \code{TRUE} a 10 by 10 degrees tile (100 records) is downloaded for faster processing of adjacent locations}
\item{folder}{character. Where (directory, path) should the downloaded records be saved?} 
\item{quiet}{logical. If \code{TRUE} suppress status messages (if any), and the progress bar. See \code{\link{download.file}}} 
\item{...}{Additional arguments} 
}



\value{
An object of class 'Weather'
}

\details{
To be done
}

\examples{
\dontrun{
d <- getWthPower(6,56, overwrite=T)
}
}

\author{ Robert J. Hijmans }

