# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date : June 2008
# Version 0,1
# Licence GPL v3

rasterstack.create.from.stackfile <- function(stackfile) {
	st <- read.table(stackfile,  as.is=FALSE, strip.white=TRUE)
	rasterfiles <- list()
	bands <- list()
	for (i in 1:length(st[,1])) {
		rasterfiles[i] <- as.character(st[i,1])
		bands[i] <- as.integer(st[i,2])
	}
	rst <- rasterstack.create.from.rasterfiles(rasterfiles, bands)
	rst@file@name <- stackfile
	return(rst)
}


rasterstack.create.from.rasterfiles <- function(rasterfiles, bands= rep(1, length(rasterfiles))) {
	return(rasterstack.add.files(NA, rasterfiles, bands))
}


rasterstack.create.from.rasters <- function(rasters) {
	return(rasterstack.add.rasters(NA, rasters))
}


rasterstack.add.files <- function(rasterstack, rasterfiles, bands= rep(1, length(rasterfiles))) {
	if (class(rasterstack) != "RasterStack") { rasterstack <- new("RasterStack") }
	
	if (is.list(rasterfiles)) {rasterfiles <- unlist(rasterfiles)}
	if (is.list(bands)) {bands <- unlist(bands)}
	
	for (i in 1 : length(rasterfiles)) { 
		if (length(rasterfiles)==1) { 
			fn <- rasterfiles
			band <- bands 
		} else {
			fn <- rasterfiles[i]
			band <- bands[i]
		}	
		filename <- string.trim(fn)
		if (!(file.exists(filename))) { 
			stop(paste(filename, "does not exist")) 
		}
		raster <- raster.create.from.file(filename, band)
		rasterstack <- rasterstack.add.rasters(rasterstack, raster) 
	}
	return(rasterstack)
}



rasterstack.add.rasters <- function(rasterstack, rasters) {
#rasters is a list of raster objects
	if (class(rasterstack) != "RasterStack") { rasterstack <- new("RasterStack") }

	for (i in 1 : length(rasters)) { 
		if (length(rasters) == 1) { raster <- rasters 
		} else { raster <- rasters[[i]] }
		
		addraster <- TRUE
		i <- length(rasterstack@rasters) + 1
		if (i == 1) {
			rasterstack@projection = raster@projection
			rasterstack@ncols <- raster@ncols
			rasterstack@nrows <- raster@nrows
			rasterstack@ncells <- raster@ncells
			rasterstack@xmin <- raster@xmin
			rasterstack@xmax <- raster@xmax
			rasterstack@ymin <- raster@ymin
			rasterstack@ymax <- raster@ymax
			rasterstack@xres <- raster@xres
			rasterstack@yres <- raster@yres	  
		} else {
			if (length(attr(rasterstack@projection, "projection")) != 0)
				{
				if ( length(attr(raster@projection, "projection")) == 0 ) { warning("raster with unknown projection added") 
				} else if (rasterstack@projection != raster@projection) { warning("different projections used") }	
			}	
			if (rasterstack@ncols != raster@ncols) {addraster <- FALSE}
			if (rasterstack@nrows != raster@nrows) {addraster <- FALSE}
			if (rasterstack@xmin != raster@xmin) {addraster <- FALSE}
			if (rasterstack@xmax != raster@xmax) {addraster <- FALSE}
			if (rasterstack@ymin != raster@ymin) {addraster <- FALSE}
			if (rasterstack@ymax != raster@ymax) {addraster <- FALSE}
			count <- 1
			for (j in 1:(i-1)) {
				if (raster@file@shortname == rasterstack@rasters[[j]]@file@shortname) { 
					count <- count + 1 
				}
			}	
			if (count > 1) { 
				raster@file@shortname <- paste(raster@file@shortname, "_", count, sep="")) }
		}	
		if (addraster) { 
			rasterstack@rasters[i] <- raster 
			rasterstack@nrasters <- as.integer(rasterstack@nrasters + 1)
		} else { warning(paste("could not add raster:", raster@file@name)) }
	}	
	return(rasterstack)
}	


rasterstack.remove.rasters <- function(rasterstack, indices) {
	indices <- sort(indices, decreasing=TRUE)
	for (i in 1:length(indices)) {
		index <- -1 * indices[i]
		rasterstack@rasters <- rasterstack@rasters[index]
		rasterstack@nrasters <- as.integer(rasterstack@nrasters - 1)
	}	
	return(rasterstack)
}


rasterstack.save <- function(rasterstack, stackfile, forceext = TRUE) {
    if (forceext) { stackfile <- file.change.extension(stackfile, '.stk') }
	rasterstack@file@name <- stackfile
	thefile <- file(stackfile, "w")
	for (i in 1:length(rasterstack@rasters)) {
		cat(rasterstack@rasters[[i]]@file@name, "\t", rasterstack@rasters[[i]]@band,"\n", file=thefile)
		}
	close(thefile)
	return(rasterstack)
}


