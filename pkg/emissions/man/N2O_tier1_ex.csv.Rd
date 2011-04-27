\name{N2O_tier1_ex.csv}

\alias{N2O_tier1_ex.csv}

\title{
N2O_tier1_ex.csv
}

\description{
This table contains emission factors for N2O and other necessary data to be used as default emission factors with the function N2O_tier1()
}


\details{
\itemize{
  \item{land_use_or_practice}{identifies the land use or practice "causing" N2O emissions}
  \item{term_name}{gives the term name for the corresponding land use or practice as given in IPCC equation 11.1:
  
			Fsn: annual amount of synthetic fertiliser N applied to soils, kg N yr-1
			
			Fon: annual amount of animal manure, compost, sewage sludge and other organic N additions applied to soils (Note: If including sewage sludge, cross-check with Waste Sector to ensure there is no double counting of N2O emissions from the N in sewage sludge), kg N yr-1
			
			Fcr: annual amount of N in crop residues (above-ground and below-ground), including N-fixing crops, and from forage/pasture renewal, returned to soils, kg N yr-1
			Fsom: annual amount of N in mineral soils that is mineralised, in association with loss of soil C from soil organic matter as a result of changes to land use or management, kg N yr-1		
		}
	\item{area_ha}{gives the area of land in each land use, where applicable}
	\item{amount_kg}{gives the amount in kg of the N-input source, where applicable}
	\item{EF_name}{gives name of the emission factor associated with each N-source, as specified by IPCC table 11.1
			EF1: N2O emission factor for N-inputs: additions from mineral fertilisers, organic amendments and crop residues, and N mineralised from mineral soil as a result of loss of soil carbon [kg N2O-N (kgN)-1]
			EF1FR: additions from mineral fertilisers, organic amendments and crop residues, and N mineralised from mineral soil for flooder rice fields [kg N2O-N (kgN)-1]
			EF2CGtemp: N2O emission factor from drained/managed organic soils for temperate organic crop and grassland soils (kg N2O-N ha-1)
			EF2CGtrop: N2O emission factor from drained/managed organic soils for tropical organic crop and grassland soils (kg N2O-N ha-1)
			EF2FtempR: N2O emission factor from drained/managed organic soils for temperate and boreal organic nutrient rich forest soils (kg N2O-N ha-1)
			EF2FtempP: N2O emission factor from drained/managed organic soils for temperate and boreal organic nutrient poor forest soils (kg N2O-N ha-1)
			EF2Ftrop: N2O emission from drained/managed organic soils for tropical organic forest soils (kg N2O-N ha-1)
			EF3PRPCPP: N2O emission factor from urine and dung N deposited on pasture, range and paddock for cattle (dairy, non-dairy and buffalo), poultry and pigs
			EF3PRPSO: N2O emission factor from urine and dung N deposited on pasture, range and paddock for sheep and 'other animals' [kg N2O-N (kg N)-1]
		}
	\item{EF}{gives the value of each emission factor above, as specified by IPCC table 11.1}
	\item{EF_L}{gives the lower bound of uncertainty associated with the emission factor, as specified by IPCC table 11.1}
	\item{EF_H}{gives the upper bound of uncertainty associated with the emission factor, as specified by IPCC table 11.1}
	}
}

\value{
numeric value
}

\references{
IPCC, 2006:  \url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{N2O_tier1}}
}

\examples{
d <- read.csv(system.file("N2O_tier1_ex.csv", package="emissions"))
}
