\name{genRain}

\alias{genRain}

\title{Generate 100 years of simulated rainfall}

\description{
Generate 100 years of simulated rainfall from the average monthly rainfall and the average number of rainy days.
}

\usage{
genRain(rain, rainydays) 
}

\arguments{
  \item{rain}{numeric vector of 12 monthly values} 
  \item{rainydays}{numeric vector of 12 monthly values} 
}

\value{
A matrix with 365 rows (days) and 100 columns (years)
}

\author{ Robert J. Hijmans }

\references{
Shu Geng, Frits W.T. Penning de Vries, Iwan Supit, 1986. A simple method for generating daily rainfall data, Agricultural and Forest Meteorology 36: 363-376. http://dx.doi.org/10.1016/0168-1923(86)90014-6.
}

\examples{
precip <- c(10, 20, 40, 60, 140, 110, 80, 40, 30, 25, 15, 5)
precdays <- round(sqrt(precip))
precdays

g <- genRain(precip, precdays)
g[1:15, 1:10]

# checking the outputs
m <- monthFromDate(daysOfYear(2001))
# average rainfall per month
round(rowMeans(aggregate(g, list(m), sum)))
# average number of wet days per month
round(rowMeans(aggregate(g>0, list(m), sum)))
}

