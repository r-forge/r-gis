\name{lswi}

\alias{lswi}
\alias{water}
\alias{water.modis}


\title{ Water Mapping and related indices }
\description{
  Compute the Water Identification and other water related indices from remote sensing data. 
}

\usage{
lswi(nirchan, swirchan) 
water(ndvi, albedo) 
water.modis(ndvi, band7) 
}

\arguments{
  \item{nirchan}{ Value of the \code{NIR} satellite band }
  \item{swirchan}{ Value of the \code{SWIR} satellite band }
  \item{ndvi}{ NDVI layer \code{vi.ndvi} }
  \item{band7}{ MODIS \code{Band7} satellite band }
  \item{albedo}{ albedo layer from \code{albedo.*}  }

}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  Water Mapping
}
\references{ 
 Xiao X., Boles S., Liu J., Zhuang D., Frokling S., Li C., 
 Salas W., Moore III B. (2005). 
 Mapping paddy rice agriculture in southern China using 
 multi-temporal MODIS images. 
 Remote Sensing of Environment 95:480-492.
 
 Roy D.P., Jin Y., Lewis P.E., Justice C.O. (2005). 
 Prototyping a global algorithm for systematic fire-affected
 area mapping using MODIS time series data. 
 Remote Sensing of Environment 97:137-162.
}
\author{ Yann Chemin }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

}
\keyword{ spatial }

