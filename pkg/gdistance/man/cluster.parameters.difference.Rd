\name{cluster.parameters.difference}
\alias{cluster.parameters.difference}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
cluster.parameters.difference(gendistance, cluster.distance, k, significance.perm, accuracy.perm)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{gendistance}{ ~~Describe \code{gendistance} here~~ }
  \item{cluster.distance}{ ~~Describe \code{cluster.distance} here~~ }
  \item{k}{ ~~Describe \code{k} here~~ }
  \item{significance.perm}{ ~~Describe \code{significance.perm} here~~ }
  \item{accuracy.perm}{ ~~Describe \code{accuracy.perm} here~~ }
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
function(gendistance,cluster.distance,k,significance.perm,accuracy.perm)
{
cluster.tree <- hclust(cluster.distance, method = "ward")
clusters <- cutree(cluster.tree,k=k)
cp.reference <- cluster.parameters(gendistance,clusters,accuracy.perm)
cp.permutation <- matrix(nrow=significance.perm,ncol=max(clusters))
for (i in 1:significance.perm)
{
clusters.permuted <- sample(clusters)
names(clusters.permuted) <- names(clusters)
cp.permutation[i,] <- cluster.parameters(gendistance,clusters.permuted,accuracy.perm)
  }
signif <- (rowSums(apply(cp.permutation,1,function(x){x<cp.reference}))+1)/(significance.perm+1)
size <- tabulate(clusters)
return(cbind(signif,size,cp.reference))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
