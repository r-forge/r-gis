setGeneric("transition.solidify", function(tm) standardGeneric("transition.solidify"))

setMethod("transition.solidify", signature(tm = "transition"), def = function(tm)
	{
		tm.dsC <- as(tm,"dsCMatrix")
		selection <- which(rowSums(tm.dsC)>0)
		tm.dsC <- tm.dsC[selection,selection]
		tm <- dsCMatrix.to.transition(tm.dsC,tm)
		tm@zerorowcol <- FALSE
		return(tm)
	}
) 

