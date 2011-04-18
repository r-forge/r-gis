\name{EF}

\alias{EF}

\title{
Emission factors for N2O, tier 1
}

\description{
Default emission factors for the function N2O_tier1(). This is table_11.1 in IPCC (2006)
}

\usage{
data(EF)
}

\details{
\itemize{
  \item{EF1}{N2O emission factor for N-inputs: additions from mineral fertilisers, organic amendments and crop residues, and N mineralised from mineral soil as a result of loss of soil carbon [kg N2O-N (kgN)-1]}
  \item{EF1FR}{N2O emission factor for N-inputs to flooded rice fields [kg N2O-N (kg N)-1]}
  \item{EF2CGtemp}{N2O emission factor from drained/managed organic soils for temperate organic crop and grassland soils (kg N2O-N ha-1)}
  \item{EF2CGtrop}{N2O emission factor from drained/managed organic soils for tropical organic crop and grassland soils (kg N2O-N ha-1)}
  \item{EF2FtempR}{N2O emission factor from drained/managed organic soils for temperate and boreal organic nutrient rich forest soils (kg N2O-N ha-1)}
  \item{EF2FtempP}{N2O emission factor from drained/managed organic soils for temperate and boreal organic nutrient poor forest soils (kg N2O-N ha-1)}
  \item{EF2Ftrop}{N2O emission from drained/managed organic soils for tropical organic forest soils (kg N2O-N ha-1)}
  \item{EF3PRPCPP}{N2O emission factor from urine and dung N deposited on pasture, range and paddock for cattle (dairy, non-dairy and buffalo), poultry and pigs}
  \item{EF3PRPSO}{N2O emission factor from urine and dung N deposited on pasture, range and paddock for sheep and 'other animals' [kg N2O-N (kg N)-1]}
}
}
\value{
N2O emmission (unit ??)
}

\references{
IPCC 2006
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman
}


\seealso{
\code{\link{N2O_tier1}}
}

\examples{
ef <- data.frame(EF1=0.01, EF1FR = 0.003, EF2CGtemp=8, EF2CGtrop=16, EF2FtempR=0.6, EF2FtempP=0.1, EF2Ftrop=8, EF3PRPCRP=0.02, EF3PRPSO=0.01)
N2O_tier2(Fsn=1, Fon=2, Fsom=3, Fcr=5, EF=ef)
}

