# Author: Robert J. Hijmans
# Date : November 2011
# Version 1.0
# Licence GPL v3


setMethod('crop', signature(x='SpatialPolygons', y='ANY'), 
	function(x, y, ...) {

		if (! inherits(y, 'SpatialPolygons')) {
			if (inherits(y, 'Extent')) {
				y <- as(y, 'SpatialPolygons')
				y@proj4string <- x@proj4string
			} else { 
				y <- extent(y)
				validObject(y)
				y <- as(y, 'SpatialPolygons')
			}
			y@proj4string <- x@proj4string		
		}
		if (version_GEOS0() < "3.3.0") {
			y <- gUnionCascaded(y)
		} else {
			y <- gUnaryUnion(y)
		}	
		row.names(y) <- '1'
		rnx <- row.names(x)
		row.names(x) <- as.character(1:length(rnx))

		if (! identical(projection(x), projection(y)) ) {
			warning('non identical CRS')
			y@proj4string <- x@proj4string
		}
		
		
		if (.hasSlot(x, 'data')) {
			
			# to keep the correct IDs
			# in future versions of rgeos, this intermediate step won't be necessary
			i <- as.vector( gIntersects(x, y, byid=TRUE) )
			if (sum(i) == 0) {
				return(NULL)
			}
			y <- gIntersection(x[i,], y, byid=TRUE)
			if (inherits(y, "SpatialCollections")) {
				y <- y@polyobj
			}
			if (is.null(y)) { return(y) }
			
			ids <- strsplit(row.names(y), ' ') 
			ids <- as.numeric(do.call(rbind, ids)[,1])
			row.names(y) <- as.character(rnx[ids])
			data <- x@data[ids, ,drop=FALSE]
			rownames(data) <- rnx[ids]
			
			return( SpatialPolygonsDataFrame(y, data) )
		} else {
			y <- gIntersection(x, y)
			if (inherits(y, "SpatialCollections")) {
				y <- y@polyobj
			}
			return(y)
		}
	}
)


setMethod('crop', signature(x='SpatialLines', y='ANY'),
	function(x, y, ...) {
	
		if (! inherits(y, 'SpatialPolygons')) {
			if (inherits(y, 'Extent')) {
				y <- as(y, 'SpatialPolygons')
			} else { 
				y <- as(extent(y), 'SpatialPolygons')
			}
			y@proj4string <- x@proj4string		
		}
		
		if (.hasSlot(x, 'data')) {
		
			# in future versions of rgeos, this intermediate step should not be necessary
			i <- as.vector( gIntersects(x, y, byid=TRUE) )
			if (sum(i) == 0) {
				return(NULL)
			}
			y <- gIntersection(x[i,], y, byid=TRUE)
			if (inherits(y, "SpatialCollections")) {
				y <- y@lineobj
			}
			
			ids <- strsplit(row.names(y), ' ') 
			ids <- as.numeric(do.call(rbind, ids)[,1])
			row.names(y) <- as.character(rnx[ids])
			data <- x@data[ids, ,drop=FALSE]
			rownames(data) <- rnx[ids]
			
			SpatialLinesDataFrame(y, data)
		} else {
			y <- gIntersection(x, y)
			if (inherits(y, "SpatialCollections")) {
				y <- y@lineyobj
			}
			return(y)
		}
	}
)


setMethod('crop', signature(x='SpatialPoints', y='ANY'),
	function(x, y, ...) {
		if (! inherits(y, 'SpatialPolygons')) {
			if (inherits(y, 'Extent')) {
				y <- as(y, 'SpatialPolygons')
			} else { 
				y <- as(extent(y), 'SpatialPolygons')
			}
			y@proj4string <- x@proj4string		
		}

		i <- which(!is.na(over(x, y)))
		if (length(i) > 0) {
			x <- x[i,]
		} else {
			x <- NULL
		}
		x
	}
)

