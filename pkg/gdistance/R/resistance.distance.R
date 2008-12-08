resistance.distance <- function(id.xy, transition)
{
	rd <- matrix(nrow=length(id.xy[,1]),ncol=length(id.xy[,1]))
	rownames(rd) <- as.integer(id.xy[,1]); colnames(rd) <- as.integer(id.xy[,1])
	cc <- .connected.components(transition)
	pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
	pointsofinterest <- pointsofinterestin[pointsofinterestin[,4] %in% as.integer(rownames(transition@transitionmatrix))]
	if (length(pointsofinterest[,1]) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest[,1])," out of ",length(pointsofinterestin[,4])," locations were found in the adjacency matrix.","\n")}
	cc.with.xy <- unique(cc[,2][cc[,1] %in% unique(pointsofinterest[,4])])
	for (i in 1:length(cc.with.xy))
	{
		pointsofinterest.subset <- pointsofinterest[,4][pointsofinterest[,4] %in% cc[,1][cc[,2] == cc.with.xy[i]]]
		tm <- transition@transitionmatrix[cc[,1][cc[,2]==i],cc[,1][cc[,2]==i]]
		L <- Laplacian(tm)
		L <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
		n <- max(L@Dim)
		Lstarplus <- matrix(ncol=1,nrow=length(pointsofinterest.subset))
		Lplus <- matrix(ncol=length(pointsofinterest.subset),nrow=length(pointsofinterest.subset))
		index <- match(pointsofinterest.subset,rownames(tm))
		for (i in 1:length(pointsofinterest.subset))
		{
			ei <- matrix((-1/(n+1)), ncol=1, nrow=n)
			ei[index[i],] <- 1-(1/(n+1))
			xi <- solve(L,ei) 
			xi <- as.vector(xi)
			Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
			Lplus[,i] <- Lplusallrows[index]
		}
		rd[which(pointsofinterestin[,4] %in% pointsofinterest.subset),which(pointsofinterestin[,4] %in% pointsofinterest.subset)] <- (-2*Lplus + matrix(diag(Lplus),nrow=length(pointsofinterest),ncol=length(pointsofinterest)) + t(matrix(diag(Lplus),nrow=length(pointsofinterest),ncol=length(pointsofinterest))))[match(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest.subset],pointsofinterest.subset),match(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest.subset],pointsofinterest.subset)]
	}
	return(as.dist(rd))
}

