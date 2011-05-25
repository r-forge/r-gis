\name{pars_NMMS}

\alias{pars_NMMS}

\title{
pars_NMMS
}

\description{
This data frame contains the parameters for each manure management system necessary to calculate the amount of managed manure N available for soil application, feed, fuel, or construction (given a matrix containing the animal populations in each manure managment system)
}


\details{
You may use this example data frame to enter the given parameters for each system.  Where IPPC default values are available, they are provided in this example data frame.  Where values require input, 0 is provided as the default.  
}

\arguments{
  \item{NEXt_kg:}{annual average N excretion per animal of species/category T in the country, kg N animal -1  yr -1}
  \item{FRAClossms_pct:}{the percentage of N lost in each animal-management system}
  \item{MSts:}{fraction of total annual nitrogen excretion for each livestock species/category T that is managed in manure management system S in the country, dimensionless}
  \item{Nbeddingms_kg:}{amount of nitrogen from bedding (to be applied for solid storage and deep bedding MMS if known organic bedding usage), kg N animal -1  yr -1}
}


\value{
numeric value
}

\references{
2006 IPCC Guidelines for National Greenhouse Gas Inventories, Volume 4 Agriculture, Forestry and Other Land Use  
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{NMMS}}
\code{\link{vars_NMMS}}
}

\examples{
data("pars_NMMS")
pars_NMMS
}
