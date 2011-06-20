# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3


setAs('VectorLayer', 'Spatial', 
	function(from) { 
		if (class(from) == 'VectorLayerPolygons') {
			return( setAs(from, 'SpatialPolygonsDataFrame') ) 
		} else if (class(from) == 'VectorLayerLines') {
			return( setAs(from, 'SpatialLinesDataFrame') ) 		
		} else if (class(from) == 'VectorLayerPoints') {
			return( setAs(from, 'SpatialPointsDataFrame') ) 		
		} else {
			stop('What kind of object is this?')
		}
	}
)


setAs('VectorLayerPolygons', 'SpatialPolygons', 
	function(from) { 
		return( .spFromGeoPolygons(from) )
	}
)

setAs('VectorLayerPolygons', 'SpatialPolygonsDataFrame', 
	function(from) { 
		return( SpatialPolygonsDataFrame( .spFromGeoPolygons(from), from@data ) )
	}
)

setAs('VectorLayerLines', 'SpatialLines', 
	function(from) { 
		return( .spFromGeoLines(from) )
	}
)

setAs('VectorLayerLines', 'SpatialLinesDataFrame', 
	function(from) { 
		return( SpatialLinesDataFrame( .spFromGeoLines(from), from@data ) )
	}
)


setAs('VectorLayerPoints', 'SpatialPoints', 
	function(from) { 
		return( SpatialPoints(from@xy) )
	}
)

setAs('VectorLayerPoints', 'SpatialPointsDataFrame', 
	function(from) { 
		sp <-  SpatialPoints(from@xy) 
		if (nrow(from@id) == max(from@id[,2])) {
			return( SpatialPointsDataFrame( sp, from@data ) )
		} else { # multi points
			data = cbind(data.frame(mergeid = 1:nrow(from@data), from@data) )
			df = merge(from@id[,1], data, by=1, sort=FALSE )[,-1]
			return( SpatialPointsDataFrame( sp, df ) )
		}
	}
)


.spFromGeoPolygons <- function(from) {
	np <- nparts(from)
	pols <- list()
	count  <- 1
	for (i in 1:np) {
		subp <- list()
		p <- part(from, i)
		npc <- npieces(p)
		for (j in 1:npc) {
			pp <- piece(p, 1, j)
			subp <- c(subp, Polygon( pp@xy ))
		}
		pols <- c(pols, Polygons( subp, as.character(count)) )
		count<- count + 1
	}
	if (nrow(from@holes) > 0) {
		for (i in 1:nrow(from@holes)) {
			pols[[ from@holes[i] ]]@Polygons[[ from@holes[j] ]]@hole <- TRUE
		}
	}
	return(SpatialPolygons( pols ))
}



.spFromGeoLines <- function(from) {
	np <- nparts(from)
	lines <- list()
	count  <- 1
	for (i in 1:np) {
		subp <- list()
		p <- part(from, i)
		npc <- npieces(p)
		for (j in 1:npc) {
			pp <- piece(p, 1, j)
			subp <- c(subp, Line( pp@xy ))
		}
		lines <- c(lines, Lines( subp, as.character(count) ) )
		count<- count + 1
	}
	return( SpatialLines( lines ) )
}



