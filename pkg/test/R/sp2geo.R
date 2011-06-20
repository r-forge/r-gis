# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3



setAs('Spatial', 'VectorLayer', 
	function(from) { 
		if (inherits(from, 'SpatialPolygons')) {
			return( setAs(from, 'VectorLayerPolygons') )
		} else if (inherits(from, 'SpatialLines')) {
			return( setAs(from, 'VectorLayerLines') )	
		} else if (inherits(from, 'SpatialPoints')) {
			return( setAs(from, 'VectorLayerPoints') )		
		} else {
			stop('What kind of object is this?')
		}
	}
)


setAs('SpatialPolygons', 'VectorLayerPolygons', 
	function(from) { 
		geo <- .fromSpPolygons(from)
		geo@data = data.frame(id=1:nrow(geo@xy))
		return(geo)
	}
)

setAs('SpatialPolygonsDataFrame', 'VectorLayerPolygons', 
	function(from) { 
		geo <- .fromSpPolygons(from)
		geo@data <- from@data
		return(geo)
	}
)

setAs('SpatialLines', 'VectorLayerLines', 
	function(from) { 
		geo <- .fromSpLines(from)
		geo@data = data.frame(id=1:nrow(geo@xy))
		return(geo)
	}
)

setAs('SpatialLinesDataFrame', 'VectorLayerLines', 
	function(from) { 
		geo <- .fromSpLines(from)
		geo@data <- from@data
		return(geo)
	}
)


setAs('SpatialPoints', 'VectorLayerPoints', 
	function(from) { 
		geo <- .fromSpPoints(from)
		geo@data = data.frame(id=1:nrow(geo@xy))
		return(geo)
	}
)

setAs('SpatialPointsDataFrame', 'VectorLayerPoints', 
	function(from) { 
		geo <- .fromSpPoints(from)
		geo@data <- from@data
		return(geo)
	}
)


.fromSpPolygons	<- function(from) {
	p = from@polygons
	n = length(p)
	id = matrix(ncol=4, nrow=0)
	colnames(id) = c('id', 'part', 'first', 'last')
	xy = matrix(ncol=2, nrow=0)
	colnames(xy) = c('x', 'y')
	holes = matrix(ncol=2, nrow=0)
	colnames(holes) = c('id', 'part')
	last = 0
	for (i in 1:n) {
		parts = length(p[[i]]@Polygons)
		for (j in 1:parts) {
			crd = p[[i]]@Polygons[[j]]@coords
			nr = dim(crd)[1]
			id = rbind(id, cbind(i, j, last+1, last+nr))
			last=last+nr
			xy=rbind(xy, crd)
			if (p[[i]]@Polygons[[j]]@hole) {
				holes = rbind(holes, cbind(i, j))
			}
		}
	}
	geo = new('VectorLayerPolygons')
	geo@xy= xy
	geo@id = id
	geo@holes = holes
	return(geo)
}



.fromSpLines <- function(from) {
	p = from@lines
	n = length(p)
	id = matrix(ncol=4, nrow=0)
	colnames(id) = c('id', 'part', 'first', 'last')
	xy = matrix(ncol=2, nrow=0)
	colnames(xy) = c('x', 'y')
	last = 0
	for (i in 1:n) {
		parts = length(p[[i]]@Lines)
		for (j in 1:parts) {
			crd = p[[i]]@Lines[[j]]@coords
			nr = dim(crd)[1]
			id = rbind(id, cbind(i, j, last+1, last+nr))
			last=last+nr
			xy=rbind(xy, crd)
		}
	}
	geo = new('VectorLayerLines')
	geo@xy= xy
	geo@id = id
	return(geo)
}



.fromSpPoints <- function(from) {
	xy = coordinates(from)
	colnames(xy) = c('x', 'y')
	id = matrix(ncol=4, nrow=nrow(xy))
	colnames(id) = c('id', 'part', 'first', 'last')
	id[,c(1,3,4)] <- 1:nrow(id)
	id[,2] <- 1
	geo = new('VectorLayerPoints')
	geo@xy= xy
	geo@id = id
	return(geo)
}

