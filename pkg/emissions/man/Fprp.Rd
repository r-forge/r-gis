\name{Fprp_tier1}

\alias{Fprp_tier1}

\title{
N in Urine and Dung Deposited by Grazing Animals on Pasture, Range, and Paddock
}

\description{
This function computes the amount of Nitrogen from the urine and dung of grazing animals that is deposited on pasture, range, and paddock (kg N yr -1) 
}

\usage{
Fprp_tier1(v, p, na.rm = FALSE)
}

\arguments{
 \item{v}{a matrix similar to "vars_NMMS" containing the number of animals in each manure management system (see help for "vars_NMMS"}
 \item{p}{a data frame such as "pars_Fprp"(see help for "pars_Fprp"}
 \item{na.rm}{FALSE by default, ignores NA values when true}
}

\details{
Users may use the example data frames "vars_NMMS" and "pars_Fprp" to enter input data.  The only formatting rule with regard to the input data (required for the function to work) is that for any manure management system specifed in the matrix of variables, there must be a corresponding management system (with exactly the same name) in the data frame of parameters.  In other words, users should take care to make sure the column names in v match the row names in p in terms of number and name (although the order in which column/row names occurr in v and p does not matter.
}

\value{
numeric
}

\references{
IPCC 2006
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{pars_Fprp}}
\code{\link{vars_NMMS}}
}

\examples{
data("vars_NMMS")
data("pars_Fprp")
Fprp_tier1(vars_NMMS, pars_Fprp)
}

