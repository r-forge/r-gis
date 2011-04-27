\name{Fcr_tier1a}

\alias{Fcr_tier1a}

\title{
N From Crop Residues and Forage/Pasture Renewal (Tier 1)
}

\description{
This function computes N from crop residues and pasture renewals given a dataframe containing the required input data
}

\usage{
Fcr_tier1a(x)
}

\arguments{
  \item{x}{a data frame containing the input data necessary to calculate N2O direct emissions based on the IPCC Tier 1 methodology (see details)}
}

\details{
An example of input data formatting is included in the system file "Fcr_tier1_ex.csv", which contains all the default data provided by table 11.2 of the IPCC guidance.  Columns that require input data from the user are filled with the value 5 or 0.5 (decimal indicates that the field has a fractional value).  User's may export this file as a .csv, edit it, and re-import it, or manipulate the file in R as a data frame object prior to passing it Fcr_tier1a().

Fcr_tier1a() is designed to handle an arbitrary number of records for a given data frame, x.  The only formatting restrictions for the data frame are:
	1) The column headers must be the same as those in "Fcr_ex.csv".
	2) For records where "Rbg" or "Nbg_kg" are not relevant quantities data cells must be filled with the value NA.
	3) Except for the column "crop_name", all cells must be of numeric class (i.e. not character/text).  Columns other than "Rbg" or "Nbg_kg" should contain 0 where appropriate, but not NA.
	
Please also see the help files for "Fcr_tier1_ex.csv".

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
\code{\link{Fcr_tier1a}}
}

\examples{
d <- read.csv(system.file("Fcr_tier1_ex.csv", package="emissions"))
N2O_tier2(d)
}
