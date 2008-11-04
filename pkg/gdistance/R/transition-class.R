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
