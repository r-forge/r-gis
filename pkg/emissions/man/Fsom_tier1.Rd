\name{Fsom_tier1}

\alias{Fsom_tier1}

\title{
N mineralised in mineral soils as a result of loss of soil C through change in land use or management practice.
}

\description{
This function computes mineralised N as a result of loss of soil C through change in land use or management practice.
IPPC Equation 11.8
}

\usage{
Fsom_tier1(Cmin, R)
}

\arguments{
  \item{Cmin}{data.frame with mineralized carbon}
  \item{R}{data.frame with C:N ratios of organic soils}  
}

\details{
You can use the example input data structures (vars_Fsom and pars_Fsom) to enter input data for your region of interest.  Although the intial assumption of this function is that the C:N ratio of soil organic matter(R) will be constant (and therefore contained as as a constant in the parameter data frame p, you have the option to pass R as a variable through the (...) argument.  For example, if you have site or region-specifc data on the C:N ration of soil organic matter(R), you can set these data up as a vector and pass it as an argument after p, which will overwrite any existing parameter data in p and use your variable data instead.  This approach of clearly distinguishing variables and parameters through the use of a parameters data.frame and a variables vector (which can substitute variables for parameters) allows for a high degree of scalability in the use of this function while minimizing the amount of data needed to perform the calcluations.  For example, suppose you want to estimate N mineralization for all 50 US states and assume that only livestock population (Nt) varies by state.  With this function, you can hold all other quantities constant in the data.frame p, and then have a vector of length 50 with livestock population values for each state.  This avoids the problem of duplicating parameter values for each variable record, and is particularly important for spatial data applications (i.e. avoiding the need to create spatial data for parameters that don't vary spatially).

Note that variable names must be referenced according to their given names in the vars_NMMS and/or pars_NMMS examples when they are used in a call of NMMS().  For example, the number of animals, must always be referenced as "Nt", the average annual N excretion per head must always be referenced as "NEXt_kg", and so on (see examples below).
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
\code{\link{deltaC_Fsom}}
\code{\link{R_Fsom}}
}

\examples{
data("deltaC_Fsom")
data("R_Fsom")
Fsom_tier1(deltaC_Fsom, R_Fsom)
}

