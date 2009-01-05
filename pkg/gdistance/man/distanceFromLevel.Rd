\name{distance.from.level}
\alias{distance.from.level}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
distance.from.level(levels, fun, diag=TRUE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{levels}{ ~~Describe \code{levels} here~~ }
  \item{fun}{ ~~Describe \code{fun} here~~ }
  \item{diag}{ ~~Describe \code{diag} here~~ }
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
function(levels,fun)
{
result <- matrix(NA,ncol=length(levels),nrow=length(levels))
rownames(result) <- names(levels)
colnames(result) <- names(levels)
index <- cbind(rep(1:length(levels), each=length(levels)),rep(1:length(levels), times=length(levels)))
result[index] <- apply(cbind(levels[index[,1]],levels[index[,2]]),1,fun)
return(as.dist(result, diag=T))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
