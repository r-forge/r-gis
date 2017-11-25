# Author: Robert J. Hijmans, r.hijmans@gmail.com
# Date : November 2017
# Version 0
# Licence GPL v3


setClass('GeoExtent',
	representation (
		xmin = 'numeric',
		xmax = 'numeric',
		ymin = 'numeric',
		ymax = 'numeric'
	),	
	prototype (	
		xmin = 0,
		xmax = 1,
		ymin = 0,
		ymax = 1
	),
	validity = function(object)	{
		c1 <- (object@xmin <= object@xmax)
		c2 <- (object@ymin <= object@ymax)
		# fix to not break dependencies
		if (is.na(c1)) c1 <- TRUE
		if (is.na(c2)) c2 <- TRUE
		if (!c1) { stop('invalid extent: xmin >= xmax') }
		if (!c2) { stop('invalid extent: ymin >= ymax') }
		return(c1 & c2)
		v <- c(object@xmin, object@xmax, object@ymin, object@ymax)
		c3 <- all(!is.infinite(v))
		if (!c3) { stop('invalid extent: infinite value') }		
		return(c1 & c2 & c3)
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



