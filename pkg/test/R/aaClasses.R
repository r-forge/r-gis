# R classes for vector type spatial data
# Robert J. Hijmans, r.hijmans@gmail.com
# March 2010
# Version 0.0
# Licence GPL v3


setClass('GeoVectorFile', 
	representation (
		name ='character',
		driver ='character'
		),
	prototype (	
	    name = '',
		driver = '' 
	),
	validity = function(object) {
		return(TRUE)
	}
)
		


setClass ('GeoVector', 
	contains = 'VIRTUAL', 
	representation (
		file = 'GeoVectorFile',
		id = 'matrix',
		crs = 'CRS',
		data = 'data.frame',
		xy  = 'matrix'
	),
	prototype (	
		crs = CRS(as.character(NA))
	),
	validity = function(object) {
		return(TRUE)
	}
)

setClass ('GeoPolygons', 
	contains = 'GeoVector', 
	representation (
		holes = 'matrix'
	), 
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}
)

setClass ('GeoLines', 
	contains = 'GeoVector', 
	representation (
	), 
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}
)

setClass ('GeoPoints', 
	contains = 'GeoVector', 
	representation (
	), 
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}
)
