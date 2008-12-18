resistanceDistance <- function(id.xy, transition) #TODO projection correction
{
	transition <- .projectionCorrection(transition, type="resistance") 
	rd <- matrix(Inf,nrow=length(id.xy[,1]),ncol=length(id.xy[,1]))
	rownames(rd) <- as.integer(id.xy[,1]); colnames(rd) <- as.integer(id.xy[,1])
	pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
	pointsofinterest <- na.omit(subset(pointsofinterestin,pointsofinterestin[,4] %in% as.integer(rownames(transition@transitionmatrix))))
	rd[-which(rownames(rd) %in% pointsofinterest[,1]),] <- NA
	rd[,-which(rownames(rd) %in% pointsofinterest[,1])] <- NA
	if (length(pointsofinterest[,1]) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest[,1])," out of ",length(pointsofinterestin[,4])," locations were found in the transition matrix. NAs introduced.")}
	cc <- .connected.components(transition)
	cc.subset <- subset(cc,cc[,1] %in% pointsofinterest[,4])
	cc.with.xy <- which(tabulate(cc.subset[,2])>1)
	if(length(which(tabulate(cc.subset[,2])>0)) > 1){warning(length(which(tabulate(cc.subset[,2])>0)), " unconnected components; infinite distances introduced.")}
	if(length(cc.with.xy)<=0){warning("no connected components with more than one location"); return(rd)}
	else
	{
		for (i in 1:length(cc.with.xy))
		{
			pointsofinterest.subset <- unique(pointsofinterest[,4][pointsofinterest[,4] %in% cc[,1][cc[,2] == cc.with.xy[i]]])
			tm <- transition@transitionmatrix[as.character(cc[,1][cc[,2]==cc.with.xy[i]]),as.character(cc[,1][cc[,2]==cc.with.xy[i]])]
			L <- .Laplacian(tm)
			#L <- L[-L@Dim[1],-L@Dim[2]]
			L <- L[-max(which(!(rownames(L) %in% as.character(pointsofinterest.subset)))),-max(which(!(rownames(L) %in% as.character(pointsofinterest.subset))))]
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
			rd.rough <- -2*Lplus + matrix(diag(Lplus),nrow=length(pointsofinterest.subset),ncol=length(pointsofinterest.subset)) + t(matrix(diag(Lplus),nrow=length(pointsofinterest.subset),ncol=length(pointsofinterest.subset)))
			index1 <- which(pointsofinterestin[,4] %in% pointsofinterest.subset)
			index2 <- match(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest.subset],pointsofinterest.subset)
			rd[index1,index1] <- rd.rough[index2,index2]
		}	
		return(as.dist(rd))
	}
}

