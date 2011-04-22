 \name{Fon_tier1}

\alias{Fon_tier1}

\title{
Nitrogen inputs from organic N additions
}

\description{
This function computes Nitrogen input from organic N additions applied to souls (excluding "natural" applications by grazing animals) (kg N yr -1) 
}

\usage{
Fon_tier1(Fam, Fsew, Fcomp, Fooa)
}

\arguments{
 \item{Fam}{annual amount of animal manure N applied to soils, kg N yr -1}
 \item{Fsew}{annual amount of total sewage N (coordinate with Waste Sector to ensure that sewage N is not double-counted) that is applied to soils, kg N yr -1}
 \item{Fcomp}{annual amount of total compost N applied to soils (ensure that manure N in compost is not double-counted), kg N yr -1}
 \item{Fooa}{ annual amount of other organic amendments used as fertiliser (e.g., rendering waste, guano, brewery waste, etc.), kg N yr -1}
}

\details{
This function simply sums the four inputs.
}

\value{
The sum of the inputs (integer or numeric)
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
Fon_tier1(Fam = 4, Fsew = 4, Fcomp = 4, Fooa = 10)
}

