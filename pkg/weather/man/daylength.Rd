\name{daylength}

\alias{daylength}

\title{ daylength}

\description{
Compute daylenght (photoperiod) at a latitude for a day of the year.
}

\usage{
daylength(lat, doy)
}

\arguments{
  \item{lat}{latitude, in degrees. I.e. between -90.0 and 90.0 }
  \item{doy}{Day of the year. Integer between 1 and 365}
}

\value{
double  
}

\examples{
daylength(52, 50)
daylength(5, 50)
daylength(55, 180)

p <- daylength(52, 1:365)
d <- dateFromDoy(1:365, 2001)
plot(d, p)
}
