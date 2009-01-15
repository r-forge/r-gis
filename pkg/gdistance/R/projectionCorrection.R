# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version beta
# Licence GPL v3

projectionCorrection <- function(transition, type="resistance")
{
	if(isLatLon(transition)){}
	else{warning("projection not geographic; are you sure you want to do this?")}
	adjacency <- .adjacency.from.transition(transition)
	correction <- cbind(xyFromCell(transition,adjacency[,1]),xyFromCell(transition,adjacency[,2]))
	correctionDistance <- apply(correction,1,function(x){distanceGreatcircle(x[1:2],x[3:4])})
	if (type=="resistance")
	{
		rows <- rowFromCell(adjacency[,1]) != rowFromCell(adjacency[,2])
		correctionDistance[rows] <- (correctionDistance[rows] * cos((pi/180) * rowMeans(cbind(correction[rows,2],correction[rows,4])))) 
	}
	i <- as.vector(adjacency[,1])
	j <- as.vector(adjacency[,2])
	x <- as.vector(correctionDistance) 
	Dim <- ncells(transition)
	correctionMatrix <- new("dgTMatrix", i = as.integer(i), j = as.integer(j), x = as.numeric(x), Dim = as.integer(c(Dim,Dim)))
	correctionMatrix <- (as(correctionMatrix,"symmetricMatrix"))
	correctionMatrix <- (as(correctionMatrix,"dsCMatrix"))
	transitionCorrected <- correctionMatrix * as(transition, "dsCMatrix")
	transitionMatrix(transition) <- transitionCorrected
	return(transition)
}