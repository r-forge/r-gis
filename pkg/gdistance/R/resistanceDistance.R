# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version beta
# Licence GPL v3

#TODO check if coordinate systems are equal.
#TODO check if bounding box of coordinates falls inside bb of transition
#TODO coordinates in same cell: distance = 0

setGeneric("resistanceDistance", function(transition, fromCoords, toCoords) standardGeneric("resistanceDistance"))

setMethod("resistanceDistance", signature(transition = "Transition", fromCoords = "SpatialPoints", toCoords = "SpatialPoints"), def = function(transition, fromCoords, toCoords)
	{
		fromCoords <- coordinates(fromCoords)
		toCoords <- coordinates(toCoords)
		transition <- .transitionSolidify(transition)
		transition <- .projectionCorrection(transition, type="resistance") 
		rd <- matrix(Inf,nrow=length(fromCoords[,1]),ncol=length(toCoords[,1]))
		rownames(rd) <- rownames(fromCoords)
		colnames(rd) <- rownames(toCoords) 
		fromCoordsCells <- cbind(fromCoords,raster.get.cell.from.xy(transition, fromCoords))
		toCoordsCells <- cbind(toCoords,raster.get.cell.from.xy(transition, toCoords))
		fromCells <- fromCoordsCells[,3][fromCoordsCells[,3] %in% transitionCells(transition)] 
		toCells <- toCoordsCells[,3][toCoordsCells[,3] %in% transitionCells(transition)] 
		uniqueCells <- unique(c(fromCells,toCells))
		if (length(fromCells) < length(fromCoordsCells[,1])) 
		{
			warning(length(fromCells)," out of ",length(fromCoordsCells[,1])," origin locations were found in the transition matrix. NAs introduced.")
		}
		else{}
		if (length(toCells) < length(toCoordsCells[,1])) 
		{
			warning(length(toCells)," out of ",length(toCoordsCells[,4])," destination locations were found in the transition matrix. NAs introduced.")
		}
		else{}
		cc <- .connected.components(transition)
		ccSubsetFrom <- subset(cc,cc[,1] %in% fromCells)
		ccSubsetTo <- subset(cc,cc[,1] %in% toCells)
		ccWithFromCoords <- which(tabulate(ccSubsetFrom[,2]) > 1)
		ccWithToCoords <- which(tabulate(ccSubsetTo[,2]) > 1)
		if(max(c(length(ccWithFromCoords),length(ccWithToCoords)))>1)
		{
			warning(max(c(length(ccWithFromCoords),length(ccWithToCoords))), " unconnected components; infinite distances introduced")
		}
		if(length(cbind(setdiff(ccWithFromCoords,ccWithToCoords),setdiff(ccWithToCoords,ccWithFromCoords))) > 0)
		{
			warning(length(cbind(setdiff(ccWithFromCoords,ccWithToCoords),setdiff(ccWithToCoords,ccWithFromCoords))), " component(s) with either only origin or destination locations; infinite distances introduced")
		}
		else{}
		ccWithCoords <- intersect(ccWithFromCoords,ccWithToCoords)
		if(length(ccWithCoords) <= 0)
		{
			return(rd)
		}
		else
		{
			for (i in 1:length(ccWithCoords))
			{
				subsetCells <- uniqueCells[uniqueCells %in% cc[,1][cc[,2] == ccWithCoords[i]]]
				tm <- transition@transitionmatrix[as.character(cc[,1][cc[,2]==ccWithCoords[i]]),as.character(cc[,1][cc[,2]==ccWithCoords[i]])]
				Lr <- .reducedLaplacian(tm,subsetCells)
				n <- max(L@Dim)
				Lstarplus <- matrix(ncol=1,nrow=length(subsetCells))
				Lplus <- matrix(ncol=length(subsetCells),nrow=length(subsetCells))
				index <- match(subsetCells,rownames(tm))
				for (i in 1:length(subsetCells))
				{
					ei <- matrix((-1/(n+1)), ncol=1, nrow=n)
					ei[index[i],] <- 1-(1/(n+1))
					xi <- solve(Lr,ei) 
					xi <- as.vector(xi)
					Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
					Lplus[,i] <- Lplusallrows[index]
				}
				rd.subset <- -2*Lplus + matrix(diag(Lplus),nrow=length(subsetCells),ncol=length(subsetCells)) + t(matrix(diag(Lplus),nrow=length(subsetCells),ncol=length(subsetCells)))
				index1 <- which(fromCoordsCells[,3] %in% subsetCells)
				index2 <- which(toCoordsCells[,3] %in% subsetCells)
				index3 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% subsetCells],subsetCells)
				index4 <- match(toCoordsCells[,3][toCoordsCells[,3] %in% subsetCells],subsetCells)
				rd[index1,index2] <- rd.subset[index3,index4]
			}	
			return(as.dist(rd))
		}
	}
)

setMethod("resistanceDistance", signature(transition = "Transition", fromCoords = "SpatialPoints", toCoords = "missing"), def = function(transition, fromCoords) 
	{
		fromCoords <- coordinates(fromCoords)
		transition <- .transitionSolidify(transition)
		transition <- .projectionCorrection(transition, type="resistance") 
		rd <- matrix(Inf,nrow=length(fromCoords[,1]),ncol=length(fromCoords[,1]))
		rownames(rd) <- rownames(fromCoords)
		colnames(rd) <- rownames(fromCoords)
		fromCoordsCells <- cbind(fromCoords, raster.get.cell.from.xy(transition, fromCoords))
		fromCells <- fromCoordsCells[,3][fromCoordsCells[,3] %in% transitionCells(transition)]
		if (length(fromCells) < length(fromCoordsCells[,4])) 
		{
			warning(length(fromCells[,1])," out of ",length(fromCoordsCells[,4])," locations were found in the transition matrix. NAs introduced.")
		}
		else{}
		cc <- .connected.components(transition)
		ccSubset <- subset(cc,cc[,1] %in% fromCells)
		ccWithFromCoords <- which(tabulate(ccSubset[,2])>1)
		if(length(which(tabulate(ccSubset[,2])>0)) > 1)
		{
			warning(length(which(tabulate(ccSubset[,2])>0)), " unconnected components; infinite distances introduced.")
		}
		else{}
		if(length(ccWithFromCoords)<=0)
		{
			warning("no connected components with more than one location")
			return(rd)
		}
		else
		{
			for (i in 1:length(ccWithFromCoords))
			{
				subsetCells <- unique(fromCells[,3][fromCells[,3] %in% cc[,1][cc[,2] == ccWithFromCoords[i]]])
				tm <- transition@transitionmatrix[as.character(cc[,1][cc[,2]==ccWithFromCoords[i]]),as.character(cc[,1][cc[,2]==ccWithFromCoords[i]])]
				Lr <- .reducedLaplacian(tm, subsetCells)
				n <- max(L@Dim)
				Lstarplus <- matrix(ncol=1,nrow=length(subsetCells))
				Lplus <- matrix(ncol=length(subsetCells),nrow=length(subsetCells))
				index <- match(subsetCells,rownames(tm))
				for (i in 1:length(subsetCells))
				{
					ei <- matrix((-1/(n+1)), ncol=1, nrow=n)
					ei[index[i],] <- 1-(1/(n+1))
					xi <- solve(L,ei) 
					xi <- as.vector(xi)
					Lplusallrows <- c(xi-sum(xi/(n+1)),(sum(xi)/(n+1)))
					Lplus[,i] <- Lplusallrows[index]
				}
				rd.subset <- -2*Lplus + matrix(diag(Lplus),nrow=length(subsetCells),ncol=length(subsetCells)) + t(matrix(diag(Lplus),nrow=length(subsetCells),ncol=length(subsetCells)))
				index1 <- which(fromCoordsCells[,3] %in% subsetCells)
				index2 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% subsetCells],subsetCells)
				rd[index1,index1] <- rd.subset[index2,index2]
			}	
			rd <- as.dist(rd)
			attr(rd, "method") <- "resistance"
			return(rd)
		}
	}
)