# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setClass(Class="Transition",
		contains = "Raster",
		representation = representation(
			transitionMatrix = "dsCMatrix",
			transitionCells = "integer"
		),
		validity = function(object){
			cond1 <- isTRUE(all.equal(object@transitionMatrix@Dim[1], object@transitionMatrix@Dim[2]))
			cond2 <- (nrows(object) * ncols(object)) >= object@transitionMatrix@Dim[1]
			cond <- cond1 & cond2
			return(cond)
		}
)

setMethod ("show" , "Transition", 
		function(object) {
			cat("class     :" , class(object), "\n")
			cat("nrows     :" , object@nrows, "\n")
			cat("ncols     :" , object@ncols, "\n")
			cat("ncells    :" , object@nrows * object@ncols, "\n")
			cat("projection:" , object@crs, "\n")
			cat("xmin      :" , object@xmin, "\n")
			cat("xmax      :" , object@xmax, "\n")
			cat("ymin      :" , object@ymin, "\n")
			cat("ymax      :" , object@ymax, "\n")
			cat("xres      :" , object@ncols / (object@xmax - object@xmin) , "\n")
			cat("yres      :" , object@yrows / (object@ymax - object@ymin) , "\n")
			cat ("\n")
		}
)

setMethod ("initialize", "Transition",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax,projection)
		{
			ncells = as.integer(nrows*ncols)
			.Object@nrows <- as.integer(nrows)
			.Object@ncols <- as.integer(ncols)
			.Object@xmin <- xmin
			.Object@xmax <- xmax
			.Object@ymin <- ymin
			.Object@ymax <- ymax
			.Object@crs <- projection
			.Object@transitionMatrix@uplo <- "U"
			.Object@transitionMatrix@p <- as.integer(rep(0,ncells+1))
			.Object@transitionMatrix@i <- integer(0)
			.Object@transitionMatrix@Dim <- as.integer(c(ncells,ncells))
			.Object@transitionCells <- 1:ncells
			return(.Object)
		}
)

setAs("Transition", "dsCMatrix", function(from){from@transitionMatrix})

setAs("Transition", "RasterLayer", function(from)
	{
		newRaster(xmn=from@xmin, xmx=from@xmax, ymn=from@ymin, ymx=from@ymax, nrows=from@nrows, ncols=from@ncols, projstring=from@crs)
	}
)

setAs("RasterLayer", "Transition", function(from)
	{
		new("Transition",nrows=from@nrows,ncols=from@ncols,xmin=from@xmin,xmax=from@xmax,ymin=from@ymin,ymax=from@ymax,projstring=from@crs)
	}
)
	
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