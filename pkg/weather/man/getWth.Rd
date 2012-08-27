\name{getWthXY}

\alias{getWthXY}


\title{ Get weather data}

\description{
  Get weather data from a NASA website
}


\usage{
getWthXY(lon, lat, start="1983-1-1", end="2012-12-31", overwrite=FALSE) 
}

\arguments{
  \item{lon}{numeric. Latitude }  
  \item{lat}{numeric. Longitude }    
  \item{start}{charcter. First date, formatted yyyy--mm-dd}
  \item{end}{character. Last date, formatted yyyy--mm-dd} 
  \item{overwrite}{ logical. If \code{TRUE} previously downloaded files are overwritten. If \code{FALSE}, the start and end date arguments are ignored }
}


\value{
An object of class 'WeatherStations'
}

\examples{
\dontrun{
d <- getWthXY(6,56, overwrite=T)
}
}

\author{ Robert J. Hijmans }
