\name{vars_N2Otier2}

\alias{vars_N2Otier2}

\title{
vars_N2Otier2
}

\description{
This data frame requires the user to input data on land area and/or amounts of emitting substances.  In other words, this data frame contains quantities of emission sources, dissagregated to the user's desired level.  
}


\details{
This data frame is nearly identical to vars_N2Otier1, except that it is expected that the user will want to enter data representing a greater level of disaggregation of sources compared to the tier1 methodology.  As such, users will notice that this example data frame has the same column headers (emission source types) as vars_N2Otier1, except each type is repeated with an 'A' and a 'B', representing one level of disaggregation.  Users may wish to disaggregate their sources to arbitrary levels, and therefore should modify this data frame (and EF_N2Otier1) accordingly. As with the tier 1 functions, it is a requirement that for any column header in vars_N2Otier2, there must be a matching column header in EF_N2Otier2.  For details on the specific meaning of input data (column headers) in this table, please refer to the help file for vars_N2Otier1.
}

\arguments{
}

\value{
data frame
}

\references{
IPCC, 2006:  \url{http://www.ipcc-nggip.iges.or.jp/public/2006gl/index.html}
}


\author{
Joshua Perlman and Robert Hijmans
}


\seealso{
\code{\link{N2O_tier2}}
\code{\link{EF_N2Otier2}}
\code{\link{N2O_tier1}}
\code{\link{EF_N2Otier1}}
\code{\link{vars_N2Otier1}}
}

\examples{
data("vars_N2Otier2")
vars_N2Otier2
}
