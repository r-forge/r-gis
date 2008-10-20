# R classes for spatial data (raster data specifically) 
# Authors: Robert J. Hijmans and Jacob van Etten
# International Rice Research Institute
# contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,3
# Licence GPL v3

setClass('BoundingBox', 
	representation (
		projection='CRS',
		xmin ='numeric',
		xmax ='numeric',
		ymin ='numeric',
		ymax ='numeric'
		),
	prototype (	
		projection= new('CRS')
	),	
	validity = function(object)
	{
		cond1 <- object@xmin < object@xmax
		cond2 <- object@ymin < object@ymax
		#using the projection, additional conditions could be created...
		cond <- cond1 & cond2
		return(cond)
	}
)

	
setClass ('AbstractRaster',
	contains = 'BoundingBox',
	representation (
		ncols ='integer',
		nrows ='integer',
		ncells ='numeric',
		xres ='numeric',
		yres ='numeric'
		),
	validity = function(object)
	{
		cond1 <- isTRUE(all.equal(as.numeric(object@ncols)*object@nrows, object@ncells))
		#cond2 <- isTRUE(all.equal(object@xres,((object@xmax-object@xmin)/object@ncols))) 
		#TODO 0.1 perc margin? Or just a warning when resolution is wrong?
		#cond3 <- isTRUE(all.equal(object@yres,((object@ymax-object@ymin)/object@nrows))) 
		#TODO 0.1 perc margin? Or just a warning when resolution is wrong?
		cond <- cond1 #& cond2 & cond3
		return(cond)
	}
)
	
	
setClass('RasterFile', 
	representation (
		name ='character',
		shortname ='character', # short name
		driver ='character', #gdal, raster
		gdalhandle='list',
		datatype ='character', #'numeric' or 'integer'
		datasize ='integer',
		datasigned='logical',
		datanotation='character',
		byteorder ='character',
		nodatavalue ='numeric', # on disk, in ram it is NA
		nbands ='integer',
		band = 'integer',
		bandorder ='character'
		),
	prototype (	
	    name = '',
		shortname ='',
		driver = 'raster',
		gdalhandle= list(),
		datatype = 'numeric',
		datasize = as.integer(4),
		datasigned= TRUE,
		datanotation='FLT4S',
		byteorder = .Platform$endian,
		nodatavalue = -9999,
		nbands = as.integer(1),
		band = as.integer(1),
		bandorder = 'BSQ'
	),
	validity = function(object)
	{
	}
)	


setClass('RasterData', 
	representation (
		values='vector', 
		content='character', #nodata, all, row, block, sparse
		indices = 'vector',
		haveminmax = 'logical',
		min ='numeric',
		max ='numeric',
		source='character' # RAM, disk
		),
	prototype (	
		values=vector(),
		content='nodata', 
		indices =vector(mode='numeric'),
		haveminmax = FALSE,
		min = numeric(1),
		max = numeric(1),
		source='RAM'
	),	
	validity = function(object)
	{
	}
)

	
setClass ('Raster',
	contains = 'AbstractRaster',
	representation (
		title = 'character',
		file = 'RasterFile',
		data = 'RasterData',
		history = 'vector'
		),
	prototype (
		history = vector(mode='character')
		)
	)
	
		
setMethod ('show' , 'Raster', 
	function(object) {
		cat('class     :' , class(object), '\n')
		cat('filename  :' , object@file@name, '\n')
		if (object@file@nbands > 1) {
			cat('nbands    :' , object@file@nbands, '\n')
			cat('band      :' , object@file@band, '\n')
		}	
		cat('nrows     :' , object@nrows, '\n')
		cat('ncols     :' , object@ncols, '\n')
		cat('ncells    :' , object@ncells, '\n')
		cat('datatype  :' , object@file@datanotation, '\n')
		if (object@data@haveminmax) {
			cat('min value :' , object@data@min, '\n')
			cat('max value :' , object@data@max, '\n')
			}
		else {
			cat('min value : NA \n')
			cat('max value : NA \n')
			}
		cat('projection:' , object@projection@projargs, '\n')
		cat('xmin      :' , object@xmin, '\n')
		cat('xmax      :' , object@xmax, '\n')
		cat('ymin      :' , object@ymin, '\n')
		cat('ymax      :' , object@ymax, '\n')
		cat('xres      :' , object@xres, '\n')
		cat('yres      :' , object@yres, '\n')
		cat ('\n')
	}
)


setClass('StackData', 
	representation (
		values='matrix', 
		content='character', #nodata, all, row, block, sparse
		indices = 'vector'
		),
	prototype (	
		values=matrix(NA,0,0),
		content='nodata', 
		indices =vector(mode='numeric')
	),	
	validity = function(object)
	{
	}
)


setClass ('RasterStack',
	contains = 'AbstractRaster',
	representation (
	    filename ='character',
		nrasters='integer',
		rasters ='list',
		data = 'StackData'	
		),
	prototype (
		filename='',
		nrasters=as.integer(0),
		rasters = list()
		),
	validity = function(object)
	{
		cond1 <- length(object@rasters) == object@nrasters
		#cond2 <- Are the rasters equal in dimensions etc.? The exact implementation will depend on the format of the raster@data slot (list, array, vector)
		cond <- cond1 #& cond2
		return(cond)
	}
)


setMethod ('show' , 'RasterStack',
	function ( object ){
		cat ('class     :' , class ( object ) , '\n')
		cat ('filename  :' , object@filename, '\n')
		cat ('nrasters  :' , object@nrasters, '\n')
		cat ('nrows     :' , object@nrows, '\n')
		cat ('ncols     :' , object@ncols, '\n')
		cat ('ncells    :' , object@ncells, '\n')
		cat ('projection:' , attr(object@projection, 'projection'), '\n')
		cat ('xmin      :' , object@xmin, '\n')
		cat ('xmax      :' , object@xmax, '\n')
		cat ('ymin      :' , object@ymin, '\n')
		cat ('ymax      :' , object@ymax, '\n')
		cat ('xres      :' , object@xres , '\n')
		cat ('yres      :' , object@yres , '\n')
		cat ('\n')
	}
)


