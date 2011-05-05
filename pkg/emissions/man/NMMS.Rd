 \name{NMMS}

\alias{NMMS}

\title{
Managed manure N
}

\description{
This function computes managed manure N available for application to managed soils, feed, fuel, or construction uses.
IPPC function xxx
}

\usage{
NMMS(Nt, p, na.rm = FALSE)
}

\arguments{
  \item{Nt}{matrix or data.frame with the number of animals in each manure management system. (see \code{\link{vars_NMMS}} for an example and further documentation}
  \item{p}{data.frame with the parameters associated with each manure management system (see \code{link{pars_NMMS}} for an example and further documentation}
  \item{na.rm}{FALSE by default.  If TRUE, NA values are ignored}
  \item{...}{Additional variables (see Details)}  
}

\details{
You can use the example input data structures (vars_NMMS and pars_NMMS) to enter input data for their region of interest.  The only formatting rule with regard to the input data (required for the function to work) is that for any manure management system specifed in the matrix of variables, there must be a corresponding management system (with exactly the same name) in the data frame of parameters.  In other words, users should take care to make sure the column names in v match the row names in p in terms of number and name (although the order in which column/row names occurr in Nt and p does not matter.

Explain that parameters can be passes as variable in the dots argument
}

\value{
numeric
}

\references{
IPCC, 2006
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

# changing a parameter to a variable
}

