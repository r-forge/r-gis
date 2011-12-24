# Author: Robert J. Hijmans
# Date : November 2011
# Version 1.0
# Licence GPL v3

if (!isGeneric("union")) {
	setGeneric("union", function(x, y)
		standardGeneric("union"))
}	

setMethod('union', signature(x='SpatialPolygons', y='SpatialPolygons'), 
function(x, y) {

	require(rgeos)

	x <- spChFIDs(x, as.character(1:length(row.names(x))))
	y <- spChFIDs(y, as.character(1:length(row.names(y))))

	if (! identical(projection(x), projection(y)) ) {
		warning('non identical CRS')
		y@proj4string <- x@proj4string
	}
	
	xdata <- .hasSlot(x, 'data')
	ydata <- .hasSlot(y, 'data')
	dat <- NULL
	if (xdata & ydata) {
		nms <- .goodNames(c(colnames(x@data), colnames(y@data)))
		colnames(x@data) <- xnames <- nms[1:ncol(x@data)]
		colnames(y@data) <- ynames <- nms[(ncol(x@data)+1):length(nms)]
		dat <- cbind(x@data[NULL, ,drop=FALSE], y@data[NULL, ,drop=FALSE])
	} else if (xdata) {
		dat <- x@data[NULL, ,drop=FALSE]
		xnames <- colnames(dat)
	} else if (ydata) {
		dat <- y@data[NULL, ,drop=FALSE]
		ynames <- colnames(dat)
	}
	
	subs <- gIntersects(x, y, byid=TRUE)
	if (any(subs)==0) {
		dat <- NULL
		xdata <- .hasSlot(x, 'data')
		ydata <- .hasSlot(y, 'data')

		yd <- aggregate(y)
		dif1 <- gDifference(x, yd, byid=TRUE)
		if (!is.null(dif1) & xdata) {
			ids <- as.numeric(sapply(row.names(dif1), function(x) strsplit(x, ' ')[[1]][1]))
			dat <- x@data[ids, ,drop=FALSE]
			row.names(dat) <- row.names(dif1)
			dif1 <- SpatialPolygonsDataFrame(dif1, dat)
		}

		xd <- aggregate(x)
		dif2 <- gDifference(y, xd, byid=TRUE)
		if (!is.null(dif2) & ydata) {
			ids <- sapply(row.names(dif2), function(x) strsplit(x, ' ')[[1]][1])
			dat <- y@data[ids, ,drop=FALSE]
			row.names(dat) <- row.names(dif2)
			dif2 <- SpatialPolygonsDataFrame(dif2, dat)
		}
		
		subsx <- apply(subs, 2, any)
		subsy <- apply(subs, 1, any)

		int  <- gIntersection(x[subsx,], y[subsy,], byid=TRUE)
		if (inherits(int, "SpatialCollections")) {
			if (is.null(int@polyobj)) { # ??
				warning('polygons do not intersect')
				return(NULL)
			}
			int <- int@polyobj
		}
		if (!inherits(int, 'SpatialPolygons')) {
			warning('polygons do not intersect')
			return(NULL)
		}


		if (!is.null(dat)) {
			ids <- do.call(rbind, strsplit(row.names(int), ' '))
			rows <- 1:length(ids[,1])
			if (xdata) {
				idsx <- match(ids[,1], rownames(x@data))
				dat[rows, xnames] <- x@data[idsx, ]
			} 
			if (ydata) {
				idsy <- match(ids[,2], rownames(y@data))
				dat[rows, ynames] <- y@data[idsy, ]
			}
			rownames(dat) <- 1:nrow(dat)
			int <- spChFIDs(int, as.character(1:nrow(dat)))
			int <- SpatialPolygonsDataFrame(int, dat)
		}
		
		if (!is.null(dif1) | !is.null(dif2)) {
			x <- .appendPolygons(dif1, int, dif2) 
		} else {
			x <- int
		}
	} else {
		x <- .appendPolygons(x, y)
	}
	x	
}
)

