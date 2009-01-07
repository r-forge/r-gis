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
			c1 <- e1@transitionMatrix == e2@transitionMatrix
			#compare AbstractRaster
			stop("not implemented yet")
		}
)

setMethod("[", signature(x = "Transition", i="index", j="missing", drop="missing"),
		function(x,i){
			if (!all(i %in% x@index)){stop("wrong cell numbers")}
			else{}
			ind <- match(i,x@index)
			x@transitionMatrix <- x@transitionMatrix[ind,ind]
			x@transitionCells <- i
			return(e1)
		}
)

setMethod("[<-", signature(x = "Transition"),
		function(e1){
			stop("not implemented yet") #works with cellnumbers @index
		}
)



#Define for other Ops