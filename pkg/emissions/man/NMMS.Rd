 \name{NMMS}

\alias{NMMS}

\title{
Managed manure N
}

\description{
This function computes managed manure N available for application to managed soils, feed, fuel, or construction uses.
IPPC equation 10.34
}

\usage{
NMMS(p, ...)
}

\arguments{
  \item{p}{data.frame with the parameters associated with each manure management system (see \code{link{pars_NMMS}} for an example and further documentation}
  \item{...}{Additional variables (see Details)}  
}

\details{
You can use the example input data structures (vars_NMMS and pars_NMMS) to enter input data for your region of interest.  Although the intial assumption of this function is that most input data will be relatively stable (and therefore contained as "constants"/parameters in p, with the exception of the number of livestock, Nt, which is set as a variable by definition), you have the option to pass variable values to overwrite constant parameters through the (...) argument.  For example, if you have site or region-specifc data on the percentage of N lost in each animal-management system (FRAClossms_pct), you can set these data up as a vector (or matrix, such as vars_NMMS, if you have multiple variables that you need to reference) and pass it as an argument after p, which will overwrite the parameter data in p and use your variable data instead.  This approach of clearly distinguishing variables and parameters through the use of a parameters data.frame and a variables vector (which can substitute variables for parameters) allows for a high degree of scalability in the use of this function while minimizing the amount of data needed to perform the calcluations.  For example, suppose you want to estimate available manure N for all 50 US states and assume that only livestock population (Nt) varies by state.  With this function, you can hold all other quantities constant in the data.frame p, and then have a vector of length 50 with livestock population values for each state.  This avoids the problem of duplicating parameter values for each variable record, and is particularly important for spatial data applications (i.e. avoiding the need to create spatial data for parameters that don't vary spatially).

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
\code{\link{vars_NMMS}}
\code{\link{pars_NMMS}}
}

\examples{
data("vars_NMMS")
data("pars_NMMS")

#Base case (only Nt varies):
NMMS(pars_NMMS, Nt = vars_NMMS["Nt",])

#Case with additional variables passed as vectors from the matrix vars_NMMS, which are substituted for the constant parameters in the calculation
NMMS(pars_NMMS, Nt = vars_NMMS["Nt",], NEXt_kg = vars_NMMS["NEXt_kg",], FRAClossms_pct = vars_NMMS["FRAClossms_pct",]) 

}

