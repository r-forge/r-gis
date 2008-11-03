\name{adjacency.from.transition}
\alias{adjacency.from.transition}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
adjacency.from.transition(transition)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{transition}{ ~~Describe \code{transition} here~~ }
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
function(transition)
{
if (transition@zerorowcol == TRUE)
{
transition.dgT <- as(transition,"dgTMatrix")
adjacency <- cbind(transition.dgT@i+1,transition.dgT@j+1)
  }
if (transition@zerorowcol == FALSE)
{
transition.dgT <- as(transition,"dgTMatrix")
adjacency <- cbind(transition@Dimnames[[1]][transition.dgT@i+1],transition@Dimnames[[2]][transition.dgT@j+1])
  }
return(adjacency)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
