# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setMethod("Arith", signature(e1 = "Transition", e2 = "Transition"),
		function(e1, e2){
			if(1==1) #(as(e1,"virtualRaster") == as(e2,"virtualRaster"))  but first define Compare in raster
				{
					return(dsCMatrix.to.transition(callGeneric(as(e1,"dsCMatrix"),as(e2,"dsCMatrix")),e1))
				}
			else {stop("transition matrices do not coincide in resolution and extent")}
		}
)

setMethod("Compare", signature(e1 = "Transition", e2 = "Transition"),
		function(e1, e2){
			stop("not implemented yet")
		}
)

setMethod("[", signature(e1 = "Transition", e2="integer"),
		function(e1){
			stop("not implemented yet") #works with cellnumbers @index
			e2 <- match(e2,e1@index)
			e1@transitionMatrix <- e1@transitionMatrix[e2,e2]
			e1@transitionCells <- e2
			return(e1)
		}
)

setMethod("[<-", signature(e1 = "Transition"),
		function(e1){
			stop("not implemented yet") #works with cellnumbers @index
		}
)



#Define for other Ops