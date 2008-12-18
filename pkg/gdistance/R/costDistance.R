costDistance <- function(id.xy, transition)
{
	pointsofinterestin <- raster.get.cell.from.xy(transition, id.xy[,2:3])
	
	sh.dist <- matrix(NA, nrow=length(id.xy[,1]),ncol=length(id.xy[,1]))
	
	rownames(sh.dist) <- as.character(id.xy[,1])
	colnames(sh.dist) <- as.character(id.xy[,1])
	
	#adjacency <- adjacency.from.transition(transition)
	#adj.graph <- graph.edgelist(cbind(as.character(adjacency[,1]),as.character(adjacency[,2])))
	
	adj.graph <- graph.adjacency(transition@transitionmatrix, mode="undirected", weighted=TRUE)
	E(adj.graph)$weight <- 1/E(adj.graph)$weight
	
	pointsofinterest <- subset(pointsofinterestin, pointsofinterestin %in% V(adj.graph)$name)
	if (length(pointsofinterest) < length (pointsofinterestin)) 
	{
		warning(length(pointsofinterest), " out of ", length(pointsofinterestin), " locations were found in the transition matrix.","\n")
	}
	pointsofinterest.unique <- unique(pointsofinterest)
	shpaths <- matrix(ncol=length(pointsofinterest.unique),nrow=length(pointsofinterest.unique))
	index <- match(pointsofinterest.unique,V(adj.graph)$name)
	for (i in 1:length(pointsofinterest.unique))
	{
		shpaths[i,] <- shortest.paths(adj.graph, match(pointsofinterest.unique[i],V(adj.graph)$name))[,index]
	}

	index1 <- as.character(rownames(sh.dist)[pointsofinterestin %in% pointsofinterest])
	index2 <- match(pointsofinterest,pointsofinterest.unique)
	
	sh.dist[index1,index1] <- shpaths[index2,index2]
	
	return(as.dist(sh.dist))
}

