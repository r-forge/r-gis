`projection.correction.adjacency` <-
function(raster, adjacency) 
{
correction <- matrix(NA, nrow=length(adjacency[,1]),ncol=3)
correction[,1:2] <- cbind(raster.get.row.from.cell(raster,adjacency[,1]),raster.get.row.from.cell(raster,adjacency[,2]))
lookup.table <- cbind(1/(cos((pi/180)*raster.get.y.from.row(raster,unique(correction[,1])))),cos((pi/180)*raster.get.y.from.row(raster,unique(correction[,1])+0.5)))
rownames(lookup.table) <- as.character(unique(correction[,1]))
lookup <- function(row,direction){lookup.table[as.character(row),direction]}
correction[,3][correction[,1]==correction[,2]] <- lookup(correction[,1][correction[,1]==correction[,2]],1)
correction[,3][correction[,1]!=correction[,2]] <- lookup(pmin(correction[,1][correction[,1]!=correction[,2]],correction[,2][correction[,1]!=correction[,2]]),2)
adjacency.pc <- cbind(adjacency,correction[,3])
return(adjacency.pc)
}

