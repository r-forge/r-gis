\name{vars_NMMS}

\alias{vars_NMMS}

\title{
vars_NMMS
}

\description{
This example matrix contains space for input data on the variable(s) that may be used for calculating the amount of managed manure N available for soil application, feed, fuel, or construction.
}


\details{
The number of livestock in each manure management system is set as a variable by definition and thus should always appear as a vector in a matrix such as vars_NMMS (or be available as a stand-alone vector).  However, other data that appear as parameters in pars_NMMS may be passed as variables, and thus those data are included in this example matrix, vars_NMMS.
}

\arguments{
  \item{Nt}{the number of animals of type t in each manure management system (this is the only data that needs to be a variable, and thus appear here)}
  \item{FRAClossms_pct:}{the percentage of N lost in each animal-management system (may be a variable if data are available), but is included as a parameter in pars_NMMS)}
  \item{MSts:}{fraction of total annual nitrogen excretion for each livestock species/category T that is managed in manure management system S in the country, dimensionless (may be a variable if data are available), but is included as a parameter in pars_NMMS)}
  \item{Nbeddingms_kg:}{amount of nitrogen from bedding (to be applied for solid storage and deep bedding MMS if known organic bedding usage), kg N animal -1  yr -1 (may be a variable if data are available), but is included as a parameter in pars_NMMS)}
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
\code{\link{NMMS}}
\code{\link{pars_NMMS}}
}

\examples{
data("vars_NMMS")
vars_NMMS
}
