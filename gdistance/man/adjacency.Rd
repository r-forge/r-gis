\name{adjacency}
\alias{adjacency}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  Determines adjacency for cells in a raster.
}
\usage{
adjacency(raster, outer.meridian.connect = FALSE)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{raster}{ ~~Describe \code{raster} here~~ }
  \item{outer.meridian.connect}{ ~~Describe \code{outer.meridian.connect} here~~ }
}
\details{
  
}
\value{
A two-column list of cell numbers which are adjacent. 
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
function(raster, outer.meridian.connect=FALSE) 
{
cells <- c(1:raster@ncells)
data <- cbind(cells, raster@data)
datacells <- as.integer(na.omit(data)[,1])
left <- seq(raster@ncols+1,(raster@ncols*raster@nrows-2*raster@ncols+1),by=raster@ncols) 
right <- seq(2*raster@ncols,raster@ncols*raster@nrows-raster@ncols,by=raster@ncols)
upper <- 2:(raster@ncols-1)
lower <- seq((raster@ncols*raster@nrows-raster@ncols+2),(raster@ncols*raster@nrows-1),by=1)
upperleft <- 1
upperright <- raster@ncols
lowerleft <- raster@ncols*raster@nrows-raster@ncols+1
lowerright <- raster@ncols*raster@nrows
datacells.core <- setdiff(datacells,(c(left,right,upper,lower,upperleft,upperright,lowerleft,lowerright)))
datacells.upper <- intersect(datacells,upper)
datacells.lower <- intersect(datacells,lower)
datacells.left <- as.integer(intersect(datacells,left))
datacells.right <- as.integer(intersect(datacells,right))
datacell.upperleft <- as.integer(intersect(datacells,upperleft))
datacell.upperright <- as.integer(intersect(datacells,upperright))
datacell.lowerleft <- as.integer(intersect(datacells,lowerleft))
datacell.lowerright <- as.integer(intersect(datacells,lowerright))
from.core <- as.integer(rep(datacells.core, times=4))
to.core <- as.integer(c(datacells.core+1,datacells.core-1,datacells.core+raster@ncols,datacells.core-raster@ncols))
from.upper <- as.integer(rep(datacells.upper, times=3))
to.upper <- as.integer(c(datacells.upper+1,datacells.upper-1,datacells.upper+raster@ncols))
from.lower <- as.integer(rep(datacells.lower, times=3))
to.lower <- as.integer(c(datacells.lower+1,datacells.lower-1,datacells.lower-raster@ncols))
from.left <- as.integer(rep(datacells.left, times=3))
to.left <- as.integer(c(datacells.left+1,datacells.left+raster@ncols,datacells.left-raster@ncols))
from.right <- as.integer(rep(datacells.right, times=3))
to.right <- as.integer(c(datacells.right-1,datacells.right+raster@ncols,datacells.right-raster@ncols))
from.upperleft <- as.integer(rep(datacell.upperleft, times=2))
to.upperleft <- as.integer(c(datacell.upperleft+1,datacell.upperleft+raster@ncols))
from.upperright <- as.integer(rep(datacell.upperright, times=2))
to.upperright <- as.integer(c(datacell.upperright-1,datacell.upperright+raster@ncols))
from.lowerleft <- as.integer(rep(datacell.lowerleft, times=2))
to.lowerleft <- as.integer(c(datacell.lowerleft+1,datacell.lowerleft-raster@ncols))
from.lowerright <- as.integer(rep(datacell.lowerright, times=2))
to.lowerright <- as.integer(c(datacell.lowerright-1,datacell.lowerright-raster@ncols))
fromto <- rbind(cbind(from.core,to.core),cbind(from.upper,to.upper),cbind(from.lower,to.lower),cbind(from.left,to.left),cbind(from.right,to.right),cbind(from.upperleft,to.upperleft),cbind(from.upperright,to.upperright),cbind(from.lowerleft,to.lowerleft),cbind(from.lowerright,to.lowerright))
if (outer.meridian.connect==TRUE) 
{
mer.from.left <- rbind(cbind(datacells.left,as.integer(datacells.left+raster@ncols-1)),cbind(datacell.upperleft,as.integer(datacell.upperleft+raster@ncols-1)),cbind(datacell.lowerleft,as.integer(datacell.lowerleft+raster@ncols-1)))
mer.from.right <- rbind(cbind(datacells.right,as.integer(datacells.right-raster@ncols+1)),cbind(datacell.upperright,as.integer(datacell.upperright-raster@ncols+1)),cbind(datacell.lowerright,as.integer(datacell.lowerright-raster@ncols+1)))
fromto <- rbind(fromto,mer.from.left,mer.from.right)
  }
fromto <- subset(fromto,fromto[,2] \%in\% datacells)
colnames(fromto) <- c("from","to")
return(fromto)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
