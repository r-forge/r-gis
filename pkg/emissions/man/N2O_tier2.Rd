\name{N2O_tier2}

\alias{N2O_tier2}

\title{
Tier 2 N2O emissions
}

\description{
This function computes N2O emissions according to the Tier 2 IPCC methodology
}

\usage{
N2O_tier2(x)
}

\arguments{
  \item{x}{a data frame containing the input data necessary to calculate N2O direct emissions based on the IPCC Tier 1 methodology (see details)}
}

\details{
The tier 2 IPCC methodology for calculating N2O emissions is simply an extension of the tier 1 methodology.  In the tier 1 methodology, each emission source type had one and only one emission factor.  Tier 2 methodology allows for
arbitrary levels of disaggregation for each source type.  In other words, any given source type may be split into pieces (i.e. different conditions under which emissions occur) and each peice may be assigned a unique emission factor.  This is exemplified in the example table "N2O_tier2_ex.csv".  Note that in this example, the emission sources "synthetic N inputs" and "organic N inputs" (for non-rice and rice crops) are disaggregated, leaving room for three different emission factors for each of these sources under different conditions (in the column "EF_name", you will see that "i" is used to denote different emission factors corresponding to condition "i").  Although in this example, only two source types are disaggregated, any sources may be disaggregated to any degree if more precise information regarding emission factors under different conditions is available.

As such, the function N2O_tier2() is designed to handle an arbitrary number of records for a given data frame, x.  The only formatting restrictions for the data frame are:
	1) The column headers must be the same as those in "N2O_tier2_ex.csv".
	2) For records where "area_ha" or "amount_kg" are not relevant quantities (ex: area for synthetic N-inputs or amount for tropical forest), data cells must be filled with the value NA.
	3) All non-NA cells in the columns "area_ha" and "amount_kg" must be of numeric class (i.e. not character/text)
	
Please also see the help files for "N2O_tier2_ex.csv" and the N2O_tier1().

}

\value{
numeric value
}

\references{
IPCC 2006
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}

\note{
No further notes
}

\seealso{
\code{\link{N2O_tier1}}
}

\examples{
d <- read.csv(system.file("N2O_tier2_ex.csv", package="emissions"))
N2O_tier2(d)
}
