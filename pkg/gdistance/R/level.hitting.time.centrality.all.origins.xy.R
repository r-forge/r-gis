`level.hitting.time.centrality.all.origins.xy` <-
function(id.xy, transition, weights.raster)
{
#A check to see if the transition matrix and the weights.raster have the same resolution and extent should be done here.
weights <- weights.raster@data[as.integer(rownames(transition@transitionmatrix))]
pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
L <- Laplacian(transition)
L <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
n <- max(L@Dim)
pointsofinterest <- pointsofinterestin[,4][pointsofinterestin[,4] %in% rownames(transition@transitionmatrix)]
if (length(pointsofinterest) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest)," out of ",length(pointsofinterestin[,4])," locations were found in the adjacency matrix.","\n")}
pointsofinterest <- unique(pointsofinterest)
indexvector <- match(pointsofinterest, rownames(transition@transitionmatrix))
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
indexvector2 <- cbind(pointsofinterestin[,1][pointsofinterestin[,4] %in% pointsofinterest], pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest])
resultout[as.character(indexvector2[,1])] <- result[as.character(indexvector2[,2])]
names(result.tc) <- as.character(pointsofinterest)
resultout.tc <- as.vector(matrix(NA,ncol = length(pointsofinterestin[,1])))
names(resultout.tc) <- as.character(pointsofinterestin[,1])
resultout.tc[as.character(indexvector2[,1])] <- result.tc[as.character(indexvector2[,2])]
totalresult <- list(unw=resultout,w=resultout.tc)
return(totalresult)
}

