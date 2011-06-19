# R classes for vector type data
# Robert J. Hijmans, r.hijmans@gmail.com
# March 2010
# Version 0.0
# Licence GPL v3


setClass('.GeoSpatial', 
	contains = 'VIRTUAL', 
)
	
setClass('.GeoSpatialShape', 
	contains = '.GeoSpatial',
	representation (
		code = 'integer',
		length = 'integer',
		version = 'integer',
		type = 'integer',
		xmin = 'numeric',
		xmax = 'numeric',
		ymin = 'numeric',
		ymax = 'numeric',
		zmin = 'numeric',
		zmax = 'numeric',
		mmin = 'numeric',
		mmax = 'numeric',
		nrecords = 'integer',
		index = 'matrix'
	),
	prototype (	
		zmin = -Inf,
		zmax = -Inf,
		mmin = -Inf,
		mmax = -Inf,
		nrecords = as.integer(-1)
	)
)


setClass('.GeoAttributes',
	contains = 'VIRTUAL', 
	representation (
		nrecords = 'integer',
		nfields = 'integer',
		fields = 'data.frame'
	)	
)

setClass('.GeoAttributesDBF', 
	contains = '.GeoAttributes', 
	representation (
		file.version = 'integer',
		file.date = 'character',
		header.length = 'integer',
		record.length = 'integer'
	)	
)

		
		

setClass ('VectorLayer', 
	contains = 'VIRTUAL', 
	representation (
		file = 'character',
		driver = 'character',
		vec = '.GeoSpatial',
		att = '.GeoAttributes',
		nrecords = 'integer',
		crs = 'CRS',
		data = 'data.frame',
		xy  = 'matrix'
	),
	prototype (	
		file = '',
		nrecords = as.integer(-1),
		crs = CRS(as.character(NA))
	),
	validity = function(object) {
		return(TRUE)
	}
)


setClass ('VectorLayerPolygons', 
	contains = 'VectorLayer', 
	representation (
		holes = 'matrix'
	), 
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}
)

setClass ('VectorLayerLines', 
	contains = 'VectorLayer', 
	representation (
	), 
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}
)

setClass ('VectorLayerPoints', 
	contains = 'VectorLayer', 
	representation (
	), 
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}
)


setMethod ('show' , 'VectorLayer', 
	function(object) {
		cat('class       :' , class(object), '\n')
		cat('filename    :' , object@file, '\n')
		cat('nrecords    :' , object@nrecords, '\n')
		cat('nfields     :' , object@att@nfields, '\n')
		cat('coord. ref. :' , projection(object, TRUE), '\n')
	}
)	


setMethod('dimnames', signature(x='VectorLayer'), 
function(x) { 
		return(list(NULL, x@att@fields$NAME)) 
	} 
)


setMethod('dimnames', signature(x='SpatialPolygonsDataFrame'), 
function(x) { 
		dimnames(x@data)
	} 
)
