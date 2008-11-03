setGeneric("transition.create", function(object, transition.function, outer.meridian.connect) standardGeneric("transition.create"))

setMethod("transition.create", signature(object = "Raster"), def = function(object, transition.function, outer.meridian.connect=FALSE)
		{
			transition <- new("transition",nrows=object@nrows,ncols=object@ncols,xmin=object@xmin,xmax=object@xmax,ymin=object@ymin,ymax=object@ymax)
			adj <- adjacency(object,outer.meridian.connect=outer.meridian.connect)
			transition.values <- apply(cbind(object@data[adj[,1]],object@data[adj[,2]]),1,transition.function)
			transition.dsC <- as(transition,"dsCMatrix")
			transition.dsC[adj] <- as.vector(transition.values)
			transition <- dsCMatrix.to.transition(transition.dsC,transition)
			return(transition)
		}
)

setMethod("transition.create", signature(object = "RasterStack"), def = function(object, transition.function, outer.meridian.connect=FALSE)
		{
			if(transition.function != "mahal"){warning("only mahalanobis distance method implemented for rasterstack; will use this method instead")}
			adj <- adjacency(object@rasters[[1]],outer.meridian.connect=outer.meridian.connect) 
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
			transition <- new("transition",nrows=object@nrows,ncols=object@ncols,xmin=object@xmin,xmax=object@xmax,ymin=object@ymin,ymax=object@ymax)
			transition <- dsCMatrix.to.transition(transition.dsC,transition)
			return(transition)
		}
)