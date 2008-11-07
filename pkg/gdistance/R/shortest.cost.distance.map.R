shortest.cost.distance.map <- function(id.xy, transition)
{
	pointsofinterestin <- raster.get.cell.from.xy(transition, id.xy[,2:3])
	
	#adjacency <- adjacency.from.transition(transition)
	#adj.graph <- graph.edgelist(cbind(as.character(adjacency[,1]),as.character(adjacency[,2])))
	
	adj.graph <- graph.adjacency(transition@transitionmatrix, mode="undirected", weighted=TRUE)
	E(adj.graph)$weight <- 1/E(adj.graph)$weight
	
	pointsofinterest <- subset(pointsofinterestin, pointsofinterestin %in% V(adj.graph)$name)
	if (length(pointsofinterest) < length (pointsofinterestin)) 
	{
		warning(length(pointsofinterest), " out of ", length(pointsofinterestin), " locations were found in the transition matrix.","\n")
	}
	shpaths <- rep(Inf, times=length(rownames(transition@transitionmatrix)))	
	for (i in 1:length(pointsofinterest))
	{
		shpaths <- pmin(shpaths,shortest.paths(adj.graph, match(pointsofinterest[i],V(adj.graph)$name)))
	}
	
	raster <- as(transition, "raster")
	datavector <- vector(length=length(raster@data))
	datavector[as.integer(rownames(transition@transitionmatrix))] <- shpaths
	raster@data <- as.array(datavector)
	return(raster)
}

