  \name{N2O_tier1}

\alias{N2O_tier1}

\title{
Tier 1 N2O emissions
}

\description{
This function computes IPCC Tier 1 N emission
}

\usage{
N2O_tier1(Fsn, Fon, Fcr, Fsom, FosCG, FosFNR, FosFNP, Fprp, EF, rice = FALSE)
}

\arguments{
  \item{Fsn}{annual amount of synthetic fertiliser N applied to soils, kg N yr-1}
  \item{Fon}{annual amount of animal manure, compost, sewage sludge and other organic N additions applied to soils (Note: If including sewage sludge, cross-check with Waste Sector to ensure there is no double counting of N2O emissions from the N in sewage sludge), kg N yr-1}
  \item{Fcr}{annual amount of N in crop residues (above-ground and below-ground), including N-fixing crops, and from forage/pasture renewal, returned to soils, kg N yr-1}
  \item{Fsom}{annual amount of N in mineral soils that is mineralised, in association with loss of soil C from soil organic matter as a result of changes to land use or management, kg N yr-1}
  \item{FosCG}{annual area of managed/drained organic soils, ha, grassland and cropland}
  \item{FosFNR}{annual area of managed/drained organic soils, ha, nutrient-rich forest}
  \item{FosFNP}{annual area of managed/drained organic soils, ha, nutrient-poor forest}
  \item{Fprp}{annual amount of urine and dung N deposited by grazing animals on pasture, range and paddock, kg N yr-1}
  \item{EF}{data.frame with N2O emission factors. See Details in documentation for table_11.1.RData}
  \item{rice}{logical. If \code{TRUE} then the crop is rice}
}

\details{
necessary details than the description above
}

\value{
numeric value
}

\references{
IPCC 2006
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Robert Hijmans and Joshua Perlman
}

\note{
No further notes
}

\seealso{
\code{\link{N2O_tier2}}
}

\examples{
ef <- data.frame(EF1=0.01, EF1FR = 0.003, EF2CGtemp=8, EF2CGtrop=16, EF2FtempR=0.6, EF2FtempP=0.1, EF2Ftrop=8, EF3PRPCRP=0.02, EF3PRPSO=0.01)
N2O_tier1(Fsn=1, Fon=2, Fsom=3, Fcr=5, EF=ef)

}

