\name{deltaC_Fsom}

\alias{deltaC_Fsom}

\docType{data}

\title{
deltaC_Fsom
}

\description{
This data.frame contains space for average loss of soil carbon for each land use change.
IPPC Equation 11.8
}

\usage{
data(deltaC_Fsom)
}



\details{
R is the average annual loss of soil carbon for each land-use type (LU), tonnes C (Note: for Tier 1, deltaC mineral, LU  will have a single value for all land-uses and management systems. Using Tier 2 the value for deltaC mineral, LU will be disaggregated by individual land-use and/or management systems.

You can use the example input data structure to enter data on average loss of soil carbon for different land use changes in different regions. Column headers (i.e., land use change designations) must match those for the for the corresponding data.frame passed to the function, such as \code{\link{R_Fsom}}.
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
\code{\link{R_Fsom}}
}

\examples{
data(deltaC_Fsom)
deltaC_Fsom
}

