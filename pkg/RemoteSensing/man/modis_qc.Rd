\name{modis_qc}

\alias{modis.qc250a}
\alias{modis.qc250b}
\alias{modis.qc250c}
\alias{modis.qc250d} 
\alias{modis.qc250e}
\alias{modis.qc250f}
\alias{modis.qc500a}
\alias{modis.qc500c}
\alias{modis.qc500d}
\alias{modis.qc500e}


\title{ MODIS Quality Assessment Extractor }
\description{ Makes Human-readable images of Quality Assessment binary bits from MOD09AQ products.
}

\usage{

modis.qc250a(pixel)
modis.qc250b(pixel)
modis.qc250c(pixel,bandno) 
modis.qc250d(pixel) 
modis.qc250e(pixel)
modis.qc250f(pixel)
modis.qc500a(pixel) 
modis.qc500c(pixel,bandno)
modis.qc500d(pixel)
modis.qc500e(pixel)



}


\arguments{
  \item{pixel}{ ~~Describe \code{nirchan} here~~ }
  \item{bandno}{ ~~Describe \code{chan} here~~ }

}

\details{
modis.stateqa500a returns Cloud State
modis.stateqa500b returns Cloud shadow
modis.stateqa500c returns LAND/WATER FLAG
modis.stateqa500d returns AEROSOL QUANTITY
modis.stateqa500e returns CIRRUS DETECTED
modis.stateqa500f returns Internal Cloud Algorithm Flag
modis.stateqa500g returns Internal Fire Algorithm Flag
modis.stateqa500h returns MOD35 snow/ice flag
modis.stateqa500i returns Pixel adjacent to cloud
modis.stateqa500j returns BRDF correction performed
modis.stateqa500k returns Internal Snow Mask
}
\value{
  
}
\references{ ~put references to the literature/web site here ~ }
\author{ Yann Chemin }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

}
\keyword{ spatial }

