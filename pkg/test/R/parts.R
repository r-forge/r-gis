# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3

nparts <- function(x) {
	length(x)
}


if (!isGeneric('part')) {
	setGeneric('part', function(x, i, ...)
		standardGeneric('part')) 
}  


setMethod('part', signature(x='VectorLayer', i='numeric'), 
function(x, i) {
	np = length(x)
	i = unique(pmin(pmax(1, i), np))
	id = subset(x@id, x@id[,1] %in% i)
	rows = vector()
	for (j in 1:nrow(id)) {
		first = length(rows) + 1
		rows = c(rows, id[j,3]:id[j,4])
		id[j,c(1,3:4)] = c(j, first, length(rows))
	}
	x@id = id
	x@xy = x@xy[rows, ]
	x@data = x@data[i,]
	return(x)
}
)


setMethod('part', signature(x='VectorLayerPolygons', i='numeric'), 
function(x, i) {
	np = length(x)
	i = unique(pmin(pmax(1, i), np))
	id = subset(x@id, x@id[,1] %in% i)
	rows = vector()
	for (j in 1:nrow(id)) {
		first = length(rows) + 1
		rows = c(rows, id[j,3]:id[j,4])
		id[j,c(1,3:4)] = c(j, first, length(rows))
	}
	x@id = id
	x@xy = x@xy[rows, ]
	x@data = x@data[i,]
	if (length(x@holes) > 0) {
		x@holes = subset(x@holes, x@holes[,1] %in% i)
	}
	return(x)
}
)

