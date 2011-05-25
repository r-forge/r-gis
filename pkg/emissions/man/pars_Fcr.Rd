\name{pars_Fcr}

\alias{pars_Fcr}

\title{
pars_Fcr
}

\description{
This data frame contains the parameters for each cropping system necessary to calculate N from crop residues and forage/pasture renewal(given a matrix or vectors containing crop yield and harvested area for each cropping system
}


\details{
You may use this example data frame to enter the given parameters for each cropping system.  Where IPPC default values are available, they are provided in this example data frame.  Where values require input, 0 is provided as the default.  
}

\arguments{
  \item{dry_frac:}{dry matter fraction of harvested product; i.e. the discounting factor for weight at time of harvest to weight when full dried}
  \item{slope:}{slope of the regression line relating above-ground residue dry matter to harvested dry matter yield for the given crop}
  \item{slope_2SDpctMEAN:}{shows the percentage (+/-) of the mean represented by 2SD of the slope}
  \item{intercept:}{intercept of the regression line relating above-ground residue dry matter to harvested dry matter yield for the given crop}
  \item{intercept_2SDpctMEAN:}{shows the percentage (+/-) of the mean represented by 2SD of the intercept}
  \item{R2_adj:}{the adjusted R-squared value for the regression of residue dry matter on harvested dry matter yield for the given crop}
  \item{TOTarea_ha:}{total annual area harvested of crop T, ha yr -1}
  \item{BURNTarea_ha:}{annual area of crop T burnt, ha yr -1}
  \item{Cf:}{combustion factor (dimensionless) (refer to Chapter 2, Table 2.6)}
  \item{frac_ren:}{fraction of total area under crop T that is renewed annually  15 . For countries where pastures are renewed on average every X years, Frac Renew  = 1/X. For annual crops Frac Renew  = 1}
  \item{Nag_kg:}{N content of above-ground residues for crop T, kg N (kg d.m.) -1 ,(Table 11.2)}
  \item{frac_remv:}{fraction of above-ground residues of crop T removed annually for purposes such as feed, bedding and construction, kg N (kg crop-N) -1 . Survey of experts in country is required to obtain data. If data for Frac Remove  are not available, assume no removal.}
  \item{Rbg:}{ratio of below-ground residues to harvested yield for crop T, kg d.m. (kg d.m.) -1 . If alternative data are not available, R BG(T)  may be calculated by multiplying R BG-BIO  in Table 11.2 (given as Rbg in this data.frame) by the ratio of total above-ground biomass to crop yield ( = [(AG DM(T) * 1000 + Crop (T) ) / Crop (T) ],   (also calculating AG DM(T)  from the information in Table 11.2).}
  \item{Rbg_error_pct:}{ratio of below-ground residues to harvested yield for crop T, kg d.m. (kg d.m.) -1 . If alternative data are not available, R BG(T)  may be calculated by multiplying R BG-BIO  in Table 11.2 by the ratio of total above-ground biomass to crop yield ( = [(AG DM(T)  * 1000 + Crop (T) ) / Crop (T) ],   (also calculating AG DM(T)  from the information in Table 11.2).}
  \item{Nbg_kg:}{N content of below-ground residues for crop T, kg N (kg d.m.) -1 , (Table 11.2)}
 
}


\value{
numeric value
}

\references{
2006 IPCC Guidelines for National Greenhouse Gas Inventories, Volume 4 Agriculture, Forestry and Other Land Use
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{vars_Fcr}}
\code{\link{Fcr_tier1a}}
\code{\link{Fcr_tier1b}}
}

\examples{
data("pars_Fcr")
pars_Fcr
}
