 \name{N2O_tier1}

\alias{N2O_tier1}

\title{
Tier 1 N2O emissions
}

\description{
This function computes IPCC Tier 1 N emission given a data frame (table) of input data
}

\usage{
N2O_tier1(x)
}

\arguments{
  \item{x}{a data frame containing the input data necessary to calculate N2O direct emissions based on the IPCC Tier 1 methodology (see details)}
}

\details{
In order to prepare data for use (as a data frame) in this function, users should: 

	1) Make a copy of the file "N2O_tier1_ex.csv" provided with this package
	
	2) Adjust the data in columns "area_ha" and "amount_kg" to reflect the data for your region of interest (note that data cells to be adjusted by the user are given a default value of 5)
	
	3) You may adjust the emissions factors in column "EF" if you wish, but realize that the ones provided are those used by the IPCC for Tier1 N2O emissions estimation
	
	4) Save the file as a .csv file with any name, and then read it into R as a data frame using read.csv("filename.csv", header = TRUE)
	
Alternatively, users may simply load "N2O_tier1_ex.csv" as a data frame object and manipulate the data frame (i.e. change areas and amounts) within R.

Note that in tier 1 methodology, each emission factor corresponds to one or more emission source types (land use/practice), refelecting the highly generalized nature of the methodology.  In other words, each emission source type
has one and only one corresponding emission factor. Users should not attempt to disaggregate emissions sources with different emission factors using this function ( N2O_tier1() ); users should follow the data formatting/manipulation conventions specified above (i.e. do not change the dimensions or headernames of the table).  If users wish to further disaggregate emissions sources using more specific emissions factors, they should use the function for the tier 2 methodology ( N2O_tier2() ).

Please also see the help file for "N2O_tier1_ex.csv".

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

