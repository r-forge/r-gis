# R classes for spatial data (raster data specifically) 
# Authors: Robert J. Hijmans and Jacob van Etten, 
# International Rice Research Institute. Philippines
# contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,4
# Licence GPL v3


# the below may be necessary as the function is not imported from SP (it is internal)
# It is to check the bounds of lat/lon values, SP gives an error, I prefer a warning
.ll_sanity <- function(bb) {
	outside <- FALSE
	if (bb[1,1] < -180) {outside <- TRUE }
	if (bb[1,2] > 180) {outside <- TRUE }
	if (bb[2,1] < -90) {outside <- TRUE }
	if (bb[2,2] > 90) {outside <- TRUE }	
	if (outside) { warning('latitude/longitude values are outside their normal range') }
	return(TRUE)
}


#setMethod ('show' , 'Spatial', 
#	function(object) {
#		cat('class     :', class(object), '\n')
#		cat('projection:', projection(object), '\n')
#		get.boundingbox(object)
#	}
#)	


setClass ('AbstractRaster',
# importing "Spatial" (bounding box + Proj4string) from the sp package
	contains = 'Spatial',
	representation (
		ncols ='integer',
		nrows ='integer'
		),
	validity = function(object)
	{
		c1 <- (object@ncols > 0)
		c2 <- (object@nrows > 0)
		return(c1 & c2)
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
		bandorder = 'BIL'
	),
	validity = function(object)
	{
	}
)	


setClass('SingleRasterData', 
	representation (
		values='vector', 
		content='character', #nodata, all, row, block, sparse
		indices = 'vector',
		haveminmax = 'logical',
		min ='numeric',
		max ='numeric',
		source='character' # ram, disk
		),
	prototype (	
		values=vector(),
		content='nodata', 
		indices =vector(mode='numeric'),
		haveminmax = FALSE,
		min = numeric(1),
		max = numeric(1),
		source='ram'
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
		data = 'SingleRasterData',
		history = 'vector'
		),
	prototype (
		history = vector(mode='character')
		)
	)
	
	
setMethod ('show' , 'Raster', 
	function(object) {
		cat('class       :' , class(object), '\n')
		cat('filename    :' , get.filename(object), '\n')
		if (object@file@nbands > 1) {
#			cat('nbands      :' , object@file@nbands, '\n')
			cat('band        :' , object@file@band, '\n')
		}	
		cat('nrows       :' , get.nrows(object), '\n')
		cat('ncols       :' , get.ncols(object), '\n')
		cat('ncells      :' , get.ncells(object), '\n')
		cat('data type   :' , object@file@datanotation, '\n')
		cat('data content:' ,  get.content(object), '\n')
		if (object@data@haveminmax) {
			cat('min value   :' , get.minvalue(object), '\n')
			cat('max value   :' , get.maxvalue(object), '\n')
		} else { #if (object@data@source == 'disk')  {
			cat('min value   : NA \n')
			cat('max value   : NA \n')
		}
		cat('projection  :' , get.projection(object, TRUE), '\n')
		cat('xmin        :' , get.xmin(object), '\n')
		cat('xmax        :' , get.xmax(object), '\n')
		cat('ymin        :' , get.ymin(object), '\n')
		cat('ymax        :' , get.ymax(object), '\n')
		cat('xres        :' , get.xres(object), '\n')
		cat('yres        :' , get.yres(object), '\n')
		cat ('\n')
	}
)


setClass('MultipleRasterData', 
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


setClass ('RasterBrick',
	contains = 'AbstractRaster',
	representation (
		title = 'character',
		file = 'RasterFile',
		data = 'MultipleRasterData',
		history = 'vector'
		),
	prototype (
		history = vector(mode='character')
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
		data = 'MultipleRasterData'	
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
		cat ('nrows     :' , get.nrows(object), '\n')
		cat ('ncols     :' , get.ncols(object), '\n')
		cat ('ncells    :' , get.ncells(object), '\n')
		cat ('projection:' , get.projection(object, TRUE), '\n')
		cat ('xmin      :' , get.xmin(object), '\n')
		cat ('xmax      :' , get.xmax(object), '\n')
		cat ('ymin      :' , get.ymin(object), '\n')
		cat ('ymax      :' , get.ymax(object), '\n')
		cat ('xres      :' , get.xres(object) , '\n')
		cat ('yres      :' , get.yres(object) , '\n')
		cat ('\n')
	}
)

