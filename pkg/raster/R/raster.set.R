# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.clear.data <- function(raster) {
	raster@data@content == 'nodata'
	raster@data@indices == ''
	return(raster)
}		

raster.set.data.sparse <- function(raster, sparsedata, indices) {
	stop('sorry, not yet implemented')
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
	if (length(data) != raster@ncells) { stop('length(data) != raster@ncells') 
	} else {	
		raster@data@values <- data
		raster@data@content <- 'all'
		raster@data@indices <- c(1, raster@ncells)
		return(raster)	
	}	
}


raster.set.bbox <- function(raster, xmin=raster@xmin, xmax=raster@xmax, ymin=raster@ymin, ymax=raster@ymax) {
	raster@xmin <- xmin
	raster@xmax <- xmax
	raster@ymin <- ymin
	raster@ymax <- ymax
	raster@xres <- (raster@xmax - raster@xmin) / raster@ncols
	raster@yres <- (raster@ymax - raster@ymin) / raster@nrows
	return(raster)
}

raster.set.minmax <- function(raster) {
	if (raster@data@content == 'all') {
		raster@data@min <- min(raster.get.data, na.rm=T)
		raster@data@max <- max(raster.get.data, na.rm=T)
		return(raster)
	} else {stop('cannot do this yet')}
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

