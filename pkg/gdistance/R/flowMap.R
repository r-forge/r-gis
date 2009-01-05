# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

flowMap <- function(originCoord,goalCoord,transition)
{
	originCell <- raster.get.cell.from.xy(transition, originCoord)
	goalCell <- raster.get.cell.from.xy(transition, goalCoord)
	L <- Laplacian(transition)
	Lr <- L[1:L@Dim[1]-1,1:L@Dim[2]-1]
	A <- as(L,"lMatrix")
	A <- as(A,"dMatrix")
	n <- max(Lr@Dim)
	indexGoal <- match(goalCell,transitionCells(transition))
	indexOrigin <- match(originCell,transitionCells(transition))
	Current <- .current(L, Lr, A, n, indexOrigin, indexGoal)
	result <- as(transition,"raster")
	datavector <- rep(NA,times=length(result@data))
	datavector[transitionCells(transition)] <- Current
	result@data <- as.array(datavector)
	return(result)
}