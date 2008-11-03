setClass(
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

setClass(Class="transition",
		contains = "rasterchar",
		representation = representation(
			zerorowcol = "logical",
			transitionmatrix = "dsCMatrix"
		),
		validity = function(object){
			if(object@zerorowcol == TRUE)
			{
				cond <- isTRUE(all.equal(as.integer(object@ncells), object@transitionmatrix@Dim[1], object@transitionmatrix@Dim[2])) #ncells will become floating point when classes are fully integrated in raster... 
			}
			if (object@zerorowcol == FALSE)
			{
				cond1 <- isTRUE(all.equal(object@transitionmatrix@Dim[1], object@transitionmatrix@Dim[2]))
				cond2 <- object@ncells >= object@transitionmatrix@Dim[1]
				cond <- cond1 & cond2
			}
			return(cond)
		}
)


setMethod ("show" , "transition", 
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

setMethod ("initialize", "transition",
		function(.Object,nrows,ncols,xmin,xmax,ymin,ymax)
		{
			ncells = as.integer(nrows*ncols)
			.Object@zerorowcol = TRUE
			.Object@nrows = as.integer(nrows)
			.Object@ncols = as.integer(ncols)
			.Object@ncells = as.integer(ncells)
			.Object@xmin = xmin
			.Object@xmax = xmax
			.Object@ymin = ymin
			.Object@ymax = ymax
			.Object@xres = (xmax-xmin)/ncols
			.Object@yres = (ymax-ymin)/nrows
			.Object@transitionmatrix@uplo = "U"
			.Object@transitionmatrix@p = as.integer(rep(0,ncells+1))
			.Object@transitionmatrix@i = integer(0)
			.Object@transitionmatrix@Dim = as.integer(c(ncells,ncells))
			.Object@transitionmatrix@Dimnames = list(as.character(1:ncells),as.character(1:ncells))
			return(.Object)
		}
)

setAs("transition", "dsCMatrix", function(from){from@transitionmatrix})

setGeneric("dsCMatrix.to.transition", function(dsCMatrix,transition) standardGeneric("dsCMatrix.to.transition"))

setMethod ("dsCMatrix.to.transition", signature(dsCMatrix = "dsCMatrix", transition = "transition"),
	function(dsCMatrix,transition){
		transition@transitionmatrix <- dsCMatrix
		return(transition)
	}
)

setMethod("Arith", signature(e1 = "transition", e2 = "transition"),
		function(e1, e2){
			if(
				isTRUE(all.equal(e1@nrows,e2@nrows)) &
				isTRUE(all.equal(e1@ncols, e2@ncols)) &
				isTRUE(all.equal(e1@ncells, e2@ncells)) &
				isTRUE(all.equal(e1@projection, e2@projection)) &
				isTRUE(all.equal(e1@xmin, e2@xmin)) &
				isTRUE(all.equal(e1@xmax, e2@xmax)) &
				isTRUE(all.equal(e1@ymin, e2@ymin)) &
				isTRUE(all.equal(e1@ymax, e2@ymax)) &
				isTRUE(all.equal(e1@xres, e2@xres)) &
				isTRUE(all.equal(e1@yres, e2@yres)))
				{
					return(dsCMatrix.to.transition(callGeneric(as(e1,"dsCMatrix"),as(e2,"dsCMatrix")),e1))
				}
			else {stop("transition matrices do not coincide in resolution and extent")}
		}
)

setMethod("Ops", signature(e1 = "transition", e2 = "transition"),
		function(e1, e2){
			if(
				isTRUE(all.equal(e1@nrows,e2@nrows)) &
				isTRUE(all.equal(e1@ncols, e2@ncols)) &
				isTRUE(all.equal(e1@ncells, e2@ncells)) &
				isTRUE(all.equal(e1@projection, e2@projection)) &
				isTRUE(all.equal(e1@xmin, e2@xmin)) &
				isTRUE(all.equal(e1@xmax, e2@xmax)) &
				isTRUE(all.equal(e1@ymin, e2@ymin)) &
				isTRUE(all.equal(e1@ymax, e2@ymax)) &
				isTRUE(all.equal(e1@xres, e2@xres)) &
				isTRUE(all.equal(e1@yres, e2@yres)))
				{
					return(dsCMatrix.to.transition(callGeneric(as(e1,"dsCMatrix"),as(e2,"dsCMatrix")),e1))
				}
			else {stop("transition matrices do not coincide in resolution and extent")}
		}
)
