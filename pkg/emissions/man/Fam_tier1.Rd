\name{Fam_tier1}

\alias{Fam_tier1}

\title{
N From Animal Manure Applied to Soils
}

\description{
This function computes the amount of total animal manure allocated to soil application (kg N yr -1) 
}

\usage{
Fam_tier1(v, p, FracFEED, FracFUEL, FracCNST)
}

\arguments{
 \item{v}{a matrix similar to vars_NMMS, see help for "vars_NMMS"}
 \item{p}{p matrix similar to pars_NMMS, see help for "pars_NMMS"}
 \item{FracFEED}{fraction of managed manure used for feed}
 \item{FracFUEL}{fraction of managed manure used for fuel}
 \item{FracCNST}{fraction of managed manure used for construction}
}

\details{
This function simply executes another built-in function NMMS using arguments v and p (see help for "NMMS") and adds the values of the other three arguments to result returned by NMMS.  Please also see help for "NMMS", "vars_NMMS", and "pars_NMMS"
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
\code{\link{NMMS}}
\code{\link{vars_NMMS}}
\code{\link{pars_NMMS}}
}

\examples{
data("vars_NMMS")
data("pars_NMMS")
Fam_tier1(v = vars_NMMS, p = pars_NMMS, FracFEED = .12, FracFUEL = .20, FracCNST = .07)
}

