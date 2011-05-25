\name{vars_Fprp}

\alias{vars_Fprp}

\title{
vars_Fprp
}

\description{
This example matrix contains space for input data on the variable(s) that may be used for calculating the amount of urine and dung deposited by grazning animals on pasture, range, and paddock.
}

\arguments{
 \item{Nt}{the number of animals of type t in each manure management system (this is the only data that needs to be a variable, and thus appear here)}
 \item{NEXt_kg}{annual average N excretion per head of species/category t in the country (or region), kg N animal-1 yr-1 (see Chapter 10, Section 10.5)}
 \item{MStprp}{fraction of total annual N excretion for each livestock species/category t that is deposited on pasture, range and paddock (see Chapter 10, Section 10.5)}
}

\details{
The number of livestock in each manure management system is set as a variable by definition and thus should always appear as a vector in a matrix such as vars_Fprp (or be available as a stand-alone vector).  However, other data that appear as parameters in pars_Fprp may be passed as variables, and thus those data are included in this example matrix, vars_Fprp.
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
data("vars_Fprp")
vars_Fprp
}

