# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.set.bbox <- function(raster, xmin=raster@xmin, xmax=raster@xmax, ymin=raster@ymin, ymax=raster@ymax) {
	raster@xmin <- xmin
	raster@xmax <- xmax
	raster@ymin <- ymin
	raster@ymax <- ymax
	raster@xres <- (raster@xmax - raster@xmin) / raster@ncols
	raster@yres <- (raster@ymax - raster@ymin) / raster@nrows
	return(raster)
}

raster.set.rowcol <- function(raster, nrows=raster@nrows, ncols=raster@ncols) {
	raster@ncols <- as.integer(ncols)
	raster@nrows <- as.integer(nrows)
	raster@ncells <- as.integer(ncols * nrows)
	raster@xres <- (raster@xmax - raster@xmin) / ncols
	raster@yres <- (raster@ymax - raster@ymin) / nrows
	return(raster)
}

raster.set.filename <- function(raster, filename) {
	if (is.na(filename)) {filename <- ""}
	raster@file@name <- filename
	shortname <- file.get.name(filename)
	shortname <- file.change.extension(shortname, "")
	shortname <- gsub(" ", "_", shortname)
	if (raster@file@nbands > 1) { shortname <- paste(shortname,"_",raster@file@band) } 
	raster@file@shortname <- shortname
	return(raster)
}

raster.set.datatype <- function(raster, datatype, datasize=4) {
#  signed"  should become variable
	signed <- TRUE 
	if (datatype == "numeric") {
		raster@file@datatype <- datatype 
		if (datasize == 4) {
			raster@file@datasize <- as.integer(4)
			raster@file@nodatavalue <- -3.4E38
			raster@file@datanotation <- "FLT4S"
		} else if (datasize == 8) {
			raster@file@datasize <- as.integer(8)
			raster@file@nodatavalue <-  -1.7E308
			raster@file@datanotation <- "FLT8S"
		} else { 	stop("invalid datasize for this datatype") }
	} else if (datatype == "integer") {
		raster@file@datatype <- datatype 
		if (datasize == 4) {
			raster@file@datasize <- as.integer(4)
			raster@file@nodatavalue <- -2147483645
			raster@file@datanotation <- "INT4S"
		} else if (datasize == 2) {
			raster@file@datasize <- as.integer(2)
			raster@file@nodatavalue <- -32768
			raster@file@datanotation <- "INT2S"
		} else if (datasize == 1) {
			raster@file@datasize <- as.integer(1)
			raster@file@nodatavalue <- -1
			raster@file@datanotation <- "INT1U"
			warning("binary files of single byte do not have NA values on disk")
		} else if (datasize == 8) {
			raster@file@datasize <- as.integer(8)
			raster@file@nodatavalue <- -2^63
			raster@file@datanotation <- "INT8S"
		} else { stop("invalid datasize for this datatype") }
	} else {stop("unknown datatype")} 
	return(raster)
}

