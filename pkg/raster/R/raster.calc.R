# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

.raster.add.history <- function(raster, message) {
	if (is.character(message) && message != "") {
		raster@history <- c(message, raster@history)
	}	
}



raster.calc <- function(raster, fun=sqrt, filename=NA, overwrite=FALSE, INT=FALSE) {
	out.raster <- raster.set.filename(raster, filename)
	out.raster@file@gdalhandle <- list()

	if (INT) { out.raster <- raster.set.datatype(out.raster, "integer")  }
	else { out.raster <- raster.set.datatype(out.raster, "numeric") }
	
	if (raster@data@content == 'nodata' && raster@data@source == 'ram') { stop('raster has no data on disk or in memory') }
	
# there is data	
	if (raster@data@content == 'all') {
		out.raster <- raster.set.data(out.raster, fun(raster@data@values)) 
		if (!is.na(filename) ) { out.raster <- raster.write(out.raster, overwrite=overwrite)
		}
			
	} else if (raster@data@content == 'sparse') {
		out.raster <- raster.set.data.sparse(out.raster, fun(raster@data@values), raster@data@indices) 
		if (!is.na(filename) ) { out.raster <- raster.write(out.raster, overwrite=overwrite)
		}
		
	} else if (is.na(filename) ) {

		if (raster@data@content == 'row') {
			out.raster <- raster.set.data.row(out.raster, fun(raster@data@values), raster.get.row.from.cell(raster, raster@data@indices[1])) 

		} else if (raster@data@content == 'block') {
			out.raster <- raster.set.data.block(out.raster, fun(raster@data@values), raster@data@indices[1], raster@data@indices[2])  
		}
	} else if (!is.na(filename) ) {
			
		for (r in 1:raster@nrows) {
			raster <- raster.read.row(raster, r)
			out.raster <- raster.set.data.row(fun(raster.data(raster)), r)
			out.raster <- raster.write.row(out.raster, overwrite=overwrite)
		}
	} 	
	return(out.raster)
}



raster.calc.init <- function(raster, fun=runif, filename=NA, overwrite=FALSE) {
	if (is.na(filename)) {
		out.raster <- raster.set.filename(raster, "")
		n <- length(raster@data@ncells)
		out.raster <- raster.set.data(fun(n)) 
	} else {
		out.raster <- raster.set.filename(raster, filename)
		n <- length(raster@ncols)
		for (r in 1:raster@nrows) {
			out.raster <- raster.set.data.row(out.raster, fun(n), r) 
			out.raster <- raster.write.row(out.raster, overwrite=overwrite)	}	
		out.raster@data@values <- vector(length=0)	
	}	
	out.raster@file@gdalhandle <- list()
	return(out.raster)
}


raster.calc.reclass <- function(raster, rclmat, filename=NA, overwrite=FALSE, INT=FALSE)  {
	if (is.na(filename)) {
		stop("not implemented yet for filename=NA")
	} else {
		if ( is.null(dim(rclmat)) ) { 
			rclmat <- matrix(rclmat, ncol=3, byrow=TRUE) }
		else if ( dim(rclmat)[2] == 1 ) { 
			rclmat <- matrix(rclmat, ncol=3, byrow=TRUE) }
		colnames(rclmat)[1] <- "From"
		colnames(rclmat)[2] <- "To"
		colnames(rclmat)[3] <- "Becomes"
		print(rclmat)
		out.raster <- raster.set.filename(raster, filename)
		if (INT) { out.raster <- raster.set.datatype(out.raster, "integer")  }
		else { out.raster <- raster.set.datatype(out.raster, "numeric") }
	
		res <- vector(mode = "numeric", length = raster@ncols)
		for (r in 1:raster@nrows) {
			raster <- raster.read.row(raster, r)
			for (i in 1:length(rclmat[,1])) {
				if (is.na(rclmat[i,1]) | is.na(rclmat[i,2])) {
					res[ is.na(raster@data@values) ] <- rclmat[i, 3] 
				} else { 
					res[ (raster@data@values > rclmat[i,1]) & (raster@data@values <= rclmat[i,2])] <- rclmat[i , 3] 
				}
			}
			out.raster <- raster.set.data.row(out.raster, res, r)
			out.raster <- raster.write.row(out.raster, overwrite=overwrite)
		}	
		out.raster@data@values <- vector(length=0)
	}	
	out.raster@file@gdalhandle <- list()
	return(out.raster)
}


raster.calc.isNA <- function(raster, value=0, filename=NA, overwrite=FALSE, INT=FALSE) {
	fun <- function(x) { x[is.na(x)] <- value; return(x)} 
	raster <- raster.calc(raster, fun, filename, overwrite=overwrite, INT=INT)
	return(raster) 
}

	
raster.calc.setNA <- function(raster, operator= "<=", value=0, filename=NA, overwrite=FALSE, INT=FALSE) {
	if (operator == ">") { fun <- function(x) { x[x>value] <- NA; return(x)}
	} else if (operator == "<") { fun <- function(x) { x[x<value] <- NA; return(x)}
	} else if (operator == "<=") { fun <- function(x) { x[x<=value] <- NA; return(x)}
	} else if (operator == ">=") { fun <- function(x) { x[x>=value] <- NA; return(x)}
	} else if (operator == "==") { fun <- function(x) { x[x==value] <- NA; return(x)}
	} else if (operator == "!=") { fun <- function(x) { x[x!=value] <- NA; return(x)}
	}
	return(raster.calc(raster, fun, filename, overwrite=overwrite, INT=INT))
}


.calc.ngb <- function(rows, ngb, fun, keepdata) {
	lim <- floor(ngb / 2)
	res <- array(dim=length(rows[1,]))
	lr <- length(rows[1,])
    for (i in 1:length(rows[1,])) {
		d <- rows[, max(1,(i-lim)):min((i+lim),lr)]
		d <- as.vector(d)
		dd <- na.omit(d)
		if (keepdata) { 
			if (length(dd) > 0) { 
				res[i] <- fun(dd)
			} 		
		} else if (length(dd) == length(d)) { 
			res[i] <- fun(d)
		}
	}	
	return(res)
}


.calc.ngb2 <- function(rows, ngb, fun, keepdata) {
	lim <- floor(ngb / 2)
	res <- array(dim=length(rows[1,]))
	addNA <- (matrix(ncol=lim, nrow=ngb))
	rows <- cbind(addNA, rows, addNA)
#	d <- rows[, max(1,(i-lim)):min((i+lim),lr)]
#	if (rm.NA) {out.raster@data@values <- as.vector(tapply(raster@data,cell.index,function(x){fun(na.omit(x))}))}
#		else {out.raster@data@values <- as.vector(tapply(raster@data,cell.index,fun))}
}
	


raster.calc.neighborhood <- function(raster, fun=mean, filename=NA, ngb=3, keepdata=TRUE, overwrite=FALSE) {
	ngb <- round(ngb)
	if ((ngb / 2) == floor(ngb/2)) { stop("only odd neighborhoods are supported") }
	if (ngb == 1) { stop("ngb should be 3 or larger")  } 
	lim <- floor(ngb / 2)
	ngbgrid <- raster.set.filename(raster, filename)
	
# first create an empty matrix with nrows = ngb and ncols = raster@ncols

	ngbdata1 <- array(data = NA, dim = c(ngb, raster@ncols))
	
	rr <- 1
	for (r in 1:raster@nrows) {
		rowdata <- raster.read.row(raster, r)@data@values
		ngbdata <- rbind(ngbdata[2:ngb,], t(rowdata))
		if (r > lim) {
			ngbgrid <- raster.set.data.row(ngbgrid, .calc.ngb(ngbdata, ngb, fun, keepdata), rr)
			ngbgrid <- raster.write.row(ngbgrid, overwrite)
			rr <- rr + 1
		}
	}
	for (r in (raster@nrows+1):(raster@nrows+lim)) {
		ngbdata <- rbind(ngbdata[2:ngb,], t(ngbdata1))
		ngbgrid <- raster.set.data.row(ngbgrid, .calc.ngb(ngbdata, ngb, fun, keepdata), rr)
		ngbgrid <- raster.write.row(ngbgrid, overwrite)
		rr <- rr + 1
	}
	ngbgrid@file@gdalhandle <- list()
	return(ngbgrid)
}
	

