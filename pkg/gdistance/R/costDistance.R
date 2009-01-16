# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

#TODO check if coordinate systems are equal.
#TODO check if bounding box of coordinates falls inside bb of transition

setGeneric("costDistance", function(transition, fromCoords, toCoords) standardGeneric("costDistance"))

setMethod("costDistance", signature(transition = "Transition", fromCoords = "SpatialPoints", toCoords = "SpatialPoints"), def = function(transition, fromCoords, toCoords)
	{
		fromCoords <- coordinates(fromCoords)
		toCoords <- coordinates(toCoords)
		fromCoordsCells <- cbind(fromCoords, cellFromXY(transition, fromCoords))
		toCoordsCells <- cbind(toCoords, cellFromXY(transition, toCoords))
		costDist <- matrix(NA, nrow=length(fromCoords[,1]),ncol=length(toCoords[,1]))
		rownames(costDist) <- rownames(fromCoords)
		colnames(costDist) <- rownames(toCoords)
		adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode="undirected", weighted=TRUE)
		E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
		fromCells <- subset(fromCoordsCells[,3], fromCoordsCells[,3] %in% V(adjacencyGraph)$name)
		toCells <- subset(toCoordsCells[,3], toCoordsCells[,3] %in% V(adjacencyGraph)$name)
		if (length(fromCells) < length (fromCoordsCells[,1])) 
		{
			warning(length(fromCells), " out of ", length(fromCoordsCells[,1]), " origin locations were found in the transition matrix.")
		}
		else{}
		if (length(toCells) < length (toCoordsCells[,1])) 
		{
			warning(length(toCells), " out of ", length(toCoordsCells[,1]), " destination locations were found in the transition matrix.")
		}
		else{}
		uniqueFromCells <- unique(fromCells)
		uniqueToCells <- unique(toCells)		
		shortestPaths <- matrix(nrow=length(uniqueFromCells),ncol=length(uniqueToCells))
		index <- match(uniqueToCells,V(adjacencyGraph)$name)
		for (i in 1:length(uniqueFromCells))
		{
			shortestPaths[i,] <- shortest.paths(adjacencyGraph, match(uniqueFromCells[i],V(adjacencyGraph)$name))[,index]
		}
		index1 <- which(fromCoordsCells[,3] %in% fromCells)
		index2 <- which(toCoordsCells[,3] %in% toCells)
		index3 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% fromCells],uniqueFromCells)
		index4 <- match(toCoordsCells[,3][toCoordsCells[,3] %in% toCells],uniqueToCells)
		costDist[index1,index2] <- shortestPaths[index3,index4]
		costDist <- as.dist(costDist)
		return(costDist)
	}
)

setMethod("costDistance", signature(transition = "Transition", fromCoords = "SpatialPoints", toCoords = "missing"), def = function(transition, fromCoords)
	{
		fromCoords <- coordinates(fromCoords)
		fromCoordsCells <- cellFromXY(transition, fromCoords)
		costDist <- matrix(NA, nrow=length(fromCoords[,1]),ncol=length(fromCoords[,1]))
		rownames(costDist) <- rownames(Coords)
		colnames(costDist) <- rownames(Coords)
		adjacencyGraph <- graph.adjacency(transition@transitionmatrix, mode="undirected", weighted=TRUE)
		E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
		fromCells <- subset(fromCoordsCells[,3], fromCoordsCells[,3] %in% V(adjacencyGraph)$name)
		if (length(fromCells) < length (fromCoordsCells[,1])) 
		{
			warning(length(fromCells), " out of ", length(fromCoordsCells), " locations were found in the transition matrix.","\n")
		}
		else{}
		uniqueFromCells <- unique(fromCells)
		shortestPaths <- matrix(ncol=length(uniqueFromCells),nrow=length(uniqueFromCells))
		index <- match(uniqueFromCells,V(adjacencyGraph)$name)
		for (i in 1:length(uniqueFromCells))
		{
			shortestPaths[i,] <- shortest.paths(adjacencyGraph, match(uniqueFromCells[i],V(adjacencyGraph)$name))[,index]
		}

		index1 <- which(fromCoordsCells[,3] %in% fromCells)
		index2 <- match(fromCoordsCells[,3][fromCoordsCells[,3] %in% fromCells],uniqueFromCells)
		costDist[index1,index1] <- shortestPaths[index2,index2]
		costDist <- as.dist(costDist)
		return(costDist)
	}
)

