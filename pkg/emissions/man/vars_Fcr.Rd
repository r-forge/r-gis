\name{vars_Fcr}

\alias{vars_Fcr}

\title{
vars_Fcr
}

\description{
This example matrix contains space for input data on the variable(s) that may be used for calculating N from crop residues and forage/pasture renewal.
}


\details{
The crop yield and total harvested area are set as variables by definition and thus should always appear as vectors in a matrix such as vars_Fcr (or be available as a stand-alone vectors).  However, other data that appear as parameters in pars_Fcr may be passed as variables, and thus those data are included in this example matrix, vars_Fcr.

}
\arguments{
  \item{crop_name:}{identifies the the crop of interest}
  \item{crop_kg_per_ha:}{user input of crop yield per hectare for the given crop kg/ha}
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
  \item{Rbg:}{ratio of below-ground residues to harvested yield for crop T, kg d.m. (kg d.m.) -1 . If alternative data are not available, R BG(T)  may be calculated by multiplying R BG-BIO  in Table 11.2 (given as Rbg in this matrix) by the ratio of total above-ground biomass to crop yield ( = [(AG DM(T) * 1000 + Crop (T) ) / Crop (T) ],   (also calculating AG DM(T)  from the information in Table 11.2).}
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
\code{\link{pars_Fcr}}
\code{\link{Fcr_tier1a}}
\code{\link{Fcr_tier1b}}
}

\examples{
data("vars_Fcr")
vars_Fcr
}
