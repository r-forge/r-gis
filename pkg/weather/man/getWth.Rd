
\name{wthPower}

\alias{wthPower}


\title{ Get weather data }

\description{
Get weather data from the NASA Power database. The function returns data for (tiles of) indivual grid cells on a 1 degree global grid. Daily data from 1 Jan 1983 to present (see Details).
}

\usage{
wthPower(lon, lat, folder=file.path(getwd(), 'power'), ...) 
}

\arguments{
\item{lon}{numeric between -180 and 180 (degrees latitude)}
\item{lat}{numeric between -90 and 90 (degrees longitude)}
\item{folder}{character. Where (directory, path) should the downloaded records be saved?} 
\item{...}{additional arguments} 
}



\value{
data.frame with weather data between 1983 and 2016.
}

\references{
http://power.larc.nasa.gov/common/php/Agro_ExSummary.php

Paul W. Stackhouse, Jr, David Westberg, James M. Hoell, William S. Chandler, Taiping Zhang. Prediction Of Worldwide Energy Resource (POWER) --- Agroclimatology Methodology ---
(1 Latitude by 1 Longitude Spatial Resolution) (Version 1.0.2 June 4, 2015). NASA Langley Research Center and SSAI/NASA Langley Research Center.
http://power.larc.nasa.gov/documents/Agroclimatology_Methodology.pdf
}

\examples{
\dontrun{
d <- wthPower(6, 56)
}
}

\author{ Robert J. Hijmans }

