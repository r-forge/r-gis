setGeneric("transition.solidify", function(transition) standardGeneric("transition.solidify"))

setMethod("transition.solidify", signature(transition = "transition"), def = function(transition)
	{
		transition.dsC <- as(transition,"dsCMatrix")
		selection <- which(rowSums(transition.dsC)>0)
		transition.dsC <- transition.dsC[selection,selection]
		transition <- dsCMatrix.to.transition(transition.dsC,transition)
		return(transition)
	}
)