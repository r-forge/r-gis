# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3

npieces <- function(x) {
	r = tapply(x@id[,2], x@id[,1], max)
	as.vector(as.matrix(r))
}


if (!isGeneric('piece')) {
	setGeneric('piece', function(x, i, j, ...)
		standardGeneric('piece')) 
}  


setMethod('piece', signature(x='VectorLayer', i='numeric', j='numeric'), 
function(x, i, j) {
	x <- getpiece(x, i[1])
	np = nrow(x@id)
	j = unique( pmin(pmax(1, j), np) )
	id = subset(x@id, x@id[,2] %in% j)
	rows = vector()
	for (k in 1:nrow(id)) {
		first = length(rows) + 1
		rows = c(rows, id[k,3]:id[k,4])
		id[k,c(1,3:4)] = c(k, first, length(rows))
	}
	x@id = id
	x@xy = x@xy[rows, ]
	return(x)
}
)

setMethod('piece', signature(x='VectorLayerPolygons', i='numeric', j='numeric'), 
function(x, i, j) {
	x <- getpiece(x, i[1])
	np = nrow(x@id)
	j = unique( pmin(pmax(1, j), np) )
	id = subset(x@id, x@id[,2] %in% j)
	rows = vector()
	for (k in 1:nrow(id)) {
		first = length(rows) + 1
		rows = c(rows, id[k,3]:id[k,4])
		id[k,c(1,3:4)] = c(k, first, length(rows))
	}
	x@id = id
	x@xy = x@xy[rows, ]
	return(x)
}
)

