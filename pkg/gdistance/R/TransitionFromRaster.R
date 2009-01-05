# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

setGeneric("TransitionFromRaster", function(object, transition.function, outer.meridian.connect=TRUE, diagonal=FALSE) standardGeneric("transitionCreate"))

setMethod("TransitionFromRaster", signature(object = "raster"), def = function(object, transition.function, outer.meridian.connect, diagonal)
		{
			transition <- new("Transition",nrows=object@nrows,ncols=object@ncols,xmin=object@xmin,xmax=object@xmax,ymin=object@ymin,ymax=object@ymax)
			transition.dsC <- as(transition,"dsCMatrix")
			adj.str <- .adjacency.straight(object,outer.meridian.connect=outer.meridian.connect)
			transition.values.str <- apply(cbind(object@data[adj.str[,1]],object@data[adj.str[,2]]),1,transition.function)
			transition.dsC[adj.str] <- as.vector(transition.values.str)
			if (diagonal)
			{
				adj.diag <- .adjacency.diag(object,outer.meridian.connect=outer.meridian.connect)
				transition.values.diag <- apply(cbind(object@data[adj.diag[,1]],object@data[adj.diag[,2]]),1,transition.function)
				transition.dsC[adj.diag] <- as.vector(transition.values.diag*sqrt(2))
			}
			transition <- dsCMatrix.to.transition(transition.dsC,transition)
			return(transition)
		}
)

setMethod("TransitionFromRaster", signature(object = "rasterstack"), def = function(object, transition.function="mahal", outer.meridian.connect, diagonal)
		{
			if(transition.function != "mahal")
			{
				stop("only Mahalanobis distance method implemented for RasterStack")
			}
			adj <- .adjacency.straight(object@rasters[[1]],outer.meridian.connect=outer.meridian.connect)
			if(diagonal)
			{
				adj <- rbind(adj,.adjacency.diag(object@rasters[[1]],outer.meridian.connect=outer.meridian.connect))
			}
			x <- matrix(object@rasters[[1]]@data,ncol=1,nrow=object@ncells)
			rownames(x) <- as.character(1:object@ncells)
			for (i in 2:object@nrasters) 
			{
				x <- cbind(x,object@rasters[[i]]@data[as.integer(rownames(x))])
				x <- na.omit(x)
			}
			adj <- subset(adj, adj[,1] %in% as.integer(rownames(x)) & adj[,2] %in% as.integer(rownames(x)))
			x.minus.y <- x[as.character(adj[,1]),]-x[as.character(adj[,2]),]
			cov.inv <- solve(cov(x))
			mahaldistance <- apply(x.minus.y,1,function(x){sqrt((x%*%cov.inv)%*%x)})
			mahaldistance <- mean(mahaldistance)/(mahaldistance+mean(mahaldistance))
			transition.dsC <- new("dsCMatrix", 
					p = as.integer(rep(0,object@ncells+1)),
					Dim = as.integer(c(object@ncells,object@ncells)),
					Dimnames = list(as.character(1:object@ncells),as.character(1:object@ncells))
			)
			transition.dsC[adj] <- mahaldistance
			transition <- new("Transition",nrows=object@nrows,ncols=object@ncols,xmin=object@xmin,xmax=object@xmax,ymin=object@ymin,ymax=object@ymax)
			transition <- dsCMatrix.to.transition(transition.dsC,transition)
			return(transition)
		}
)