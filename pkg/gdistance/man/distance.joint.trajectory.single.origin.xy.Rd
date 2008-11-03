\name{distance.joint.trajectory.single.origin.xy}
\alias{distance.joint.trajectory.single.origin.xy}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
distance.joint.trajectory.single.origin.xy(transition, id.xy, origin.xy, weights)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ ~~Describe \code{transition} here~~ }
  \item{id.xy}{ ~~Describe \code{id.xy} here~~ }
  \item{origin.xy}{ ~~Describe \code{origin.xy} here~~ }
  \item{weights}{ ~~Describe \code{weights} here~~ }
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
function(transition, id.xy, origin.xy, weights) #transition is a sparse matrix. transition is a sparse matrix with as row/column names the cell numbers. Points of interest are locations (cellnumbers) for which we want to know mutual resistance distance. Procedure based on Fouss et al. (2007))
{
pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
pointsofinterest <- pointsofinterestin[,4][pointsofinterestin[,4] \%in\% rownames(transition)]
if (length(pointsofinterest) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest)," out of ",length(pointsofinterestin[,4])," locations were found in the adjacency matrix.","\n")}
pointsofinterest <- unique(pointsofinterest)
origin <- as.character(raster.get.cell.from.xy(transition, origin.xy))
if (origin \%in\% rownames(transition)) {} else {warning("The origin was not found in the transition matrix.")}
cat("Progress Bar", "\n")
cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
L <- Laplacian(transition)
Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
A <- as(L,"lMatrix")
A <- as(A,"dMatrix")
n <- max(Lr@Dim)
CMS <- matrix(ncol=length(pointsofinterest),nrow=length(pointsofinterest))
CMSt <- matrix(ncol=length(pointsofinterest),nrow=length(pointsofinterest))
onepercent <- ((length(pointsofinterest)^2)-length(pointsofinterest))/200
count <- 0
index.xy <- match(pointsofinterest,rownames(transition))
index.origin <- match(origin,rownames(transition))
for (i in 1:(length(pointsofinterest)-1))
{
ei <- matrix(0, ncol=1, nrow=n)
ei[index.xy[i],] <- -1
ei[index.origin,] <- 1 
xi <- solve(Lr,ei)
xi <- as.vector(xi)
Lplusallrowsi <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
Vi <- A * Lplusallrowsi
d <- t(t(A) * diag(Vi))
Vi <- - Vi + d
Currenti <- colSums(abs(Vi)*-L)/2
ii <- i + 1
for (j in ii:length(pointsofinterest))
{
ei <- matrix(0, ncol=1, nrow=n)
ei[index.xy[j],] <- -1
ei[index.origin,] <- 1 
xi <- solve(Lr,ei) 
xi <- as.vector(xi)
Lplusallrowsj <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
Vj <- A * Lplusallrowsj
d <- diag(Vi)
d <- t(t(A) * diag(Vj))
Vj <- - Vj + d
Currentj <- colSums(abs(Vj)*-L)/2
CMS[j,i] <- sum((pmin(Currenti,Currentj)))/sum(Currenti,Currentj)
CMSt[j,i] <- sum((pmin(Currenti,Currentj)*weights))/sum((Currenti+Currentj)*weights)
count <- count+1
if(count>=onepercent) {cat("|"); count<-count-onepercent}
  }
  }
cat("|","\n")
diag(CMS) <- 0
diag(CMSt) <- 0
CMSout <- matrix(nrow=length(pointsofinterestin[,1]),ncol=length(pointsofinterestin[,1]))
CMStoCMSoutIndex <- matrix(nrow=length(pointsofinterestin[,4][pointsofinterestin[,4] \%in\% pointsofinterest]), ncol=2)
CMStoCMSoutIndex[,1] <- match(pointsofinterestin[,1][pointsofinterestin[,4] \%in\% pointsofinterest],pointsofinterestin[,1])
CMStoCMSoutIndex[,2] <- match(pointsofinterestin[,4][pointsofinterestin[,4] \%in\% pointsofinterest],pointsofinterest)
CMSoutindex <- cbind(rep(CMStoCMSoutIndex[,1], each=length(CMStoCMSoutIndex[,1])),rep(CMStoCMSoutIndex[,1], times=length(CMStoCMSoutIndex[,1])))
CMSindex <- cbind(rep(CMStoCMSoutIndex[,2], each=length(CMStoCMSoutIndex[,2])),rep(CMStoCMSoutIndex[,2], times=length(CMStoCMSoutIndex[,2])))
CMSindex <- cbind(pmax(CMSindex[,1],CMSindex[,2]),pmin(CMSindex[,1],CMSindex[,2]))
CMSout[CMSoutindex] <- CMS[CMSindex]
CMStout <- matrix(nrow=length(pointsofinterestin[,1]),ncol=length(pointsofinterestin[,1]))
CMStout[CMSoutindex] <- CMSt[CMSindex] #as.dist etc.
rownames(CMSout) <- as.character(pointsofinterestin[,1])
colnames(CMSout) <- as.character(pointsofinterestin[,1])
rownames(CMStout) <- as.character(pointsofinterestin[,1])
colnames(CMStout) <- as.character(pointsofinterestin[,1])
result <- list(w=CMSout,unw=CMStout)
return(result)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
