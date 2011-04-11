\name{N2O_tier1}

\alias{N2O_tier1}

\title{
Tier 1 N emission
}

\description{
This function computes IPCC Tier 1 N emission
}

\usage{
N2O_tier1(Fsn, Fon, Fcr, Fsom, FosCG, FosFNR, FosFNP, Fprp, EF, rice = FALSE)
}

\arguments{
  \item{Fsn}{ab}
  \item{Fon}{cd}
  \item{Fcr}{ef}
  \item{Fsom}{gh}
  \item{FosCG}{ddd}
  \item{FosFNR}{asd}
  \item{FosFNP}{asd}
  \item{Fprp}{asdf}
  \item{EF}{data.frame with xxxx. See Details}
  \item{rice}{logical. If \code{TRUE} then the crop is rice}
}

\details{
necessary details than the description above
}

\value{
numeric value
}

\references{
S. scientist, 1977, xxx
\url{http://google.com}
}


\author{
JP
}

\note{
No further notes
}

\seealso{
\code{\link{N2O_tier2}}
}

\examples{
ef <- data.frame(EF1=0.01, EF1FR = 0.003, EF2CGtemp=8, EF2CGtrop=16, EF2FtempR=0.6, EF2FtempP=0.1, EF2Ftrop=8, EF3PRPCRP=0.02, EF3PRPSO=0.01)
N2O_tier1(Fsn=1, Fon=2, Fsom=3, Fcr=5, EF=ef)

}

