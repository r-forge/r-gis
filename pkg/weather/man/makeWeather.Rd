\name{makeWeather}

\alias{makeWeather}

\title{Create a WeatherStations object}

\description{
Create a WeatherStations object
}

\usage{
makeWeather(id, lon, lat, elev, time, d, att) 
}

\arguments{
  \item{id}{character} 
  \item{lon}{numeric. Latitude } 
  \item{lat}{numeric. Longitude }    
  \item{elev}{numeric. Elevation (in meters above mean sea level) } 
  \item{time}{an object of class xts, or a time vector (Date, POSIXct, timeDate, yearmon and yearqtr; see \code{\link[xts]{xts}}); in the latter case, it should be in time order}
  \item{d}{data.frame}
  \item{att}{further attributes for the weather stations (locations)}
}

\value{
An object of class 'WeatherStations'
}

\author{ Robert J. Hijmans }

\examples{
#single station
d <- data.frame(a=1:10, b=1:10)
id = 'ABC'
lon =10
lat =5
elev = 115
time = ISOdate(2000, 1, 1:10)
w1 <- makeWeather(id, lon, lat, elev, time, d)


# multiple stations
dd <- rbind(d,d,d)
ids = c('A', 'B', 'C')
lons = 1:3
lats = 5:7
elevs = 100:102
w3 <- makeWeather(ids, lons, lats, elevs, time, dd)
}

