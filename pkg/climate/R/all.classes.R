# R classes for spatial data (raster data specifically) 
# Author: Robert J. Hijmans
# International Rice Research Institute
# contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,3
# Licence GPL v3

setClass('weather', 
	representation (
		temp ='numeric',
		prec = 'numeric',
		rad = 'numeric',
		wind = 'numeric',
		vapr = 'numeric',
		relh  = 'numeric',
		timespan = 'numeric'
	),
	prototype (	

	),	
	validity = function(object)
	{
	}
)

	
setClass ('dailyweather',
	contains = 'weather',
	representation (
		mintmp ='numeric',
		maxtmp ='numeric'
		),
	validity = function(object)
	{
		cond1 <- isTRUE(object@mintmp <= object@maxtmp)
		cond <- cond1 #& cond2 & cond3
		return(cond)
	}
)
	
	