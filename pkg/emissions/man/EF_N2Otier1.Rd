\name{EF_N2Otier1}

\alias{EF_N2Otier1}

\title{
EF_N2Otier1
}

\description{
This data frame contains default IPCC emission factors, including upper and lower uncertaintly bounds, for N2O to be used as default emission factors with the function N2O_tier1()
}


\details{
Emission factors correspond to either emitting land areas (e.g. temperate cropland/grassland) or quantities of emitting substances (e.g. animal manure).  Note that this data frame has three records, with the first record being the IPCC default emission factor, and the second and third records being the IPCC lower and upper uncertainty bounds for the emission factor respectively.  Definitions and units for each emission factor are given below. Also note that column headers are the same as those for in the data frame vars_N2Otier1, where each column denotes a specific emission source type.  It is a requirement that for any column header in EF_N2Otier1, there must be a matching column header in vars_N2Otier1
}


\arguments{

  \item{EF1Fsn}{N2O emission factor for synthetic N-inputs, non-rice[kg N2O-N (kgN)-1]}
  \item{EF1Fon}{N2O emission factor for organic N-inputs, non-rice [kg N2O-N (kgN)-1]}
  \item{EF1Fcr}{N2O emission factor for N-inputs from crop residues, non-rice[kg N2O-N (kgN)-1]}
  \item{EF1Fsom}{N2O emission factor for N in mineral soils that is mineralized, non-rice[kg N2O-N (kgN)-1]}
  \item{EF1FRFsn}{N2O emission factor for synthetic N-inputs,rice[kg N2O-N (kgN)-1]}
  \item{EF1FRFon}{N2O emission factor for organic N-inputs,rice [kg N2O-N (kgN)-1]}
  \item{EF1FRFcr}{N2O emission factor for N-inputs from crop residues, rice[kg N2O-N (kgN)-1]}
  \item{EF1FRFsom}{N2O emission factor for N in mineral soils that is mineralized, rice[kg N2O-N (kgN)-1]}
  \item{EF2CGtemp}{N2O emission factor for temperate cropland and grassland [kg N2O-N (kgN)-1]}
  \item{EF2CGtrop}{N2O emission factor for tropical cropland and grassland [kg N2O-N (kgN)-1]}
  \item{EF2FtempNP}{N2O emission factor for temperate nutrient-poor forest [kg N2O-N (kgN)-1]}
  \item{EF2Ftrop}{N2O emission factor for temperate nutrient-rich forest [kg N2O-N (kgN)-1]}
  \item{EF3PRPCPP}{N2O emission factor from urine and dung N deposited on pasture, range and paddock for cattle (dairy, non-dairy and buffalo), poultry and pigs [kg N2O-N (kg N)-1]}
  \item{EF3PRPSO}{N2O emission factor from urine and dung N deposited on pasture, range and paddock for sheep and 'other animals' [kg N2O-N (kg N)-1]}
} 

\value{
data frame
}

\references{
2006 IPCC Guidelines for National Greenhouse Gas Inventories, Volume 4 Agriculture, Forestry and Other Land Use  
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{N2O_tier1}}
\code{\link{vars_N2Otier1}}

}

\examples{
data("EF_N2Otier1")
EF_N2Otier1
}
