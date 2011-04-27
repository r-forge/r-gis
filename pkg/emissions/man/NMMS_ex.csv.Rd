\name{NMMS_ex.csv}

\alias{NMMS_ex.csv}

\title{
NMMS_ex.csv
}

\description{
This table contains the input data necessary to calculate
}


\details{
\itemize{
  \item{animal_category:}{the type of animal}
  \item{MM_system:}{the manure management system corresponding to each animal type}	
  \item{FRAClossms_pct:}{the percentage of N lost in each animal-management system}
  \item{FRAClossms_pct__L:}{lower-bound uncertainty estimate of the percentage of N lost in each animal-management system}
  \item{FRAClossms_pct_H:}{upper-bound uncertainty estimate the percentage of N lost in each animal-management system}
  \item{Nt:}{number of head of livestock species/category t in the country }
  \item{NEXt_kg:}{annual average N excretion per animal of species/category T in the country, kg N animal -1  yr -1}
  \item{MSts:}{fraction of total annual nitrogen excretion for each livestock species/category T that is managed in manure management system S in the country, dimensionless}
  \item{MStprp:}{fraction of total annual N excretion for each livestock species/category T that is deposited on pasture, range, and paddock}
  \item{Nbeddingms_kg:}{amount of nitrogen from bedding (to be applied for solid storage and deep bedding MMS if known organic bedding usage), kg N animal -1  yr -1}
	}
}

\value{
numeric value
}

\references{
IPCC, 2006:  
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{NMMS}}
}

\examples{
d <- read.csv(system.file("NMMS_ex.csv", package="emissions"))
}
