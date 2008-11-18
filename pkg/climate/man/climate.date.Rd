\name{date}

\alias{date.from.doy}
\alias{doy.from.date}
\alias{is.leapyear}
\alias{days.in.year}
\alias{get.daylength}
\alias{get.daylength2}

\title{ date routines }
\description{
  Conversion between day of year number to date and back
}

\usage{
date.from.doy(doy, year)
doy.from.date(date)
is.leapyear(year)
days.in.year(year)
get.daylength(lat, doy)
get.daylength2(lat, doy)
}

\arguments{
  \item{doy}{ Day of the year (1..365) or (1:366) for leap years }
  \item{year}{ year, e.g. 1982 }
  \item{date}{ date (Date or character class) as 'yyyy-mm-dd', e.g. '1982-11-23' }  
  \item{lat}{ latitude, in degrees. I.e. between -90.0 and 90.0 }
}

\value{
  Day of the year or Date
}

\author{ Robert J. Hijmans }
\examples{
	doy <- 88
	year <- 1970
	date <- date.from.doy(doy, year)
	date
	date.from.doy(-15, 2000)
	doy.from.date(date)
	is.leapyear(2000)
	days.in.year(2000)
	days.in.year(1999)
}
\keyword{ spatial }
