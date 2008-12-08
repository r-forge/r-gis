.connected.components <- function(transition)
{
	adj.graph <- graph.adjacency(transition@transitionmatrix)
	clustermembership <- cbind(rownames(transition@transitionmatrix),clusters(adj.graph)$membership+1)
	return(clustermembership)
}

transition.connected.component <- function(transition, id.xy)
{
	adjacency <- .adjacency.from.transition(transition)
	pointsofinterestin <- raster.get.cell.from.xy(transition, id.xy[,2:3])
	adj.graph <- graph.edgelist(cbind(as.character(adjacency[,1]),as.character(adjacency[,2]))) #could also be done directly through forcing transitionmatrix into graph (graph.adjacency)
	pointsofinterest <- subset(pointsofinterestin, pointsofinterestin %in% V(adj.graph)$name)
	if (length(pointsofinterest) < length (pointsofinterestin)) 
	{
		warning(length(pointsofinterest), " out of ", length(pointsofinterestin), " locations were found in the adjacency matrix.","\n")
	}
	cl <- clusters(adj.graph)
	cluster.membership <- cbind(V(adj.graph)$name,cl$membership)
	grouping.pointsofinterest <- subset(cluster.membership, cluster.membership[,1] %in% pointsofinterest)
	setofcls <- unique(grouping.pointsofinterest[,2])
	select <- cbind(setofcls, tabulate(match(grouping.pointsofinterest[,2], setofcls)))
	select <- subset(select[,1],select[,2] == max(as.integer(select[,2])))
	selected.cells <- subset(cluster.membership[,1],cluster.membership[,2] == select)
	if (length(pointsofinterestin[pointsofinterestin %in% selected.cells]) < length(pointsofinterestin))
	{
		warning(length(pointsofinterestin[pointsofinterestin %in% selected.cells]), " out of ", length(pointsofinterestin)," locations were included in the selected connected component. ","\n")
	}
	
	transition.dsC <- as(transition,"dsCMatrix")
	transition.dsC <- transition.dsC[selected.cells,selected.cells]
	transition <- dsCMatrix.to.transition(transition.dsC,transition)
	return(transition)
}

