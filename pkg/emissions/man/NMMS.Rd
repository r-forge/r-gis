 \name{NMMS}

\alias{NMMS}

\title{
Managed manure N
}

\description{
This function computes managed manure N available for application to managed soils, feed, fuel, or construction uses.
}

\usage{
NMMS(v, p, na.rm = FALSE)
}

\arguments{
  \item{v}{a matrix or data frame with the variable, in this case, the number of animals in each manure management system (see help for "vars_NMMS" for example and further documentation}
  \item{p}{a data frame with the parameters associate with each manure management system (see help for "pars_NMMS" for example and further documentation}
  \item{na.rm}{FALSE by defualt.  If TRUE, NA values are ignored}
}

\details{
Users may use the example input data structures (vars_NMMS and pars_NMMS) to enter input data for their region of interest.  The only formatting rule with regard to the input data (required for the function to work) is that for any manure management system specifed in the matrix of variables, there must be a corresponding management system (with exactly the same name) in the data frame of parameters.  In other words, users should take care to make sure the column names in v match the row names in p in terms of number and name (although the order in which column/row names occurr in v and p does not matter.
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
\code{\link{vars_NMMS}}
\code{\link{pars_NMMS}}
}

\examples{
data("vars_NMMS")
data("pars_NMMS")
NMMS(vars_NMMS, pars_NMMS)
}

