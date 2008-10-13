# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.calc <- function(raster, fun=sqrt, filename=NA, overwrite=FALSE, INT=FALSE) {
	out.raster <- raster.set.filename(raster, filename)
	if (INT) { out.raster <- raster.set.datatype(out.raster, "integer")  }
	else { out.raster <- raster.set.datatype(out.raster, "numeric") }
	
	if (raster@data@content == 'all') {
		out.raster@data@values <- as.vector(fun(raster@data@values)) 
		if (!is.na(filename)) {
			out.raster <- raster.write.binary(out.raster, overwrite=overwrite)
		}	
	} else if (raster@data@source == 'disk') {
		for (r in 1:raster@nrows) {
			raster <- raster.read.row(raster, r)
			values <- as.vector(fun(raster@data@values))
			if (is.na(filename)) {
				if (r == 1) {
					out.raster@data@values  <- values
					out.raster@data@content <- 'all'
				} else {
					out.raster@data@values  <- c(out.raster@data@values, values)
				}		
			} else {
				out.raster@data@values <- values 
				out.raster <- raster.write.binary.row(out.raster, r, overwrite=overwrite)	
				if (r == raster@nrows ) {
					out.raster@data@content <- 'nodata'
					out.raster@data@values <- vector(length=0)
				}
			}	
		}
	}	
	return(out.raster)
}


raster.calc.init <- function(raster, fun=runif, filename=NA, overwrite=FALSE) {
	if (is.na(filename)) {
		out.raster <- raster.set.filename(raster, "")
		n <- length(raster@data@ncells)
		out.raster@data@values <- as.vector(fun(n)) 
	} else {
		out.raster <- raster.set.filename(raster, filename)
		n <- length(raster@ncols)
		for (r in 1:raster@nrows) {
			out.raster@data@values <- as.vector(fun(n)) 
			out.raster <- raster.write.binary.row(out.raster, r, overwrite=overwrite)	}	
		out.raster@data@values <- vector(length=0)	
	}	
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
			rowdata <- raster.read.row(raster, r)
			for (i in 1:length(rclmat[,1])) {
				if (is.na(rclmat[i,1]) | is.na(rclmat[i,2])) {
					res[ is.na(rowdata) ] <- rclmat[i, 3] 
				} else { 
					res[ (rowdata > rclmat[i,1]) & (rowdata <= rclmat[i,2])] <- rclmat[i , 3] 
				}
			}
			out.raster@data@values <- as.vector(res)
			out.raster <- raster.write.binary.row(out.raster, r, overwrite=overwrite)
		}	
		out.raster@data@values <- vector(length=0)
	}	
	return(out.raster)
}


raster.calc.isNA <- function(raster, value=0, filename=NA, overwrite=FALSE, INT=FALSE) {
	fun <- function(x) { x[is.na(x)] <- value; return(x)} 
	return(raster.calc(raster, fun, filename, overwrite=overwrite, INT=INT)) 
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


calc.ngb <- function(rows, ngb, fun, keepdata) {
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



raster.calc.neighborhood <- function(raster, fun=mean, filename=NA, ngb=3, keepdata=TRUE, overwrite=FALSE) {
	ngb <- round(ngb)
	if ((ngb / 2) == floor(ngb/2)) { stop("only odd neighborhoods are supported") }
	if (ngb == 1) { stop("ngb should be 3 or larger")  } 
	lim <- floor(ngb / 2)
	ngbgrid <- raster.set.filename(raster, filename)
	
	ngbdata1 <- array(data = NA, dim = raster@ncols)
	ngbdata <- ngbdata1
	for (i in 2:ngb) { ngbdata <- rbind(ngbdata, t(ngbdata1)) }	
	
	rr <- 1
	for (r in 1:raster@nrows) {
		rowdata <- raster.read.row(raster, r)@data@values
		ngbdata <- rbind(ngbdata[2:ngb,], t(rowdata))
		if (r > lim) {
			ngbgrid@data@values <- calc.ngb(ngbdata, ngb, fun, keepdata)
			ngbgrid <- raster.write.row(ngbgrid, rr, overwrite)
			rr <- rr + 1
		}
	}
	for (r in (raster@nrows+1):(raster@nrows+lim)) {
		ngbdata <- rbind(ngbdata[2:ngb,], t(ngbdata1))
		ngbgrid@data@values <- calc.ngb(ngbdata, ngb, fun, keepdata)
		ngbgrid <- raster.write.row(ngbgrid, rr, overwrite)
		rr <- rr + 1
	}
	return(ngbgrid)
}
	

