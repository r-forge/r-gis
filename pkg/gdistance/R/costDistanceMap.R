# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

costDistanceMap <- function(transition, fromCoords)
{
	transition <- .projectionCorrection(transition, type="cost") 
	fromCoords <- coordinates(fromCoords)
	fromCoordsCells <- cbind(fromCoords,raster.get.cell.from.xy(transition, fromCoords))
	adjacencyGraph <- graph.adjacency(transitionMatrix(transition), mode="undirected", weighted=TRUE)
	E(adjacencyGraph)$weight <- 1/E(adjacencyGraph)$weight
	fromCells <- subset(fromCoordsCells, fromCoordsCells %in% V(adjacencyGraph)$name)
	if (length(fromCells) < length (fromCoordsCells)) 
	{
		warning(length(fromCells), " out of ", length(fromCoordsCells[,1]), " locations were found in the transition matrix.","\n")
	}
	shortestPaths <- rep(Inf, times=length(transitionCells(transition)))	
	for (i in 1:length(fromCells))
	{
		shortestPaths <- pmin(shortestPaths,shortest.paths(adjacencyGraph, match(fromCells[i],V(adjacencyGraph)$name)))
	}
	result <- as(transition, "RasterLayer")
	dataVector <- vector(length=ncells(result)) 
	dataVector[transitionCells(transition)] <- shortestPaths
	result <- setValues(result, dataVector)	
	return(result)
}

