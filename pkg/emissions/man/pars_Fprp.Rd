\name{pars_Fprp}

\alias{pars_Fprp}

\title{
pars_Fprp
}

\description{
This data frame contains the parameters for each manure management system necessary to calculate the amount of N in urine and dung deposited by grazing animals on pasture, range, and paddock given a matrix containing the animal populations in each manure managment system).
}

\arguments{
 \item{NEXt_kg}{annual average N excretion per head of species/category t in the country (or region), kg N animal-1 yr-1 (see Chapter 10, Section 10.5)}
 \item{MStprp}{fraction of total annual N excretion for each livestock species/category t that is deposited on pasture, range and paddock (see Chapter 10, Section 10.5)}
}

\details{
You may use this example data frame to enter the given parameters for each system.  
}

\value{
numeric
}

\references{
2006 IPCC Guidelines for National Greenhouse Gas Inventories, Volume 4 Agriculture, Forestry and Other Land Use
\url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{pars_Fprp}}
\code{\link{vars_NMMS}}
}

\examples{
data("pars_Fprp")
pars_Fprp
}

