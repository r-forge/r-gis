\name{projection.correction.adjacency}
\alias{projection.correction.adjacency}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
projection.correction.adjacency(raster, adjacency)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{raster}{ ~~Describe \code{raster} here~~ }
  \item{adjacency}{ ~~Describe \code{adjacency} here~~ }
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
function(raster, adjacency) 
{
correction <- matrix(NA, nrow=length(adjacency[,1]),ncol=3)
correction[,1:2] <- cbind(raster.get.row.from.cell(raster,adjacency[,1]),raster.get.row.from.cell(raster,adjacency[,2]))
lookup.table <- cbind(1/(cos((pi/180)*raster.get.y.from.row(raster,unique(correction[,1])))),cos((pi/180)*raster.get.y.from.row(raster,unique(correction[,1])+0.5)))
rownames(lookup.table) <- as.character(unique(correction[,1]))
lookup <- function(row,direction){lookup.table[as.character(row),direction]}
correction[,3][correction[,1]==correction[,2]] <- lookup(correction[,1][correction[,1]==correction[,2]],1)
correction[,3][correction[,1]!=correction[,2]] <- lookup(pmin(correction[,1][correction[,1]!=correction[,2]],correction[,2][correction[,1]!=correction[,2]]),2)
adjacency.pc <- cbind(adjacency,correction[,3])
return(adjacency.pc)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
