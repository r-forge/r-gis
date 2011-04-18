 \name{N2O_tier1}

\alias{N2O_tier1}

\title{
Tier 1 N2O emissions
}

\description{
This function computes IPCC Tier 1 N emission given a data frame (table) of input data
}

\usage{
N2O_tier1(T1_data)
}

\arguments{
  \item{T1_data}{a data frame containing the input data necessary to calculate N2O direct emissions based on the IPCC Tier 1 methodology (see details)}
}

\details{
In order to prepare data for use (as a data frame) in this function, users should: 
	1) Make a copy of the file "N2O_tier1_ex.csv" provided with this package
	
	2) Adjust the data in columns "area_ha" and "amount_kg" to reflect the data for your region of interest (note that data cells to be adjusted by the user are given a default value of 5)
	
	3) You may adjust the emissions factors in column "EF" if you wish, but realize that the ones provided are those used by the IPCC for Tier1 N2O emissions estimation
	
	4) Save the file with any name, and then read it into R as a data frame using read.csv("file.csv", header = TRUE)
}

\value{
data frame
}

\references{
IPCC 2006
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{N2O_tier2}}
}

\examples{
# to be done
}

