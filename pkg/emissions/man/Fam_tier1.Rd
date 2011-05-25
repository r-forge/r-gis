\name{Fam_tier1}

\alias{Fam_tier1}

\title{
N From Animal Manure Applied to Soils
}

\description{
This function computes the amount of total animal manure allocated to soil application (kg N yr -1) 
IPCC equation 11.4
}

\usage{
Fam_tier1(nmms, FracFEED, FracFUEL, FracCNST)
}

\arguments{
 \item{nmms}{amount of managed manure N available for soil application, feed, fuel, or construction (kg N yr-1).  This quantity can be computed using the function NMMS().}
 \item{FracFEED}{fraction of managed manure used for feed}
 \item{FracFUEL}{fraction of managed manure used for fuel}
 \item{FracCNST}{fraction of managed manure used for construction}
}

\details{
This function simply is simply takes the total available manure (nmms) and calculates the amount applied to soils by based on the levels of the other competing uses (feed, fuel, and construction.
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
\code{\link{vars_NMMS}}
\code{\link{pars_NMMS}}
}

\examples{
Fam_tier1(nmms = 100, FracFEED = .12, FracFUEL = .20, FracCNST = .07)
}

