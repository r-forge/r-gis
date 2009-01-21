# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

costDistanceMap <- function(transition, fromCoords)
{
	fromCoords <- coordinates(fromCoords)
	fromCoordsCells <- cbind(fromCoords,cellFromXY(transition, fromCoords))
	adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode="undirected", weighted=TRUE)
	E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
	fromCells <- subset(fromCoordsCells, fromCoordsCells %in% transitionCells(transition))
	if (length(fromCells) < length (fromCoordsCells)) 
	{
		warning(length(fromCells), " out of ", length(fromCoordsCells[,1]), " locations were found in the transition matrix.","\n")
	}
	shortestPaths <- rep(Inf, times=length(transitionCells(transition)))	
	for (i in 1:length(fromCells))
	{
		shortestPaths <- pmin(shortestPaths,shortest.paths(adjacencyGraph, match(fromCells[i],transitionCells(transition))))
	}
	result <- as(transition, "RasterLayer")
	dataVector <- vector(length=ncells(result)) 
	dataVector[transitionCells(transition)] <- shortestPaths
	result <- setValues(result, dataVector)	
	return(result)
}

