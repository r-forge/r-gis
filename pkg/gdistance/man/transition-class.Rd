\name{transition-class}
\docType{class}
\alias{transition-class}
\alias{Arith,transition,transition-method}
\alias{coerce,transition,dsCMatrix-method}
\alias{dsCMatrix.to.transition,dsCMatrix,transition-method}
\alias{initialize,transition-method}
\alias{Ops,transition,transition-method}
\alias{show,transition-method}

\title{Class "transition" ~~~ }
\description{The class transition contains a transition matrix with transition values between connected cells in a raster. It also contains the geographic references of the underlying raster (bounding box, number of rows and columns). }
\section{Objects from the Class}{
Objects can be created by calls of the form \code{new("transition", nrows, ncols, xmin, xmax, ymin, ymax)}.
	 ~~ describe objects here ~~ 
}
\section{Slots}{
	 \describe{
    \item{\code{zerorowcol}:}{Object of class \code{"logical"} ~~ }
    \item{\code{transitionmatrix}:}{Object of class \code{"dsCMatrix"} ~~ }
    \item{\code{projection}:}{Object of class \code{"character"} ~~ }
    \item{\code{ncols}:}{Object of class \code{"integer"} ~~ }
    \item{\code{nrows}:}{Object of class \code{"integer"} ~~ }
    \item{\code{ncells}:}{Object of class \code{"integer"} ~~ }
    \item{\code{xmin}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{xmax}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{ymin}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{ymax}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{xres}:}{Object of class \code{"numeric"} ~~ }
    \item{\code{yres}:}{Object of class \code{"numeric"} ~~ }
  }
}
\section{Extends}{
Class \code{"\linkS4class{rasterchar}"}, directly.
}
\section{Methods}{
  \describe{
    \item{Arith}{\code{signature(e1 = "transition", e2 = "transition")}: ... }
    \item{coerce}{\code{signature(from = "transition", to = "dsCMatrix")}: ... }
    \item{dsCMatrix.to.transition}{\code{signature(dsCMatrix = "dsCMatrix", transition = "transition")}: ... }
    \item{initialize}{\code{signature(.Object = "transition")}: ... }
    \item{Ops}{\code{signature(e1 = "transition", e2 = "transition")}: ... }
    \item{show}{\code{signature(object = "transition")}: ... }
	 }
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ }

 ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
	~~objects to See Also as \code{\link{~~fun~~}}, ~~~
	or \code{\linkS4class{CLASSNAME}} for links to other classes
}
\examples{
showClass("transition")
}
\keyword{classes}
