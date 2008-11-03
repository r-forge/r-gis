\name{regression.backwardselimination}
\alias{regression.backwardselimination}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
regression.backwardselimination(forml, signlevel = 0.05, permutations = 99, method = "raw")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{forml}{ ~~Describe \code{forml} here~~ }
  \item{signlevel}{ ~~Describe \code{signlevel} here~~ }
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
function (forml, signlevel=0.05, permutations=99, method="raw") #This assumes that elements in the formula are globally available #TODO Method: forward, stepwise
{
forml <- as.formula(forml)
formterms <- rownames(attr(terms(forml,keep.order = TRUE), "factors"))[2:length(rownames(attr(terms(forml), "factors")))]
dummy <- rep(1, times = (length(formterms)))
names(dummy) <- formterms
newstep <- TRUE
while (newstep == TRUE)
{
formulatotest <- as.formula(paste(forml[[2]], " ~ ",paste(formterms[which(dummy==1)], collapse = " + ")))
regrresult <- permregression(formulatotest, permutations, method=method)
signterms <- regrresult$significance.terms
cat("R2: ",regrresult$r.squared,"\n")
cat("p value of R2: ", regrresult$significance.r,"\n")
cat("p values of variables: ", signterms,"\n")
i <- which(signterms==max(signterms) & signterms >= signlevel/sum(dummy))
if (length(i)>1) {warning("Least significant variable (highest p) could not be identified. Try more permutations."); i <- i[1]}
if (length(i)==0) {cat("All remaining variables are significant.","\n"); newstep <- FALSE}
if (sum(dummy)<1) {cat("None of the remaining variables is significant. See if the significance levels and number of permutations are appropriate.","/n"); newstep <- FALSE}
if (length(i)==1) {cat("Variable dropped: ", formterms[which(dummy==1)][i],"\n"); dummy[formterms[which(dummy==1)][i]] <- 0}
  }
cat("Final model:","\n")
print(formulatotest)
return(regrresult)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
