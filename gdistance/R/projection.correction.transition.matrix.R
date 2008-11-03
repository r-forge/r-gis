`projection.correction.transition.matrix` <-
function(transition) 
{
adjacency <- adjacency.from.transition(transition)
correction <- matrix(NA, nrow=length(adjacency[,1]),ncol=3)
correction[,1:2] <- cbind(raster.get.row.from.cell(transition,adjacency[,1]),raster.get.row.from.cell(transition,adjacency[,2]))
lookup.table <- cbind(1/(cos((pi/180)*raster.get.y.from.row(transition,unique(correction[,1])))),cos((pi/180)*raster.get.y.from.row(transition,unique(correction[,1])+0.5)))
rownames(lookup.table) <- as.character(unique(correction[,1]))
lookup <- function(row,direction){lookup.table[as.character(row),direction]}
correction[,3][correction[,1]==correction[,2]] <- lookup(correction[,1][correction[,1]==correction[,2]],1)
correction[,3][correction[,1]!=correction[,2]] <- lookup(pmin(correction[,1][correction[,1]!=correction[,2]],correction[,2][correction[,1]!=correction[,2]]),2)
i <- as.vector(adjacency[,1])
j <- as.vector(adjacency[,2])
x <- as.vector(correction[,3]) 
Dim <- transition@ncells
correction.matrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim,Dim)))
correction.matrix <- (as(correction.matrix,"symmetricMatrix"))
correction.matrix <- (as(correction.matrix,"dsCMatrix"))
transition.corrected <- correction.matrix*as(transition, "dsCMatrix")
transition <- dsCMatrix.to.transition(transition.corrected,transition)
return(transition)
}

