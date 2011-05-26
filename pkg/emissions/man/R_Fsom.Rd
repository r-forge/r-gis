\name{R_Fsom}

\alias{R_Fsom}

\docType{data}

\title{
R_Fsom
}

\description{
This data.frame contains space for the C:N ratios of organic soils.  IPCC defaults (as described below) are provided.
IPPC Equation 11.8
}

\usage{
data(R_Fsom)
}

\details{
C:N ratio of the soil organic matter. A default value of 15 (uncertainty range from 10 to 30) for the C:N ratio (R) may be used for involving land-use change from Forest Land or Grassland to Cropland, in the absence of more specific data for the area. A default value of 10 (range from 8 to 15) may be used for situations involving management changes on Cropland Remaining Cropland. C:N  ratio  can  change  over  time,  land use,  or  management  practice  17 .  If  countries  can  document changes in C:N ratio, then different values can be used over the time series,land use, or management practice. 

You can use the example input data structure to enter data on C:N ratios for soil organic matter for different land use changes in different regions.  Column headers (i.e. land use change designations) must match those for the for the corresponding data.frame passed to the function, such as \code{\link{deltaC_Fsom}}.
}

\value{
numeric
}

\references{
2006 IPCC Guidelines for National Greenhouse Gas Inventories, Volume 4 Agriculture, Forestry and Other Land Use
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{Fsom_tier1}}
\code{\link{deltaC_Fsom}}
}

\examples{
data(R_Fsom)
R_Fsom
}

