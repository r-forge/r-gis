 \name{N2O_tier1}

\alias{N2O_tier1}

\title{
Tier 1 N2O emissions
}

\description{
This function computes IPCC Tier 1 N2O emissions given two data frames: one for variables (areas and quantities) and one for emission factors.  It also gives upper and lower bound emission estimates.
}

\usage{
N2O_tier1(v, p)
}

\arguments{
  \item{v}{a data frame containing the the variables, in this case land areas and quantities of emitting substances (e.g. manure), see help file for vars_N2Otier1}
  \item{p}{a data frame containing the emission factors (and their high and low values) corresponding to the emission sources in v, see help file for vars_N2Otier1}
}

\details{
Example data frames for v and p are provided with this package as vars_N2Otier1.RData and vars_N2Otier1.RData respectively.  Note that the only formatting rule for passing these data frames to the function is that the for any column header in v, there is an indentical (matching) column header in v.  Please see the additional help files referenced above for instructions on populating v and p.

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
\code{\link{vars_N2Otier1}}
\code{\link{EF_N2Otier1}}
}

\examples{
data("vars_N2Otier1")
data("EF_N2Otier1")
N2O_tier1(vars_N2Otier1, EF_N2Otier1)
}

