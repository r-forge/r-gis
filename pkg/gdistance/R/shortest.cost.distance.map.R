shortest.cost.distance.map <- function(id.xy, transition)
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
	shpaths <- rep(Inf, times=length(rownames(transition@transitionmatrix)))	
	for (i in 1:length(pointsofinterest))
	{
		shpaths <- pmin(shpaths,shortest.paths(adj.graph, pointsofinterest[i]))
	}
	
	if(transition@zerorowcol == TRUE)
	{
		raster <- new("raster",
		projection = transition@projection,
		ncols = transition@ncols,
		nrows = transition@nrows,
		ncells = transition@ncells,
		xmin = transition@xmin,
		xmax = transition@xmax,
		ymin = transition@ymin,
		ymax = transition@ymax,
		xres = transition@xres,
		yres = transition@yres,
		raster@data <- colSums(as("dsCMatrix",transition)))
	}
	if(transition@zerorowcol == FALSE)
	{
		raster <- new("raster",
		projection = transition@projection,
		ncols = transition@ncols,
		nrows = transition@nrows,
		ncells = transition@ncells,
		xmin = transition@xmin,
		xmax = transition@xmax,
		ymin = transition@ymin,
		ymax = transition@ymax,
		xres = transition@xres,
		yres = transition@yres,
		data = as.array(rep(NA,times=transition@ncells))
	}

	datavector <- vector(length=length(raster@data))
	datavector[as.integer(rownames(transition@transitionmatrix))] <- shpaths
	raster@data <- as.array(datavector)
	return(raster)
}

