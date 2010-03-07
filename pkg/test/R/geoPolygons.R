# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febraruy 2010
# Version 0.0
# Licence GPL v3


if (!isGeneric("geoPolygons")) {
	setGeneric("geoPolygons", function(x, d, ...)
		standardGeneric("geoPolygons"))
}	

setMethod('geoPolygons', signature(x='list', d='missing'), 
	function(x, ...) {
		geoPolygons(x, d=data.frame(id=1:length(x)) )
	}
)

setMethod('geoPolygons', signature(x='list', d='data.frame'), 
	function(x, d, holes) {
		n = length(x)
		if (n != nrow(d)) { stop('number of records does not match number of parts') }
		
		id = matrix(ncol=4, nrow=0)
		colnames(id) = c('id', 'part', 'first', 'last')
		
		xy = matrix(ncol=2, nrow=0)
		colnames(xy) = c('x', 'y')
		holes = matrix(ncol=2, nrow=0)
		colnames(holes) = c('id', 'part')
		last = 0
		for (i in 1:n) {
			parts = x[[i]]
			if (class(parts) == 'list') {
				for (j in 1:length(parts)) {
					crd = na.omit(parts[[j]])
					nr = dim(crd)[1]
					id = rbind(id, cbind(i, j, last+1, last+nr))
					last=last+nr
					xy=rbind(xy, crd)
				}
			} else {
				crd <- na.omit(parts)
				nr = dim(crd)[1]
				id = rbind(id, cbind(i, j, last+1, last+nr))
				last=last+nr
				xy=rbind(xy, crd)
			}
		}
		geo = new('GeoPolygons')
		geo@xy = xy
		geo@id = id
		if (!missing(holes)) {
			geo@holes = holes  # check if exist
		}
		return(geo)
	}
)
