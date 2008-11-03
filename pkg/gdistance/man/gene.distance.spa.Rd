\name{gene.distance.spa}
\alias{gene.distance.spa}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{ ~~function to do ... ~~ }
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
gene.distance.spa(data, null.alleles = "missing")
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{ ~~Describe \code{data} here~~ }
  \item{null.alleles}{ ~~Describe \code{null.alleles} here~~ }
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
function(data,null.alleles="missing")
{
data <- na.omit(data)
if(null.alleles=="missing"){data <- subset(data,data[,3]!=0)}
if(null.alleles=="unlike"){data[,3][data[,3]==0] <- seq(from=max(data[,3])+1,to=max(data[,3])+length(data[,3][genedata[,3]==0]))}
if(null.alleles=="alike"){}
accession.index <- unique(data[,1])
marker.fragment <- paste(data[,2],data[,3],sep="-")
marker.fragment.index <- unique(marker.fragment)
i <- match(marker.fragment,marker.fragment.index)-1
j <- match(data[,1],accession.index)-1
x <- rep(1,times=length(data[,1]))
Dim1 <- length(marker.fragment.index)
Dim2 <- length(accession.index)
data.matrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim1,Dim2)))
data.matrix <- as(data.matrix,"dgCMatrix")
marker.index <- unlist(strsplit(marker.fragment.index,"-"))[seq(from=1,to=length(marker.fragment.index)*2,by=2)]
distance.matrix <- matrix(0,ncol=length(accession.index),nrow=length(accession.index))
sum.total <- apply(data.matrix,2,function(x){tapply(x,marker.index,sum)})
data.matrix.logical <- Matrix(as.integer(as.logical(data.matrix)),ncol=ncol(data.matrix))
n.accessions <- length(accession.index)
onepercent <- n.accessions/100
count <- 0
cat("Progress Bar", "\n")
cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
for (i in 1:(n.accessions-1))
{
from <- data.matrix.logical[,i:n.accessions] * data.matrix[,i] 
to <- data.matrix[,i:n.accessions] * data.matrix.logical[,i] #as.numeric(as.logical(data.matrix[,i])) 
sum.from <- apply(from,2,function(x){tapply(x,marker.index,sum)})
sum.to <- apply(to,2,function(x){tapply(x,marker.index,sum)})
sum.total.selection <- sum.total[,i:n.accessions]
distance.matrix[i,i:n.accessions] <- apply(pmin(sum.from/(sum.total.selection+0.0000001),sum.to/(sum.total.selection+0.0000001)),2,mean) #TODO subset
count <- count+1
if(count>=onepercent) {cat("|"); count<-count-onepercent}
  }
distance.matrix[n.accessions,n.accessions] <- mean(as.logical(tapply(data.matrix.logical[,n.accessions],marker.index,sum)))
cat("|","\n")
distance.matrix <- t(distance.matrix * sqrt(1/diag(distance.matrix))) * sqrt(1/diag(distance.matrix))
distance.matrix <- 1-distance.matrix
rownames(distance.matrix) <- as.character(accession.index)
colnames(distance.matrix) <- as.character(accession.index)
return(as.dist(distance.matrix))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
