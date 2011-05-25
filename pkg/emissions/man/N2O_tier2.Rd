\name{N2O_tier2}

\alias{N2O_tier2}

\title{
Tier 2 N2O emissions
}

\description{
This function computes IPCC Tier 2 N2O emissions given two data frames: one for variables (areas and quantities) and one for emission factors. If upper and lower bound estimates of emission factors are provided, upper and lower bound estimates of emissions will be calculated.

IPCC equation 11.2
}

\usage{
N2O_tier2(v, p)
}

\arguments{
  \item{v}{a data.frame containing the the variables, in this case land areas and quantities of emitting substances (e.g. manure), see help file for vars_N2Otier2}
  \item{p}{a data frame containing the emission factors (and their high and low values) corresponding to the emission sources in v, see help file for vars_N2Otier2}
}

\details{
The tier 2 IPCC methodology for calculating N2O emissions is simply an extension of the tier 1 methodology.  In the tier 1 methodology, each emission source type has one and only one emission factor.  Tier 2 methodology assumes 
arbitrary levels of disaggregation for each source type.  For example, if temperate cropland/grassland is a major emission source for a country and spans a large area, this land use type may be dissagregated into different geographic regions, with a corresponding emission factors for each region.   As such, it is expected that you will have multiple emission source sub-categories (and corresponding emission factors), whereas if you used tier 1 methodology, your emission source categories would be fully aggregated (with one emission factor each).  This is reflected in the example data frames vars_N2Otier1 and EF_N2Otier1.  Please see the help files for each of these example data frames.
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

\note{
No further notes
}

\seealso{
\code{\link{vars_N2Otier2}}
\code{\link{EF_N2Otier2}}
\code{\link{N2O_tier1}}
\code{\link{vars_N2Otier1}}
\code{\link{EF_N2Otier1}}
}

\examples{
data("vars_N2Otier2")
data("EF_N2Otier2")
N2O_tier2(vars_N2Otier2, EF_N2Otier2)
}
