\name{vi}
\alias{arvi}
\alias{wdvi}
\alias{sr}
\alias{savi}
\alias{pvi}
\alias{ndvi}
\alias{msavi}
\alias{msavi2}
\alias{ipvi}
\alias{gvi}
\alias{gemi}
\alias{gari}
\alias{evi}
\alias{dvi}
\alias{vari}



\title{ Vegetation Indices }
\description{
  Compute vegetation indices from remote sensing data. 
}

\usage{
arvi(red, nir, blue)
wdvi(red, nir, slslope = 1)
sr(red, nir)
savi(red, nir)
pvi(red, nir)
ndvi(red, nir)
msavi(red, nir)
msavi2(red, nir)
ipvi(red, nir)
gvi(blue, green, red, nir, ch5, ch7)
gemi(red, nir)
gari(red, nir, blue, green)
evi(blue, red, nir)
dvi(red, nir)
vari(blue, green, red)
}


\arguments{
  \item{red}{ array of red channel (band) data}
  \item{nir}{ array of nir channel (band) data }
  \item{blue}{ array of blue channel (band) data }
  \item{green}{ array of green channel (band) data }
  \item{ch5}{ array of Channel5 channel (band) data }
  \item{ch7}{ array of Channel7 channel (band) data }
  \item{slslope} { value of soil line slope }  
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
#
#MODIS NDVI PROCESSING EXAMPLE
#
#require(Rgis)
#require(RemoteSensing)

#Set filenames
\dontrun{filename1<-"afilename"}
\dontrun{filename2<-anotherfilename}

#Create raster object
\dontrun{red <- raster.create.from.file(filename1)}
\dontrun{nir <- raster.create.from.file(filename2)}

#Load data into raster object
\dontrun{red <- raster.read.all(red)}
\dontrun{nir <- raster.read.all(nir)}

#Modis scaling processing function
\dontrun{
modisscale<-function (band){
result <- band / 10000.0
result[is.nan(result)] <- NA
return(result)}
}

#Scale bands
\dontrun{red <- raster.calc(red, fun=modisscale)}
\dontrun{nir <- raster.calc(nir, fun=modisscale)}

#Set null values
\dontrun{red <- raster.calc.setNA(red, value=-2.8672)}
\dontrun{nir <- raster.calc.setNA(nir, value=-2.8672)}

#NDVI CALCULATIONS
#Create double input processing function
\dontrun{
calc.x <- function(rsstack, fun, filename=NA, overwrite=FALSE) {
res <- fun(raster.values(rsstack@rasters[[1]]), raster.values(rsstack@rasters[[2]]))
res[is.infinite(res)] <- NA
res[res < -1] <- -1
res[res > 1] <- 1
out.raster <- raster.set.filename(rsstack@rasters[[1]] , "")
out.raster <- raster.set.data(out.raster, res)
return(out.raster)}
}

#For calculating NDVI
\dontrun{stack1 <- rasterstack.create.from.rasters(c(red,nir))}
\dontrun{outndvi <- raster.create.new()}
\dontrun{outndvi <- raster.set.datatype(outndvi,"numeric")}
\dontrun{outndvi <- calc.x(stack1, ndvi)}

#Plot the raster output
\dontrun{raster.map(outndvi, col=grey(0:255/255))}
#add Philippines country administrative boundary
\dontrun{plot(read.adm("PHL"), add=T, border="red")}
}
\keyword{ spatial }

