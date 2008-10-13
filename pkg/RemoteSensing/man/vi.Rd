\name{rs.vi}
\alias{rs.vi}
\alias{calc.arvi}
\alias{calc.wdvi}
\alias{calc.sr}
\alias{calc.savi}
\alias{calc.pvi}
\alias{calc.ndvi}
\alias{calc.msavi}
\alias{calc.msavi2}
\alias{calc.ipvi}
\alias{calc.gvi}
\alias{calc.gemi}
\alias{calc.gari}
\alias{calc.evi}
\alias{calc.dvi}



\title{ Vegetation Indices }
\description{
  Compute vegetation indices fro remote sensing data. 
}

\usage{
rs.vi(rasterstack, outputfilename, vegindex="ndvi", redchan=NA, nirchan=NA, bluechan=NA, greenchan=NA, chan5=NA, chan7=NA, slslopechan=NA, overwrite=FALSE) 
calc.arvi(red, nir, blue)
calc.wdvi(red, nir, slslope = 1)
calc.sr(red, nir)
calc.savi(red, nir)
calc.pvi(red, nir)
calc.ndvi(red, nir)
calc.msavi(red, nir)
calc.msavi2(red, nir)
calc.ipvi(red, nir)
calc.gvi(blue, green, red, nir, ch5, ch7)
calc.gemi(red, nir)
calc.gari(red, nir, blue, green)
calc.evi(blue, red, nir)
calc.dvi(red, nir)
}


\arguments{
  \item{rasterstack}{ ~~Describe \code{red} here~~ }
  \item{outputfilename}{ ~~Describe \code{red} here~~ }
  \item{vegindex}{ ~~Describe \code{red} here~~ }
  \item{overwrite}{ If \code{overwrite} is \code{TRUE} existing files will be overwritten}

  \item{redchan}{ the index of the raster in the rasterstack that has the red channel (band) }
  \item{nirchan}{ the index of the raster in the rasterstack that has the red channel (band) }
  \item{bluechan}{ the index of the raster in the rasterstack that has the red channel (band) }
  \item{greenchan}{ the index of the raster in the rasterstack that has the red channel (band) }
  \item{chan5}{ the index of the raster in the rasterstack that has the red channel (band) }
  \item{chan7}{ the index of the raster in the rasterstack that has the red channel (band) }
  \item{slslopechan}{ the index of the raster in the rasterstack that has the red channel (band) }  

  \item{red}{ array of red channel (band) data}
  \item{nir}{ array of red channel (band) data }
  \item{blue}{ array of red channel (band) data }
  \item{green}{ array of red channel (band) data }
  \item{ch5}{ array of red channel (band) data }
  \item{ch7}{ array of red channel (band) data }
  \item{slslope} { array of red channel (band) data }  
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  vegetation index
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

