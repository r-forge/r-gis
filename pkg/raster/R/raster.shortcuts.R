# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.shortcuts <- function() {
	rcff <<- raster.create.from.file
	rcn <<- raster.create.new
	rra <<- raster.read.all
	rw <<- raster.write
	rmap <<- raster.map
}

