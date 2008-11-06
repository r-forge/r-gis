joint.hitting.time.distance <- function(id.xy, transition, weights.raster)
{
	weightsvector <- weights.raster@data[rownames(transition@transitionmatrix)]
	pointsofinterestin <- cbind(id.xy[,1:3],raster.get.cell.from.xy(transition, id.xy[,2:3]))
	pointsofinterest <- pointsofinterestin[,4][pointsofinterestin[,4] %in% as.integer(rownames(transition@transitionmatrix))]
	if (length(pointsofinterest) < length(pointsofinterestin[,4])) {warning(length(pointsofinterest)," out of ",length(pointsofinterestin[,4])," locations were found in the adjacency matrix.","\n")}
	pointsofinterest <- unique(pointsofinterest)
	L <- Laplacian(transition)
	Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
	n <- max(Lr@Dim)
	JC <- matrix(ncol=length(pointsofinterest),nrow=length(pointsofinterest))
	rownames(JC) <- as.character(pointsofinterest)
	colnames(JC) <- as.character(pointsofinterest)
	JCt <- matrix(ncol=length(pointsofinterest),nrow=length(pointsofinterest))
	rownames(JCt) <- as.character(pointsofinterest)
	colnames(JCt) <- as.character(pointsofinterest)
	onepercent <- ((length(pointsofinterest)^2)-length(pointsofinterest))/200
	indexvector <- match(pointsofinterest, rownames(transition@transitionmatrix))
	count <- 0
	cat("Progress Bar", "\n")
	cat("---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|","\n")
	for (i in 1:(length(pointsofinterest)-1))
	{
		ei <- as.matrix(diag(Lr))
		ei[indexvector[i],] <- 1-(1/(n+1))
		xi <- solve(Lr,ei) 
		xi <- as.vector(xi) 
		Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
		Voltagedifferencei <- abs(Lplusallrows - Lplusallrows[indexvector[i]])
		ii <- i + 1
		for (j in ii:length(pointsofinterest))
		{
			ei <- as.matrix(diag(Lr))
			ei[indexvector[i],] <- 1-(1/(n+1))
			xi <- solve(Lr,ei) 
			xi <- as.vector(xi) 
			Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
			Voltagedifferencej <- abs(Lplusallrows - Lplusallrows[indexvector[j]])
			JC[j,i] <- (sum((pmin(Voltagedifferencei,Voltagedifferencej)))*2)/sum(Voltagedifferencei,Voltagedifferencej)
			JCt[j,i] <- (sum((pmin(Voltagedifferencei,Voltagedifferencej)*weightsvector))*2)/sum((Voltagedifferencei+Voltagedifferencej)*weightsvector)
			count <- count+1
			if(count>=onepercent) {cat("|"); count<-count-onepercent}
		}
	}
	cat("|","\n")
	diag(JC) <- 0
	diag(JCt) <- 0
	JCout <- matrix(nrow=length(pointsofinterestin[,1]),ncol=length(pointsofinterestin[,1]))
	JCtoJCoutIndex <- matrix(nrow=length(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest]), ncol=2)
	JCtoJCoutIndex[,1] <- match(pointsofinterestin[,1][pointsofinterestin[,4] %in% pointsofinterest],pointsofinterestin[,1])
	JCtoJCoutIndex[,2] <- match(pointsofinterestin[,4][pointsofinterestin[,4] %in% pointsofinterest],pointsofinterest)
	JCoutindex <- cbind(rep(JCtoJCoutIndex[,1], each=length(JCtoJCoutIndex[,1])),rep(JCtoJCoutIndex[,1], times=length(JCtoJCoutIndex[,1])))
	JCindex <- cbind(rep(JCtoJCoutIndex[,2], each=length(JCtoJCoutIndex[,2])),rep(JCtoJCoutIndex[,2], times=length(JCtoJCoutIndex[,2])))
	JCindex <- cbind(pmax(JCindex[,1],JCindex[,2]),pmin(JCindex[,1],JCindex[,2]))
	JCout[JCoutindex] <- JC[JCindex]
	JCtout <- matrix(nrow=length(pointsofinterestin[,1]),ncol=length(pointsofinterestin[,1]))
	JCtout[JCoutindex] <- JCt[JCindex]
	rownames(JCout) <- as.character(pointsofinterestin[,1])
	colnames(JCout) <- as.character(pointsofinterestin[,1])
	rownames(JCtout) <- as.character(pointsofinterestin[,1])
	colnames(JCtout) <- as.character(pointsofinterestin[,1])
	result <- list(unw=as.dist(JCout),w=as.dist(JCtout))
	return(result)
}

