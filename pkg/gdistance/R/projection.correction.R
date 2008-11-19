projection.correction <- function(transition, type="resistance") 
{
	adjacency <- .adjacency.from.transition(transition)
	correction <- cbind(adjacency,get.xy.from.cell(adjacency[,1]),get.xy.from.cell(adjacency[,2]))
	correction.distance <- apply(correction,1,distance.great.circle.xy)
	if (type="resistance")
	{
		correction.distance[correction[,2] != correction[,4]] <- (correction.distance * cos((pi/180)* mean(c(correction[,2],correction[,4]))))[correction[,2] != correction[,4]]
	}
	i <- as.vector(adjacency[,1])
	j <- as.vector(adjacency[,2])
	x <- as.vector(correction.distance) 
	Dim <- transition@ncells
	correction.matrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim,Dim)))
	correction.matrix <- (as(correction.matrix,"symmetricMatrix"))
	correction.matrix <- (as(correction.matrix,"dsCMatrix"))
	transition.corrected <- correction.matrix*as(transition, "dsCMatrix")
	transition <- dsCMatrix.to.transition(transition.corrected,transition)
	return(transition)
}

