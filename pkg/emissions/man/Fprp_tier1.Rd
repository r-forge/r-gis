\name{Fprp_tier1}

\alias{Fprp_tier1}

\title{
N in Urine and Dung Deposited by Grazing Animals on Pasture, Range, and Paddock
}

\description{
This function computes the amount of Nitrogen from the urine and dung of grazing animals that is deposited on pasture, range, and paddock (kg N yr-1) 
IPCC equation 11.5
}

\usage{
Fprp_tier1(p, ...)
}

\arguments{
  \item{p}{data.frame with the parameters associated with each manure management system (see \code{link{pars_Fprp}} for an example and further documentation}
  \item{...}{additional variables (see details)}
}

\details{
You can use the example input data structures (vars_Fprp and pars_Fprp) to enter input data for your region of interest.  Although the intial assumption of this function is that most input data will be relatively stable (and therefore contained as "constants"/parameters in p, with the exception of the number of livestock, Nt, which is set as a variable by definition), you have the option to pass variable values to overwrite constant parameters through the (...) argument.  For example, if you have site or region-specifc data on the average N excretion per animal(NEXt_kg), you can set these data up as a vector (or matrix, such as vars_NMMS, if you have multiple variables that you need to reference) and pass it as an argument after p, which will overwrite the parameter data in p and use your variable data instead.  This approach of clearly distinguishing variables and parameters through the use of a parameters data.frame and a variables vector (which can substitute variables for parameters) allows for a high degree of scalability in the use of this function while minimizing the amount of data needed to perform the calcluations.  For example, suppose you want to estimate urine and dung N deposited by grazing animals for all 50 US states and assume that only livestock population (Nt) varies by state.  With this function, you can hold all other quantities constant in the data.frame p, and then have a vector of length 50 with livestock population values for each state.  This avoids the problem of duplicating parameter values for each variable record, and is particularly important for spatial data applications (i.e. avoiding the need to create spatial data for parameters that don't vary spatially).

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
\code{\link{pars_Fprp}}
\code{\link{vars_Fprp}}
}

\examples{
data("vars_Fprp")
data("pars_Fprp")

#Base case (only Nt varies):
Fprp_tier1(pars_Fprp, Nt = vars_Fprp["Nt",])

#Case with additional variables passed as vectors from the matrix vars_NMMS, which are substituted for the constant parameters in the calculation
Fprp_tier1(pars_Fprp, Nt = vars_Fprp["Nt",], NEXt_kg = vars_Fprp["NEXt_kg",], MStprp = vars_Fprp["MStprp",]) 
}

