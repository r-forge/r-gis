\name{checkCRS}

\alias{checkCRS}


\title{ Check CRS }

\description{
Check CRS with R bridge to PROJ.4 library
}

\usage{
checkCRS(crs)
}


\arguments{
  \item{crs}{ character. PROJ.4 formatted coordinate reference system description }
}

\value{
boolean
}

\author{ Robert J Hijmans }

\examples{
checkCRS("+proj=longlat +ellps=clrk66")
checkCRS("")
}

\keyword{ spatial }
