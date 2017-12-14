# Author: Robert J. Hijmans, r.hijmans@gmail.com
# Date : November 2017
# Version 0
# Licence GPL v3


setClass('GeoExtent',
	representation (
		ptr = "Rcpp_GeoExtent"
	),	
	prototype (	
		ptr = NULL
	),
	validity = function(object)	{
		object@ptr$valid
	}
)



setClass('GeoRaster',
	representation (
		ptr = "Rcpp_GeoRaster"
	),	
	prototype (	
		ptr = NULL
	),
	validity = function(object)	{
		return(TRUE)
	}
)



