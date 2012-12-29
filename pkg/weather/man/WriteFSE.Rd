\name{Write weater data files}

\alias{writeFSE}

\title{ Write weather data files }

\description{
write FSE ("CABO") format weather file (Wageningen crop models) 
}

\usage{
writeFSE(w, country='AAA', station=1, wind=2.5,  path=getwd())
}

\arguments{
  \item{w}{object of class 'Weather'}
  \item{country}{character }    
  \item{station}{integer}    
  \item{wind}{ value for daily wind speed}    
  \item{path}{ describe \code{x} here }    
  \item{...}{ additional arguments} 
}


\value{
Nothing. Used for its side effect of creating files.
}

\examples{
f <- system.file("external/power_12427.nasa", package = "weather")
wth <- getWthFile(f)
writeFSE(wth)
}
