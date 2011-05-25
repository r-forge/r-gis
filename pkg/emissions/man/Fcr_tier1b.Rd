\name{Fcr_tier1b}

\alias{Fcr_tier1b}

\title{
N From Crop Residues and Forage/Pasture Renewal (Tier 1)
}

\description{
This function computes N from crop residues and pasture renewals.  This function is very similar to the function Fcr_tier1a(); the input data is the same, the equation is slightly different.
IPCC equation 11.7
}

\usage{
Fcr_tier1b(p, ...)
}

\arguments{
  \item{p}{data.frame with the parameters associated with each manure management system (see \code{link{pars_NMMS}} for an example and further documentation}
  \item{...}{Additional variables (see Details)}
}

\details{
You can use the example input data structures (vars_Fcr and pars_Fcr) to enter input data for your region of interest.  Although the intial assumption of this function is that most input data will be relatively stable (and therefore contained as "constants"/parameters in p, with the exception crop yield (crop_kg_per_ha) and area harvested (TOTarea_ha) for each cropping system, which are set as variables by definition), you have the option to pass variable values to overwrite constant parameters through the (...) argument.  For example, if you have site or region-specifc data on the fraction of total area in a given crop that is renewed anually(frac_ren), you can set these data up as a vector (or matrix, such as vars_Fcr, if you have multiple variables that you need to reference) and pass it as an argument after p, which will overwrite the parameter data in p and use your variable data instead.  This approach of clearly distinguishing variables and parameters through the use of a parameters data.frame and a variables vector (which can substitute variables for parameters) allows for a high degree of scalability in the use of this function while minimizing the amount of data needed to perform the calcluations.  For example, suppose you want to estimate N from crop residues and forest/pasture renewals for all 50 US states and assume that only crop yield (crop_kg_per_ha) and area harvested (TOTarea_ha) vary by state.  With this function, you can hold all other quantities constant in the data.frame p, and then have two vectors of length 50 with crop yield and harvested for each state.  This avoids the problem of duplicating parameter values for each variable record, and is particularly important for spatial data applications (i.e. avoiding the need to create spatial data for parameters that don't vary spatially).

Note that variable names must be referenced according to their given names in the vars_Fcr and/or pars_Fcr examples when they are used in a call of Fcr_tier1a().  For example, crop yield must always be referenced as "crop_kg_per_ha", harvested area must always be referenced as "TOTarea_ha", and so on (see examples below).
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

\note{
No further notes
}

\seealso{
\code{\link{vars_Fcr}}
\code{\link{pars_Fcr}}
\code{\link{Fcr_tier1a}}
}

\examples{
data("vars_Fcr")
data("pars_Fcr")

#put in some numbers to avoind NaN with division
pars_Fcr[pars_Fcr == 0] = .5
vars_Fcr[vars_Fcr == 0] = 10

#Base case (only crop_kg_per_ha and TOTarea_ha vary):
Fcr_tier1a(pars_Fcr, crop_kg_per_ha = vars_Fcr["crop_kg_per_ha",], TOTarea_ha = vars_Fcr["TOTarea_ha",])

#Case with additional variables passed as vectors from the matrix vars_NMMS, which are substituted for the constant parameters in the calculation
Fcr_tier1a(pars_Fcr, crop_kg_per_ha = vars_Fcr["crop_kg_per_ha",], TOTarea_ha = vars_Fcr["TOTarea_ha",], frac_ren = vars_Fcr["frac_ren",], frac_remv = vars_Fcr["frac_remv",])

}
