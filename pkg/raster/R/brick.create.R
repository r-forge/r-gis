

brick.new <- function(xmin=-180, xmax=180, ymin=-90, ymax=90, nrows=180, ncols=360, projection="+proj=longlat +datum=WGS84") {
	bb <- new.boundingbox(xmin, xmax, ymin, ymax, projection)
	return(brick.from.bbox(bb, nrows=nrows, ncols=ncols))
}

brick.from.bbox <- function(boundingbox, nrows=1, ncols=1) {
	nr = as.integer(round(nrows))
	nc = as.integer(round(ncols))
	if (nc < 1) { stop("ncols should be larger than 0") }
	if (nr < 1) { stop("nrows should be larger than 0") }
	if (validObject(boundingbox)) {
		brick <- new("RasterBrick", bbox = boundingbox@bbox, proj4string=boundingbox@proj4string, ncols = nc, nrows = nr )
		brick@data@content <- 'nodata'
		return(brick) 
	} else {
		return <- NA 
	}
}
