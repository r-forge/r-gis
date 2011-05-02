\name{EF_N2Otier2}

\alias{EF_N2Otier2}

\title{
EF_N2Otier2
}

\description{
This data frame contains space for users to input emission factors for source types that are more disaggregated than those in EF_N2Otier1.  A data frame of this general form gets passed as the second argument (p) to the function N2O_tier2.
}


\details{
This data frame is nearly identical to EF_N2Otier1, except that it is expected that the user will want to enter more emission factors corresponding to the greater level of disaggregation of sources.  As such, users will notice that this example data frame has the same column headers (emission source types) as EF_N2Otier1, except each type is repeated with an 'A' and a 'B', representing one level of disaggregation.  Users may wish to disaggregate their sources to arbitrary levels, and therefore should modify this data frame (and vars_N2Otier1) accordingly. As with the tier 1 functions, it is a requirement that for any column header in EF_N2Otier2, there must be a matching column header in vars_N2Otier2.  For details on the specific meaning of emission factors (column headers) in this table, please refer to the help file for EF_N2Otier1.
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
\code{\link{vars_N2Otier2}}
\code{\link{N2O_tier1}}
\code{\link{EF_N2Otier1}}
\code{\link{vars_N2Otier1}}
}

\examples{
data("EF_N2Otier2")
EF_N2Otier2
}
