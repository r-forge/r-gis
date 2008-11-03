\name{min.distance.accumulation}
\alias{min.distance.accumulation}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
min.distance.accumulation(gendistance, nsimulations)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gendistance}{ ~~Describe \code{gendistance} here~~ }
  \item{nsimulations}{ ~~Describe \code{nsimulations} here~~ }
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
function(gendistance,nsimulations)
{
gendistance <- as.matrix(gendistance)
nsamples <- length(gendistance[,1])
index <- cbind(rep(1:nsamples, times=nsamples),rep(1:nsamples, each=nsamples))
index1 <- subset(index,index[,1]<=index[,2])
index2 <- subset(index,index[,1]>index[,2])
min.distance.accumulation <- matrix(nrow=nsimulations,ncol=nsamples)
for (i in 1:nsimulations)
{
order <- sample(nsamples)
gendistance.reordered <- gendistance[order,order]
gendistance.reordered[index1] <- max(gendistance)+1
gendistance.reordered[1,1] <- 0
min.distance <- apply(gendistance.reordered,1,min)
min.distance.accumulation.matrix <- matrix(min.distance,nrow=length(min.distance),ncol=length(min.distance))
min.distance.accumulation.matrix[index2] <- 0
min.distance.accumulation[i,] <- colSums(min.distance.accumulation.matrix)
  }
return(colSums(min.distance.accumulation)/nsimulations)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
