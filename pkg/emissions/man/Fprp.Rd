 \name{Fprp_tier1}

\alias{Fprp_tier1}

\title{
N in Urine and Dung Deposited by Grazing Animals on Pasture, Range, and Paddock
}

\description{
This function computes the amount of Nitrogen from the urine and dung of grazing animals that is deposited on pasture, range, and paddock (kg N yr -1) 
}

\usage{
Fprp_tier1(x)
}

\arguments{
 \item{x}{a data frame, formatted according to "NMMS_ex.csv", containing the nessary input data.  See help for "NMMS_ex.csv"}
}

\details{
This function takes the data frame x and extracts from it the necessary data to compute total N from urine and dung deposition from grazing animals on pasture, range, and paddock.
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
\code{\link{NMMS_ex.csv}}
}

\examples{
data <- read.csv(system.file("NMMS_ex.csv", package = "emissions"))
Fprp_tier1(x = data)
}

