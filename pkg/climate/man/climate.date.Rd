\name{date}

\alias{date.from.doy}
\alias{doy.from.date}

\title{ date routines }
\description{
  Conversion between day of year number to date and back
}

\usage{
date.from.doy(doy, year)
doy.from.date(date)
}

\arguments{
  \item{doy}{ Day of the year (1..365) or (1:366) for leap years }
  \item{year}{ year, e.g. 1982 }
  \item{date}{ date (Date or character class) as 'yyyy-mm-dd', e.g. '1982-11-23' }  
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
	doy.from.date(date)
}
\keyword{ spatial }
