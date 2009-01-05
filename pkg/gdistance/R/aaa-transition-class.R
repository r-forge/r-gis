# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

#TODO The whole thing needs to work with getters and setters from raster

setClass( #TODO replace with VirtualRaster from raster package eg eliminate
		Class="rasterchar",
		representation = representation(
				projection="character",
				ncols ="integer",
				nrows ="integer",
				ncells ="integer",
				xmin ="numeric",
				xmax ="numeric",
				ymin ="numeric",
				ymax ="numeric",		
				xres ="numeric",
				yres ="numeric"
		),
		validity = function(object)
		{
			cond1 <- isTRUE(all.equal(object@ncols*object@nrows, object@ncells))
			cond2 <- isTRUE(all.equal(object@xres,((object@xmax-object@xmin)/object@ncols)))
			cond3 <- isTRUE(all.equal(object@yres,((object@ymax-object@ymin)/object@nrows)))
			cond <- cond1 & cond2 & cond3
			return(cond)
		}
)

setClass(Class="Transition",
		contains = "rasterchar", #TODO change to virtual raster from raster package
		representation = representation(
			transitionMatrix = "dsCMatrix",
			transitionCells = "integer"
		),
		validity = function(object){
			cond1 <- isTRUE(all.equal(object@transitionMatrix@Dim[1], object@transitionMatrix@Dim[2]))
			cond2 <- object@ncells >= object@transitionMatrix@Dim[1]
			cond <- cond1 & cond2
			return(cond)
		}
)

setMethod ("show" , "Transition", 
		function(object) {
			cat("class     :" , class(object), "\n")
			cat("nrows     :" , object@nrows, "\n")
			cat("ncols     :" , object@ncols, "\n")
			cat("ncells    :" , object@ncells, "\n")
			cat("projection:" , object@projection, "\n")
			cat("xmin      :" , object@xmin, "\n")
			cat("xmax      :" , object@xmax, "\n")
			cat("ymin      :" , object@ymin, "\n")
			cat("ymax      :" , object@ymax, "\n")
			cat("xres      :" , object@xres, "\n")
			cat("yres      :" , object@yres, "\n")
			cat ("\n")
		}
)

setMethod ("initialize", "Transition",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax)
		{
			ncells = as.integer(nrows*ncols)
			.Object@nrows = as.integer(nrows)
			.Object@ncols = as.integer(ncols)
			.Object@ncells = as.integer(ncells) #TODO properties
			.Object@xmin = xmin
			.Object@xmax = xmax
			.Object@ymin = ymin
			.Object@ymax = ymax
			.Object@xres = (xmax-xmin)/ncols
			.Object@yres = (ymax-ymin)/nrows
			.Object@transitionMatrix@uplo = "U"
			.Object@transitionMatrix@p = as.integer(rep(0,ncells+1))
			.Object@transitionMatrix@i = integer(0)
			.Object@transitionMatrix@Dim = as.integer(c(ncells,ncells))
			.Object@transitionCells = 1:ncells
			return(.Object)
		}
)

setAs("Transition", "dsCMatrix", function(from){from@transitionMatrix})

setAs("Transition", "raster", function(from)
	{
		new("raster",
			projection = from@projection,
			ncols = from@ncols,
			nrows = from@nrows,
			ncells = from@ncells,
			xmin = from@xmin,
			xmax = from@xmax,
			ymin = from@ymin,
			ymax = from@ymax,
			xres = from@xres,
			yres = from@yres,
			data = as.array(rep(NA,times=from@ncells))
			)
	}
)
	
setGeneric("dsCMatrix.to.transition", function(dsCMatrix,transition) standardGeneric("dsCMatrix.to.transition"))

setMethod ("dsCMatrix.to.transition", signature(dsCMatrix = "dsCMatrix", transition = "Transition"),
	function(dsCMatrix,transition){
		transition@transitionMatrix <- dsCMatrix
		return(transition)
	}
)