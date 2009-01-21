# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("transitionMatrix", function(transition) standardGeneric("transitionMatrix"))

setMethod ("transitionMatrix", signature(transition = "Transition"),
	function(transition){
		transition@transitionMatrix
	}
)

setGeneric("transitionMatrix<-", function(transition, value) standardGeneric("transitionMatrix<-"))

setReplaceMethod ("transitionMatrix", signature(transition = "Transition", value = "dsCMatrix"),
	function(transition, value){
		#if(dim(transitionMatrix(transtion) != dim(sparseMatrix)){warning(unequal dimensions)}
		transition@transitionMatrix <- value
		return(transition)
	}
)

setGeneric("transitionCells", function(transition = "Transition") standardGeneric("transitionCells"))

setMethod ("transitionCells", signature(transition = "Transition"),
	function(transition){
		transition@transitionCells
	}
)

setMethod("[", signature(x = "Transition", i="index", j="missing", drop="missing"),
		function(x,i){
			i <- as.integer(i)
			x <- subs(x,i)
			return(x)
		}
)

subs <- function(x,i)
{
if (!all(i %in% x@transitionCells) && !all(-i %in% x@transitionCells)){stop("wrong cell numbers")}
else
	{
		if (all(i %in% x@transitionCells))
		{
			ind <- match(i,x@transitionCells)
			tm <- as(x,"dsCMatrix")
			x@transitionMatrix <- tm[ind,ind]
			x@transitionCells <- i
		}
		if (all(-i %in% x@transitionCells))
		{
			ind <- match(-i,x@transitionCells)
			tm <- as(x,"dsCMatrix")
			x@transitionMatrix <- tm[-ind,-ind]
			x@transitionCells <- x@transitionCells[!(x@transitionCells %in% -i)]
		}
	}
return(x)
}

setMethod("[<-", signature(x = "Transition", i="index", j="missing", value="ANY"),
		function(x, i, value){
			if (!all(i %in% x@transitionCells) && !all(-i %in% x@transitionCells)){stop("wrong cell numbers")}
			else
			{
				if (!all(i %in% x@transitionCells))
				{
					ind <- match(i,x@transitionCells)
					tm <- as(x,"dsCMatrix")
					tm[ind,ind] <- value
					x@transitionMatrix <- tm
				}
				if (!all(-i %in% x@transitionCells))
				{
					ind <- match(-i,x@transitionCells)
					tm <- as(x,"dsCMatrix")
					tm[-ind,-ind] <- value
					x@transitionMatrix <- tm
				}
			}
			return(x)
		}
)