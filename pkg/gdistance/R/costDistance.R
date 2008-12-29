#TODO check if coordinate systems are equal.
#TODO check if bounding box of coordinates falls inside bb of transition

setGeneric("costDistance", function(transition, fromCoords, toCoords) standardGeneric("costDistance"))

setMethod("costDistance", signature(transition = "transition", fromCoords = "SpatialPoints", toCoords = "SpatialPoints"), def = function(transition, fromCoords, toCoords)
	{
		xy.from <- coordinates(fromCoords)
		xy.to <- coordinates(toCoords)
		transition <- .projectionCorrection(transition, type="cost") 
		pointsofinterestin.from <- raster.get.cell.from.xy(transition, xy.from)
		pointsofinterestin.to <- raster.get.cell.from.xy(transition, xy.to)
		sh.dist <- matrix(NA, nrow=length(xy.from[,1]),ncol=length(xy.to[,1]))
		rownames(sh.dist) <- rownames(xy.from)
		colnames(sh.dist) <- rownames(xy.to)
		adj.graph <- graph.adjacency(transition@transitionmatrix, mode="undirected", weighted=TRUE)
		E(adj.graph)$weight <- 1/E(adj.graph)$weight
		pointsofinterest.from <- subset(pointsofinterestin.from, pointsofinterestin.from %in% V(adj.graph)$name)
		pointsofinterest.to <- subset(pointsofinterestin.to, pointsofinterestin.to %in% V(adj.graph)$name)
		if (length(pointsofinterest.from) < length (pointsofinterestin.from)) 
		{
			warning(length(pointsofinterest.from), " out of ", length(pointsofinterestin.from), " origin locations were found in the transition matrix.")
		}
		else{}
		if (length(pointsofinterest.to) < length (pointsofinterestin.to)) 
		{
			warning(length(pointsofinterest.to), " out of ", length(pointsofinterestin.to), " destination locations were found in the transition matrix.")
		}
		else{}
		#TODO pairs of origin-destination warning (like resistanceDistance)
		pointsofinterest.unique.from <- unique(pointsofinterest.from)
		pointsofinterest.unique.to <- unique(pointsofinterest.to)		
		sh.paths <- matrix(nrow=length(pointsofinterest.unique.from),ncol=length(pointsofinterest.unique.to))
		index <- match(pointsofinterest.unique.to,V(adj.graph)$name)
		for (i in 1:length(pointsofinterest.unique.from))
		{
			sh.paths[i,] <- shortest.paths(adj.graph, match(pointsofinterest.unique[i],V(adj.graph)$name))[,index]
		}
		index1 <- as.character(rownames(sh.dist)[pointsofinterestin.from %in% pointsofinterest.from])
		index2 <- as.character(colnames(sh.dist)[pointsofinterestin.to %in% pointsofinterest.to])
		index3 <- match(pointsofinterest.from,pointsofinterest.unique.from)
		index3 <- match(pointsofinterest.to,pointsofinterest.unique.to)
		sh.dist[index1,index2] <- sh.paths[index3,index4]
		return(as.dist(sh.dist))
	}
)

setMethod("costDistance", signature(transition = "transition", fromCoords = "SpatialPoints", toCoords = "missing"), def = function(transition, fromCoords)
	{
		xy <- coordinates(fromCoords)
		transition <- .projectionCorrection(transition, type="cost") 
		pointsofinterestin <- raster.get.cell.from.xy(transition, xy)
		sh.dist <- matrix(NA, nrow=length(xy[,1]),ncol=length(xy[,1]))
		rownames(sh.dist) <- rownames(xy)
		colnames(sh.dist) <- rownames(xy)
		adj.graph <- graph.adjacency(transition@transitionmatrix, mode="undirected", weighted=TRUE)
		E(adj.graph)$weight <- 1/E(adj.graph)$weight
		pointsofinterest <- subset(pointsofinterestin, pointsofinterestin %in% V(adj.graph)$name)
		if (length(pointsofinterest) < length (pointsofinterestin)) 
		{
			warning(length(pointsofinterest), " out of ", length(pointsofinterestin), " locations were found in the transition matrix.","\n")
		}
		else{}
		pointsofinterest.unique <- unique(pointsofinterest)
		sh.paths <- matrix(ncol=length(pointsofinterest.unique),nrow=length(pointsofinterest.unique))
		index <- match(pointsofinterest.unique,V(adj.graph)$name)
		for (i in 1:length(pointsofinterest.unique))
		{
			sh.paths[i,] <- shortest.paths(adj.graph, match(pointsofinterest.unique[i],V(adj.graph)$name))[,index]
		}
		index1 <- as.character(rownames(sh.dist)[pointsofinterestin %in% pointsofinterest])
		index2 <- match(pointsofinterest,pointsofinterest.unique)
		sh.dist[index1,index1] <- sh.paths[index2,index2]
		return(as.dist(sh.dist))
	}
)

