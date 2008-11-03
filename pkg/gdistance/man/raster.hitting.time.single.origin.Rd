\name{raster.hitting.time.single.origin}
\alias{raster.hitting.time.single.origin}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
raster.hitting.time.single.origin(transition, origin.xy)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ ~~Describe \code{transition} here~~ }
  \item{origin.xy}{ ~~Describe \code{origin.xy} here~~ }
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
function(transition,origin.xy)
{
cat("Progress Bar", "\n")
cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
L <- Laplacian(transition)
Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
n <- max(Lr@Dim)
djj <- diag(L)
ldj <- rep(0, times=(n+1)) #destination (d) to all cells (j)
ldd <- rep(0, times=(n+1)) #destination to destination
loj <- 0 #origin (o) to all cells
lod <- rep(0, times=(n+1)) #origin to destination
origin.cell <- raster.get.cell.from.xy(transition, origin.xy)
originindex <- match(origin.cell, rownames(transition))
count <- 0
onepercent <- n/100
if (length(originindex)<1 | length(originindex)>1) {cat("Ambiguous or non-existing origin.","\n"); stop}
for (i in 1:n)
{
ei <- matrix((-1/(n+1)), ncol=1, nrow=n)
ei[i] <- 1-(1/(n+1)) 
xi <- solve(Lr,ei) 
xi <- as.vector(xi)
Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
ldj[i] <- sum(Lplusallrows*djj)
ldd[i] <- Lplusallrows[i]*sum(djj)
count <- count+1
if(count>=onepercent) {cat("|"); count<-count-onepercent}
  }
cat("|","\n")
e <- matrix((-1/(n+1)), ncol=1, nrow=n)
e[originindex,] <- 1-(1/(n+1)) 
x <- solve(Lr,e) 
x <- as.vector(x)
Lplusallrows <- c(x-sum(x/(n+1)),(sum(x)/(n+1)))
loj <- sum(Lplusallrows*djj)
lod <- Lplusallrows*sum(djj)
AFPT <- (loj - lod - ldj + ldd)
AFPT[n+1] <- AFPT[which(L[,n+1]<0)[1]]
names(AFPT) <- as.character(rownames(transition))
cat("|","\n")
return(AFPT)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
