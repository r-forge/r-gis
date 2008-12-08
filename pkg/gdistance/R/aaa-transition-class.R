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
			transitionmatrix = "dsCMatrix"			
		),
		validity = function(object){
			cond1 <- isTRUE(all.equal(object@transitionmatrix@Dim[1], object@transitionmatrix@Dim[2]))
			cond2 <- object@ncells >= object@transitionmatrix@Dim[1]
			cond <- cond1 & cond2
			return(cond)
		}
)
