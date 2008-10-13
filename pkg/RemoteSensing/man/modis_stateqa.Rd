\name{modis stateqa}

\alias{modis.stateqa500a}
\alias{modis.stateqa500b}
\alias{modis.stateqa500c}
\alias{modis.stateqa500d}
\alias{modis.stateqa500e}
\alias{modis.stateqa500f}
\alias{modis.stateqa500g}
\alias{modis.stateqa500h}
\alias{modis.stateqa500i}
\alias{modis.stateqa500j}
\alias{modis.stateqa500k}


\title{ MODIS State Quality Assessment Extractor }
\description{
Makes Human-readable images of State Quality Assessment binary bits from MOD09A 500m products (Vermote et al., 2008), this is the proper place to find cloud related information.
Vermote E.F., Kotchenova S.Y., Ray J.P. MODIS Surface Reflectance User's Guide. Version 1.2. June 2008. MODIS Land Surface Reflectance Science Computing Facility. Homepage
}

\usage{
modis.stateqa500a(pixel) 
modis.stateqa500b(pixel) 
modis.stateqa500c(pixel)
modis.stateqa500d(pixel)
modis.stateqa500e(pixel)
modis.stateqa500f(pixel)
modis.stateqa500g(pixel)
modis.stateqa500h(pixel,bandno)
modis.stateqa500i(pixel)
modis.stateqa500j(pixel)
modis.stateqa500k(pixel) 
}


\arguments{
  \item{pixel}{ ~~Describe \code{nirchan} here~~ }
  \item{bandno}{ ~~Describe \code{chan} here~~ }
}

\details{
modis.stateqa500a - Cloud State 
modis.stateqa500b - cloud shadow 
modis.stateqa500c - LAND/WATER FLAG 
modis.stateqa500d - AEROSOL QUANTITY 
modis.stateqa500e - CIRRUS DETECTED 
modis.stateqa500f - Internal Cloud Algorithm Flag 
modis.stateqa500g - Internal Fire Algorithm Flag 
modis.stateqa500h - MOD35 snow/ice flag 
modis.stateqa500i - Pixel adjacent to cloud
modis.stateqa500j - BRDF correction performed
modis.stateqa500k - Internal Snow Mask


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

