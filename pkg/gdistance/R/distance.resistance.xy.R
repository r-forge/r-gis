`distance.resistance.xy` <-
function(transition, id.xy) #transition is a sparse matrix. transition is a sparse matrix with as row/column names the cell numbers. id.xy is a matrix of three rows: ids, x and y coordinates. Procedure based on Fouss et al. (2007))
{
pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
pointsofinterest <- pointsofinterestin[,4][pointsofinterestin[,4] %in% as.integer(rownames(transition@transitionmatrix))]
if (length(pointsofinterest) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest)," out of ",length(pointsofinterestin[,4])," locations were found in the adjacency matrix.","\n")}
pointsofinterest <- unique(pointsofinterest)
L <- Laplacian(transition)
L <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
n <- max(L@Dim)
Lstarplus <- matrix(ncol=1,nrow=length(pointsofinterest))
Lplus <- matrix(ncol=length(pointsofinterest),nrow=length(pointsofinterest))
index <- match(pointsofinterest,rownames(transition@transitionmatrix))
for (i in 1:length(pointsofinterest))
{
ei <- matrix((-1/(n+1)), ncol=1, nrow=n)
ei[index[i],] <- 1-(1/(n+1))
xi <- solve(L,ei) 
xi <- as.vector(xi)
Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
Lplus[,i] <- Lplusallrows[index]
}
RD <- (-2*Lplus + matrix(diag(Lplus),nrow=length(pointsofinterest),ncol=length(pointsofinterest)) + t(matrix(diag(Lplus),nrow=length(pointsofinterest),ncol=length(pointsofinterest)))) #* sum(transition)
RDout <- matrix(nrow=length(pointsofinterestin[,1]),ncol=length(pointsofinterestin[,1]))
RDtoRDoutIndex <- matrix(nrow=length(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest]), ncol=2)
RDtoRDoutIndex[,2] <- match(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest],pointsofinterest)
RDtoRDoutIndex[,1] <- match(pointsofinterestin[,1][pointsofinterestin[,4] %in% pointsofinterest],pointsofinterestin[,1])
RDindex <- cbind(rep(RDtoRDoutIndex[,2], each=length(RDtoRDoutIndex[,2])),rep(RDtoRDoutIndex[,2], times=length(RDtoRDoutIndex[,2])))
RDoutindex <- cbind(rep(RDtoRDoutIndex[,1], each=length(RDtoRDoutIndex[,1])),rep(RDtoRDoutIndex[,1], times=length(RDtoRDoutIndex[,1])))
RDout[RDoutindex] <- RD[RDindex] #as.dist etc.
rownames(RDout) <- as.character(pointsofinterestin[,1])
colnames(RDout) <- as.character(pointsofinterestin[,1])
return(as.dist(RDout))
}

