\name{getplantdates}
\alias{getplantdates}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
getplantdates(yields, fact = 2)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{yields}{ ~~Describe \code{yields} here~~ }
  \item{fact}{ ~~Describe \code{fact} here~~ }
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ~Describe the value returned
  If it is a LIST, use
  \item{comp1 }{Description of 'comp1'}
  \item{comp2 }{Description of 'comp2'}
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function(yields, fact=2) {
yp <- 10000
yt <- 0.5
yields[is.na(yields)] <- 0
if (sum(yields) == 0) {
return(yields)
  } else {
maxyld <- max(yields)
if ( maxyld > yp ) { acceptyield <- yt 
  } else { acceptyield <- yt + yt * (yp - maxyld) / yp }
acceptyield <- acceptyield * maxyld
#yields[yields < acceptyield ] <- 0
relyields <- (yields / maxyld)^fact
relyields[relyields<0.0025] <- 0
sumyld <- sum(relyields)
plantdates <- relyields / sumyld
return(plantdates)
  }
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
