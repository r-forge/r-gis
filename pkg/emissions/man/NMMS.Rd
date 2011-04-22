 \name{NMMS}

\alias{NMMS}

\title{
Managed manure N
}

\description{
This function computes managed manure N available for application to managed soils, feed, fuel, or construction uses, given a table of input data.
}

\usage{
NMMS(x)
}

\arguments{
  \item{x}{a data frame containing the input data necessary to calculate total managed manure N available for the applications above (see details)}
}

\details{
In order to prepare data for use (as a data frame) in this function, users should: 

	1) Make a copy of the file "NMMS_ex.csv" provided with this package
	
	2) Adjust the data in columns "Nt", "NEXt_kg", "MSts", and "Nbeddingms_kg" to reflect the data in your region of interest (note the default values in the cells to be adjusted are 5, except for "MSts", where the are .5 to indicate that the data in this field should be a fraction.
	
	3) Save the file as a .csv file with any name, and then read it into R as a data frame using read.csv("filename.csv", header = TRUE)
	
Alternatively, users may simply load "NMMS_ex.csv" as a data frame object and manipulate the data frame (i.e. values in columns specified above) within R.

This function is written to handle an arbitrary number of records in the given data frame, x.  Therefore, the user may add or further specify management systems using "NMMS_ex.csv" as a template.   The only formatting rules are:
	1) The names of column headers must match those in "NMMS_ex.csv"
	2) Columns "FRAClossms_pct", "FRAClossms_pct__L", "FRAClossms_pct_H", "Nt, "NEXt_kg", MSts", "Nbeddingms_kg" must all contain numeric data (no characters/strings).  
	3) If a given manure management system is not present or applicable in the region of interest, simply put 0 in the corresponding data columns ("Nt, "NEXt_kg", MSts", "Nbeddingms_kg")

Please also see the help file for "NMMS_ex.csv".

}

\value{
returns data of numeric type
}

\references{
IPCC 2006
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{NMMS}}
}

\examples{
}

