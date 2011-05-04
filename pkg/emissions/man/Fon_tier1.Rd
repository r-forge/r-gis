\name{Fon_tier1}

\alias{Fon_tier1}

\title{
Nitrogen inputs from organic N additions
}

\description{
This function computes Nitrogen input from organic N additions applied to souls (excluding "natural" applications by grazing animals) (kg N yr -1) 
}

\usage{
Fon_tier1(v, p, FracFEED, FracFUEL, FracCNST, Fsew, Fcomp, Fooa)
}

\arguments{
 \item{v}{a matrix similar to vars_NMMS, see help for "vars_NMMS"}
 \item{p}{p matrix similar to pars_NMMS, see help for "pars_NMMS"}
 \item{FracFEED}{fraction of managed manure used for feed}
 \item{FracFUEL}{fraction of managed manure used for fuel}
 \item{FracCNST}{fraction of managed manure used for construction}
 \item{Fsew}{annual amount of total sewage N (coordinate with Waste Sector to ensure that sewage N is not double-counted) that is applied to soils, kg N yr -1}
 \item{Fcomp}{annual amount of total compost N applied to soils (ensure that manure N in compost is not double-counted), kg N yr -1}
 \item{Fooa}{ annual amount of other organic amendments used as fertiliser (e.g., rendering waste, guano, brewery waste, etc.), kg N yr -1}
}

\details{
This function simply calls another built in function, Fam, using  the arguments v, p, FracFEED, FracFUEL, FracCNST, and adds the values of the remaining arguments to the value returned by Fam_tier1.  Please also see help for Fam_tier1, NMMS, vars_NMMS, and pars_NMMS
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
\code{\link{N2O_tier1}}
}

\examples{
data("vars_NMMS")
data("pars_NMMS")
Fon_tier1(v = vars_NMMS, p = pars_NMMS, FracFEED = .12, FracFUEL = .20, FracCNST = .07, Fsew = 4, Fcomp = 4, Fooa = 10)
}

