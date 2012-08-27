\name{Write weater data files}
\alias{writeCABOwth}

\title{ Write weather data files }

\description{
write CABO format weather file (Wageningen crop models) 
}

\usage{
writeCABOwth(w, country='AAA', station=1, wind=2.5,  path=getwd(), print=TRUE, boundlat=TRUE, rainfact=1, tempfact=0)
}

\arguments{
  \item{w}{object of class 'weather'}
  \item{country}{character }    
  \item{station}{integer}    
  \item{wind}{ value for daily wind speed}    
  \item{path}{ Describe \code{x} here }    
  \item{print}{ print progress to screen}    
  \item{boundlat}{ Bound latitide between -59 and 59 }    
  \item{rainfact}{ Describe \code{x} here }    
  \item{tempfact}{ Describe \code{x} here }    
}


\value{
Nothing. Used for its side effect of creating files.
}

\author{Robert J. Hijmans}

\examples{
f <- system.file("external/daily_weather_12427.nasa", package = "weather")
wth <- getWthFile(f)
writeCABOwth(wth)
}

\keyword{ spatial }
