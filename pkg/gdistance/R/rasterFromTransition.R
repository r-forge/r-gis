# Author: Jacob van Etten jacobvanetten@yahoo.com
# International Rice Research Institute
# Date :  January 2009
# Version 1.0
# Licence GPL v3

rasterFromTransition <- function(transition)
{
	raster <- new("raster",
		projection = transition@projection,
		ncols = transition@ncols,
		nrows = transition@nrows,
		ncells = transition@ncells,
		xmin = transition@xmin,
		xmax = transition@xmax,
		ymin = transition@ymin,
		ymax = transition@ymax,
		xres = transition@xres,
		yres = transition@yres,
		data = as.array(rep(NA,times=transition@ncells))
		)
	raster@data[as.integer(transition@transitionmatrix@Dimnames[[1]])] <- colSums(as(transition,"dsCMatrix"))
	return(raster)
}