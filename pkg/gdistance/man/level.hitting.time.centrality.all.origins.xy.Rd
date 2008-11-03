\name{level.hitting.time.centrality.all.origins.xy}
\alias{level.hitting.time.centrality.all.origins.xy}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  Calculates the (weighted) sum of the average first-hitting time from all cells to a location.
}
\usage{
level.hitting.time.centrality.all.origins.xy(transition, raster.weights, id.xy)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ transition matrix }
  \item{weights}{ raster with weight values for each cell }
  \item{id.xy}{ point locations }
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
function(transition,weights,id.xy)
{
pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
L <- Laplacian(transition)
L <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
n <- max(L@Dim)
pointsofinterest <- pointsofinterestin[,4][pointsofinterestin[,4] \%in\% rownames(transition)]
if (length(pointsofinterest) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest)," out of ",length(pointsofinterestin[,4])," locations were found in the adjacency matrix.","\n")}
pointsofinterest <- unique(pointsofinterest)
indexvector <- match(pointsofinterest, rownames(transition))
result <- vector(length=length(pointsofinterest))
result.tc <- vector(length=length(pointsofinterest))
for (i in 1:length(pointsofinterest))
{
ei <- as.matrix(diag(L))
ei[indexvector[i],] <- -sum(diag(L))
xi <- solve(L,ei) 
xi <- as.vector(xi) 
Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
Voltagedifference <- Lplusallrows - Lplusallrows[indexvector[i]]
result[i] <- sum(Voltagedifference) 
result.tc[i] <- sum(Voltagedifference*weights) 
  }
names(result) <- as.character(pointsofinterest)
resultout <- as.vector(matrix(NA,ncol = length(pointsofinterestin[,1])))
names(resultout) <- as.character(pointsofinterestin[,1])
indexvector2 <- cbind(pointsofinterestin[,1][pointsofinterestin[,4] \%in\% pointsofinterest], pointsofinterestin[,4][pointsofinterestin[,4] \%in\% pointsofinterest])
resultout[as.character(indexvector2[,1])] <- result[as.character(indexvector2[,2])]
names(result.tc) <- as.character(pointsofinterest)
resultout.tc <- as.vector(matrix(NA,ncol = length(pointsofinterestin[,1])))
names(resultout.tc) <- as.character(pointsofinterestin[,1])
resultout.tc[as.character(indexvector2[,1])] <- result.tc[as.character(indexvector2[,2])]
totalresult <- list(unw=resultout,w=resultout.tc)
return(totalresult)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
