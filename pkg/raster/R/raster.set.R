# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3


raster.set.rowcol <- function(raster, nrows=nrows(raster), ncols=ncols(raster)) {
	raster@ncols <- as.integer(ncols)
	raster@nrows <- as.integer(nrows)
	return(raster)
}

raster.set <- function(raster, filename=NA) {
	raster <- raster.clear.data(raster)
	raster <- set.filename(raster, filename)
	return(raster)
}

set.filename <- function(raster, filename) {
	if (is.na(filename)) {filename <- ""}
	raster@file@name <- filename
	shortname <- file.get.name(filename)
	shortname <- file.change.extension(shortname, "")
	shortname <- gsub(" ", "_", shortname)
	if (raster@file@nbands > 1) { shortname <- paste(shortname,"_",raster@file@band) } 
	raster@file@shortname <- shortname
	raster@file@gdalhandle <- list()
	return(raster)
}


set.projection <- function(object, projection) {
	object@proj4string <- create.CRS(projection)
	return(object)
}


raster.clear.data <- function(raster) {
	raster@data@content == 'nodata'
	raster@data@indices == ''
	return(raster)
}		

set.bbox <- function(raster, xmin=xmin(raster), xmax=xmax(raster), ymin=ymin(raster), ymax=ymax(raster), keepres=FALSE) {
	xres <- xres(raster)
	yres <- yres(raster)
	raster@bbox[1,1] <- xmin
	raster@bbox[1,2] <- xmax
	raster@bbox[2,1] <- ymin
	raster@bbox[2,2] <- ymax
	if (keepres) {
		raster@ncols <- as.integer(round( (xmax(raster) - xmin(raster)) / xres ))
		raster@nrows <- as.integer(round( (ymax(raster) - ymin(raster)) / xres ))
		raster@bbox[1,2] <- raster@bbox[1,1] + raster@ncols * xres
		raster@bbox[2,2] <- raster@bbox[2,1] + raster@nrows * yres
	}
	return(raster)
}


create.CRS <- function(projection) {
	if (nchar(projection) < 6) { projs <- (CRS(as.character(NA)))
	} else {
		projs <- try(CRS(projection), silent = T)
		if (class(projs) == "try-error") { 
			warning(paste(projection, 'is not a valid proj4 CRS string')) 
			projs <- (CRS(as.character(NA)))
		}
	}
	return(projs)
}

create.boundingbox <- function(xmin, xmax, ymin, ymax, projection="") {
	if (xmin > xmax) {
		x <- xmin
		xmin <- xmax
		xmax <- x
	}
	if (ymin > ymax) {
		y <- ymin
		ymin <- ymax
		ymax <- y
	}
	projs <- create.CRS(projection)
	bb <- new("Spatial")
	bb@bbox[1,1] <- xmin
	bb@bbox[1,2] <- xmax
	bb@bbox[2,1] <- ymin
	bb@bbox[2,2] <- ymax
	bb@proj4string <- projs
	return(bb)
}


raster.make.sparse <- function(raster) {
	if (raster.content(raster) == 'sparse') {return(raster)
	} else {
		if (raster.content(raster) == 'all') {
			vals <- seq(1:ncells(raster))
			vals <- cbind(vals, values(raster))
			vals <- as.vector(na.omit(vals))
			raster <- raster.set.data.sparse(raster, sparsedata=vals[,2], indices=vals[,1])
			return(raster)
		} else { 
			# as above, but by reading data from disk, row by row
			stop('not implemented yet, use raster.read.all() first' )
		}	
	}
}

raster.set.data.sparse <- function(raster, sparsedata, indices) {
	raster@data@content <- 'sparse'
	raster@data@values <- sparsedata
	raster@data@indices <- indices
	raster@data@source <- 'ram'
	raster <- raster.set.minmax(raster)
	return(raster)
}

raster.set.data.block <- function(raster, blockdata, firstcell, lastcell) {
	if (!is.vector(blockdata)) {	stop('data must be a vector') }
	if (length(blockdata) == 0) {	stop('length(blockdata==0). If this is intended use raster.data.clear(raster)') }
	if (!(is.numeric(blockdata) | is.integer(blockdata) | is.logical(blockdata))) { stop('data must be values') }
	
	firstcol <- raster.get.col.from.cell(raster, firstcell)
	lastcol <- raster.get.col.from.cell(raster, lastcell)
	firstrow <- raster.get.row.from.cell(raster, firstcell)
	lastrow <- raster.get.row.from.cell(raster, lastcell)
	ncells <- (lastcol - firstcol + 1) * (lastrow - firstrow + 1)
	
	if (ncells != length(blockdata)) { 
		stop( paste("length(blockdata):", length(blockdata), "does not match the number implied by firstcell and lastcell:", ncells)) 
	}
	raster@data@values <- blockdata
	raster@data@content <- 'block' 
	raster@data@indices <- c(firstcell, lastcell)
	return(raster)
}


raster.set.data.row <- function(raster, rowdata, rownr) {
	if (!is.vector(rowdata)) {	stop('data must be a vector') }
	if (length(rowdata) == 0) {	stop('length(rowdata==0). If this is intended then use raster.data.clear(raster)') }
	if (!(is.numeric(rowdata) | is.integer(rowdata) | is.logical(rowdata))) { stop(paste('data must be values, but class =',class(rowdata))) }
	if (length(rowdata) != raster@ncols) { stop('length(rowdata) != raster@ncols') 
	} else {	
		raster@data@values <- rowdata
		raster@data@content <- 'row' 
		firstcell <- raster.get.cell.from.rowcol(raster, rownr=rownr, colnr=1)
		lastcell <- raster.get.cell.from.rowcol(raster, rownr=rownr, colnr=raster@ncols)
		raster@data@indices <- c(firstcell, lastcell)
		return(raster)
	}	
}	


raster.set.data <- function(raster, data) {
	if (!is.vector(data)) {stop('data must be a vector')}
	if (length(data) == 0) {	stop('length(data==0). If this is intended then use raster.data.clear(raster)') }
	if (!(is.numeric(data) | is.integer(data) | is.logical(data))) {stop('data must be values')}
	if (length(data) != ncells(raster) ) { stop('length(data) != ncells(raster)') 
	} else {	
		raster@data@values <- data
		raster@data@content <- 'all'
		raster@data@source <- 'ram'
		raster@data@indices <- c(1, ncells(raster))
		raster <- raster.set.minmax(raster)
		return(raster)	
	}	
}




raster.set.minmax <- function(raster) {
	if (raster@data@content == 'nodata') {stop('no data in memory') }
	vals <- na.omit(values(raster)) # min and max values
	if (length(vals) > 0) {
		raster@data@min <-  min(vals)
		raster@data@max <- max(vals)
	} else {
		raster@data@min <- NA
		raster@data@max <- NA
	}
	raster@data@haveminmax <- TRUE
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

