\name{permregression}
\alias{permregression}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
permregression(forml, permutations = 99, method = "residual")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{forml}{ ~~Describe \code{forml} here~~ }
  \item{permutations}{ ~~Describe \code{permutations} here~~ }
  \item{method}{ ~~Describe \code{method} here~~ }
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
function (forml, permutations = 99, method="residual") 
{
forml <- as.formula(forml)
reference.summary <- summary(lm(forml)) 
formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[2:length(rownames(attr(terms(forml), "factors")))] 
begincoeff <- 2*(length(formterms)+1)+2
endcoeff <- 3*(length(formterms)+1)
statistic <- c(reference.summary$r.squared,abs(reference.summary$coefficients[begincoeff:endcoeff])) #Reference statistic
if (method=="raw")
{
y <- as.dist(get(rownames(attr(terms(forml,keep.order = TRUE), "factors"))[1]))
N <- attributes(y)$Size
  }
if (method=="residual")
{
y <- reference.summary$residuals
  }
perm <- matrix(0, nrow = permutations, ncol = (length(formterms)+1))
permformula <- as.formula(paste("permvec ~",paste(formterms, collapse="+"))) 
for (i in 1:permutations) 
{
take <- sample(N,N)
permvec <- as.dist(as.matrix(y)[take, take])
perm.summary <- summary(lm(permformula))
perm[i,] <- as.vector(c(perm.summary$r.squared,abs(perm.summary$coefficients[begincoeff:endcoeff]))) #Reports the R2 and partial t's for each lm permutation
  }
signif <- (rowSums(apply(perm,1,function(x){x>statistic}))+1)/(permutations+1)  #The "+1"s of the formula are due to Hope (1968) who added the reference value itself to the distribution to make the test slightly more "conservative" (Legendre et al. 1994). TODO use apply
result <- list(permutations=permutations,r.squared=statistic[1],significance.r=signif[1],significance.terms=signif[2:length(signif)])
return(result)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
