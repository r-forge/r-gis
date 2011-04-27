 \name{Fam_tier1}

\alias{Fam_tier1}

\title{
N From Animal Manure Applied to Soils
}

\description{
This function computes the amount of total animal manure allocated to soil application (kg N yr -1) 
}

\usage{
Fam_tier1(x, FracFEED, FracFUEL, FracCNST)
}

\arguments{
 \item{x}{a data frame, formatted according to "NMMS_ex.csv", containing the activity data necessary to compute total available manure.  See help for "NMMS()" and "NMMS_ex.csv"}
 \item{FracFEED}{fraction of managed manure used for feed}
 \item{FracFUEL}{fraction of managed manure used for fuel}
 \item{FracCNST}{fraction of managed manure used for construction}
}

\details{
This function takes the data frame x, uses another built-in function, NMMS(), to compute total available manure using x, and then uses the other input parameters (fractions) to allocated manure to the different uses.
}

\value{
numeric
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
\code{\link{NMMS_ex.csv}}
}

\examples{
data <- read.csv(system.file("NMMS_ex.csv", package = "emissions"))
Fam_tier1(x = data, FracFEED = .12, FracFUEL = .20, FracCNST = .07)
}

