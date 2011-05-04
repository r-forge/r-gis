\name{vars_NMMS}

\alias{vars_NMMS}

\title{
vars_NMMS
}

\description{
This example matrix contains space for input data on the variable (v) necessary for calculating the amount of managed manure N available for soil application, feed, fuel, or construction, which is simply the animal population (number of animals) in each manure management system.
}


\details{
Users may use this example matrix to enter the animal populations in each manure management system so that total available manure N may be calculated.  Users should take care to make sure that for any management system in the this matrix (v), there is a corresponding management system in the data frame of parameters (p).  Please also see help for "NMMS" and "pars_NMMS".
}

\arguments{
  \item{Nt}{the number of animals of type t in each manure management system}
}

\value{
numeric 
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
\code{\link{pars_NMMS}}
}

\examples{
data("vars_NMMS")
vars_NMMS
}
