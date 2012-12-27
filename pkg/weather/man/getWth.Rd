
\name{getWthPower}

\alias{getWthPower}


\title{ Get weather data }

\description{
Get weather data from the NASA Power database. The function returns data for (tiles of) indivual grid cells on a 1 degree global grid. Daily data from 1 Jan 1983 to present (see Details).
}

\usage{
getWthPower(lon, lat, start="1983-1-1", end="2012-12-31", overwrite=FALSE, ...) 
}

\arguments{
\item{lon}{numeric. Latitude }  
\item{lat}{numeric. Longitude }    
\item{start}{charcter. First date, formatted yyyy--mm-dd}
\item{end}{character. Last date, formatted yyyy--mm-dd} 
\item{overwrite}{ logical. If \code{TRUE} previously downloaded files are overwritten }
}


\value{
An object of class 'Weather'
}

\examples{

\dontrun{
d <- getWthPower(6,56, overwrite=T)
}
}

\author{ Robert J. Hijmans }

