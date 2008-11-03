\name{transition.connected.component}
\alias{transition.connected.component}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
transition.connected.component(transition, id.xy)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ ~~Describe \code{transition} here~~ }
  \item{id.xy}{ ~~Describe \code{id.xy} here~~ }
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
function(transition, id.xy)
{
adjacency <- adjacency.from.transition(transition)
pointsofinterestin <- raster.get.cell.from.xy(transition, id.xy[,2:3])
adj.graph <- graph.edgelist(cbind(as.character(adjacency[,1]),as.character(adjacency[,2])))
pointsofinterest <- subset(pointsofinterestin, pointsofinterestin \%in\% V(adj.graph)$name)
if (length(pointsofinterest) < length (pointsofinterestin)) 
{
warning(length(pointsofinterest), " out of ", length(pointsofinterestin), " locations were found in the adjacency matrix.","\n")
  }
cl <- clusters(adj.graph)
cluster.membership <- cbind(V(adj.graph)$name,cl$membership)
grouping.pointsofinterest <- subset(cluster.membership, cluster.membership[,1] \%in\% pointsofinterest)
setofcls <- unique(grouping.pointsofinterest[,2])
select <- cbind(setofcls, tabulate(match(grouping.pointsofinterest[,2], setofcls)))
select <- subset(select[,1],select[,2] == max(select[,2]))
selected.pointsofinterest <- subset(grouping.pointsofinterest[,1],grouping.pointsofinterest[,2] == select)
if (length(selected.pointsofinterest) < length(unique(pointsofinterest)))
{
warning(length(pointsofinterestin[pointsofinterestin \%in\% selected.pointsofinterest]), " out of ", length(pointsofinterestin)," locations were included in the selected connected component. ","\n")
  }
selected.cells <- subset(cluster.membership[,1],cluster.membership[,2] == select)
adjacency.cc <- subset(adjacency,(as.character(adjacency[,1]) \%in\% selected.cells & as.character(adjacency[,2]) \%in\% selected.cells))
transition.dsC <- as(transition,"dsCMatrix")
transition.dsC <- transition.dsC[adjacency.cc,adjacency.cc]
transition <- dsCMatrix.to.transition(transition.dsC,transition)
return(transition)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
