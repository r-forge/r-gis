\name{vars_N2Otier1}

\alias{vars_N2Otier1}

\title{
vars_N2Otier1
}

\description{
This data frame requires the user to input data on land area and/or amounts of emitting substances.  In other words, this data frame contains quantities of emission sources.  
}


\details{
Note that column headers are the same as those for in the data frame EF_N2Otier1, where each column denotes a specific emission source type.  It is a requirement that for any column header in vars_N2Otier1, there must be a matching column header in EF_N2Otier1
}

\arguments{

  \item{EF1Fsn}{annual amount of synthetic fertiliser N applied to soils, non-rice [kg N yr-1]}
  \item{EF1Fon}{annual amount of animal manure, compost, sewage sludge and other organic N additions applied to soils (Note: If including sewage sludge, cross-check with Waste Sector to ensure there is no double counting of N2O emissions from the N in sewage sludge), non-rice [kg N yr-1]}
  \item{EF1Fcr}{annual amount of N in crop residues (above-ground and below-ground), including N-fixing crops, and from forage/pasture renewal, returned to soils, non-rice [kg N yr-1]}
  \item{EF1Fsom}{annual amount of N in mineral soils that is mineralised, in association with loss of soil C from soil organic matter as a result of changes to land use or management, non-rice[kg N yr-1]}
  \item{EF1FRFsn}{annual amount of synthetic fertiliser N applied to soils, rice [kg N yr-1]}
  \item{EF1FRFon}{annual amount of animal manure, compost, sewage sludge and other organic N additions applied to soils (Note: If including sewage sludge, cross-check with Waste Sector to ensure there is no double counting of N2O emissions from the N in sewage sludge), rice [kg N yr-1]}
  \item{EF1FRFcr}{annual amount of N in crop residues (above-ground and below-ground), including N-fixing crops, and from forage/pasture renewal, returned to soils, rice [kg N yr-1]}
  \item{EF1FRFsom}{annual amount of N in mineral soils that is mineralised, in association with loss of soil C from soil organic matter as a result of changes to land use or management, rice[kg N yr-1]}
  \item{EF2CGtemp}{area in temperate cropland and grassland [ha]}
  \item{EF2CGtrop}{area in tropical cropland and grassland [ha]}
  \item{EF2FtempNP}{area in temperate nutrient-poor forest [ha]}
  \item{EF2Ftrop}{area in temperate nutrient-rich forest [ha]}
  \item{EF3PRPCPP}{amount of urine and dung N deposited on pasture, range and paddock for cattle (dairy, non-dairy and buffalo), poultry and pigs [kg]}
  \item{EF3PRPSO}{amount of urine and dung N deposited on pasture, range and paddock for sheep and 'other animals' [kg]}
}

\value{
data frame
}

\references{
IPCC, 2006:  \url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{N2O_tier1}}
\code{\link{EF_N2Otier2}}
}

\examples{
data("vars_N2Otier1")
vars_N2Otier1
}
