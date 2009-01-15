# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("transitionMatrix", function(transition, ...) standardGeneric("transitionMatrix"))

setReplaceMethod ("transitionMatrix", signature(transition = "Transition", dsCMatrix = "dsCMatrix"),
	function(transition, dsCMatrix){
		transition@transitionMatrix <- dsCMatrix
		return(transition)
	}
)

setMethod ("transitionMatrix", signature(transition = "Transition"),
	function(transition){
		transition@transitionMatrix
	}
)

setGeneric("transitionMatrix", function(transition, ...) standardGeneric("dsCMatrix.to.transition"))

setReplaceMethod ("transitionMatrix", signature(transition = "Transition", cellnumbers = "integer"),
	function(transition, cellnumbers){
		transition@transitionCells <- cellnumbers
		return(transition)
	}
)

setMethod ("transitionCells", signature(transition = "Transition"),
	function(transition){
		transition@transitionCells
	}
)