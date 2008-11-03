\name{cluster.parameters}
\alias{cluster.parameters}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
cluster.parameters(gendistance, clusters, accuracy)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gendistance}{ ~~Describe \code{gendistance} here~~ }
  \item{clusters}{ ~~Describe \code{clusters} here~~ }
  \item{accuracy}{ ~~Describe \code{accuracy} here~~ }
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
function(gendistance,clusters,accuracy)
{
parameters.per.cluster <- vector(length=max(clusters))
for (cluster in 1:max(clusters))
{
selection <- names(clusters[clusters==cluster])
if(length(selection)>3)
{
gendistance.selection <- as.matrix(gendistance)[selection,selection]
mda <- min.distance.accumulation(gendistance.selection,accuracy)
x <- (0:(length(mda)-1))*mean(as.dist(gendistance.selection))
parameters.per.cluster[cluster] <- power.model1(x,mda)
  }
  }
return(parameters.per.cluster)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
