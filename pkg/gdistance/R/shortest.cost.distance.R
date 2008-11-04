shortest.cost.distance <- function(id.xy, transition)
{
	pointsofinterestin <- raster.get.cell.from.xy(transition, id.xy[,2:3])
	
	#adjacency <- adjacency.from.transition(transition)
	#adj.graph <- graph.edgelist(cbind(as.character(adjacency[,1]),as.character(adjacency[,2])))
	
	adj.graph <- graph.adjacency(transition@transitionmatrix, mode="undirected", weighted=TRUE)
	
	pointsofinterest <- subset(pointsofinterestin, pointsofinterestin %in% V(adj.graph)$name)
	if (length(pointsofinterest) < length (pointsofinterestin)) 
	{
		warning(length(pointsofinterest), " out of ", length(pointsofinterestin), " locations were found in the transition matrix.","\n")
	}
	shpaths <- matrix(ncol=length(pointsofinterest),nrow=length(pointsofinterest))
	index <- match(pointsofinterest,V(adj.graph)$name)
	for (i in 1:length(pointsofinterest))
	{
		shpaths[i,] <- shortest.paths(adj.graph, pointsofinterest[i])[,index]
	}
	return(shpaths)
}

