\name{project4}

\alias{project4}


\title{ Transform spatial coordinates }

\description{
R bridge to PROJ.4 library
}

\usage{
project4(xy, from, to)
}


\arguments{
  \item{xy}{ matrix with two columns}
  \item{from}{ character. PROJ.4 formatted coordinate reference system description }
  \item{to}{ character. PROJ.4 formatted coordinate reference system description }
}

\value{
matrix
}

\author{ Robert J Hijmans }

\examples{
xy <- cbind(c(15,-16), c(6, 25))
pfrom <- "+proj=longlat +ellps=clrk66"
pto <- "+proj=merc +ellps=clrk66 +lat_ts=33"
p <- project4(xy, pfrom, pto)
p

project4(p, pto, pfrom)
}

\keyword{ spatial }
