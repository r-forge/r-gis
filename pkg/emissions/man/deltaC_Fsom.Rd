\name{deltaC_Fsom}

\alias{deltaC_Fsom}

\docType{data}

\title{
deltaC_Fsom
}

\description{
This data.frame contains space for average loss of soil carbon for each land use change. This is equation 11.8 in IPPC (2006)
}

\usage{
data(deltaC_Fsom)
}



\details{
You can use the example input data structure to enter data on average loss of soil carbon for different land use changes in different regions. Column headers (i.e., land use change designations) must match those for the for the corresponding data.frame passed to the function, such as \code{\link{R_Fsom}}.
}


\references{
IPCC, 2006. Guidelines for National Greenhouse Gas Inventories, Volume 4, Agriculture, Forestry and Other Land Use.

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

