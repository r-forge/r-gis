\name{leafblast}
\alias{leafblast}
\alias{leafblast_v1}

%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
leafblast(wth, duration=120, startday=1, rhlim=90) 
leafblast_v1(wth, duration=120, startday=1) 
}
\arguments{
  \item{wth}{ Describe \code{xy} here }
  \item{duration}{ Describe \code{x} here }  
  \item{startday}{ Describe \code{x} here }    
  \item{rhlim}{ threshold to decide whethere leaves are wet or not }      
}
\details{
  ~~ If necessary, more details than the description above ~~
}
\value{
  ...
}
\references{ ~put references to the literature/web site here ~ }
\author{ ~~who you are~~ }
\note{ ~~further notes~~ 

 ~Make other sections like Warning with \section{Warning }{....} ~
}
\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{

rhtable <- cbind(0:10*12, c(89.5, 89.5, 89.5, 89, 90.5, 88.5, 90, 92, 90, 90, 88.5))
tmptable <- cbind(0:10*12, c(19.9, 20.3, 19.9, 20.3, 20.1, 20.1, 20, 20, 19.8, 20, 20))
dur <- 120
rh <- vector(length=dur)
tmp  <- vector(length=dur)
for (d in 1:dur) {
	rh[d] <- AFGen(rhtable, d)
	tmp[d] <- AFGen(tmptable, d)
}	
tmax <- tmp + 5
tmin <- tmp - 5
wth <- as.data.frame(cbind(tmin, tmax, rh))
res <- leafblast(wth)
splot(res)




# example runs to create contour plot
rhrange <- 1:10 * 3 + 70
tmprange <- 1:4 * 3 + 14
m <- matrix(NA, length(rhrange), length(tmprange))

rhc <- 0
for (r in rhrange) {
	rhc <- rhc + 1
	tc <- 0
	for (t in tmprange) {
		tc <- tc + 1
		rh <- rep(r, 120)
		tmp <- rep(t, 120)
		tmin <- tmp - 5
		tmax <- tmp + 5
		wth <- as.data.frame(cbind(tmin, tmax, rh))
		res <- leafblast(wth)
		raudpc <- sum(res[,6]) / 120
		m[rhc, tc] <- raudpc
	}
}
contour(rhrange, tmprange, m, xlab="Relative humidity (perc)", ylab="Temperature (C)", labcex = 1, col = (terrain.colors(14)), lwd=2 )

}
\keyword{ spatial }
