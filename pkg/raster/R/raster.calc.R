# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

.raster.add.history <- function(raster, message) {
	if (is.character(message) & message != "") {
		raster@history <- c(message, raster@history)
	}	
}




.raster.smooth <- function(raster, kernel_size = 3, filename=NA) {
#based on code by Drs. Paul Hiemstra
#Department of Physical Geography, Faculty of Geosciences, University of Utrecht
#https://stat.ethz.ch/pipermail/r-sig-geo/2008-June/003785.html
# this does not work right now...

	shift_matrix = function(m, row, col) {
		nrow = dim(m)[1]
		ncol = dim(m)[2]
		if(row > 0) m = rbind(matrix(rep(NA,abs(row)*ncol), abs(row),ncol),m[1:(nrow-row),])
		if(row < 0) m = rbind(m[-(row-1):nrow,],matrix(rep(NA,abs(row)*ncol), abs(row),ncol))
		if(col > 0) m = cbind(matrix(rep(NA,abs(col)*nrow), nrow, abs(col)),m[,1:(ncol-col)])
		if(col < 0) m = cbind(m[,-(col-1):ncol],matrix(rep(NA,abs(col)*nrow), nrow, abs(col)))
	}

	raster <- raster.read.all(raster)
    m <- raster.values(raster, format = 'matrix')
	
	row_nums = rep(floor(kernel_size/2): -floor(kernel_size/2), each = kernel_size)
    col_nums = rep(floor(kernel_size/2): -floor(kernel_size/2), kernel_size)
    out = matrix(rep(0,dim(m)[1]*dim(m)[2]), dim(m))
	
    for(i in 1:length(row_nums)) {
        out = out + shift_matrix(m, row_nums[i], col_nums[i])
    }
    res <- (out / (kernel_size * kernel_size))

	res <- as.vector(t(res))
	out.raster <- raster.set.filename(raster, filename)
	out.raster <- raster.set.data(out.raster, res)
	return(out.raster)
}



raster.calc <- function(raster, fun=sqrt, filename=NA, overwrite=FALSE, INT=FALSE) {
	out.raster <- raster.set(raster, filename)

	if (INT) { out.raster <- raster.set.datatype(out.raster, "integer")  }
	else { out.raster <- raster.set.datatype(out.raster, "numeric") }
	
	if (raster.content(raster) == 'nodata' && raster.source(raster) == 'ram') { stop('raster has no data on disk or in memory') }
	
# there is data	
	if (raster.content(raster) == 'all') {
		out.raster <- raster.set.data(out.raster, fun(raster.values(raster))) 
		if (!is.na(filename) ) { out.raster <- raster.write(out.raster, overwrite=overwrite)
		}
			
	} else if (raster.content(raster) == 'sparse') {
		out.raster <- raster.set.data.sparse(out.raster, fun(raster.values(raster)), raster.indices(raster)) 
		if (!is.na(filename) ) { out.raster <- raster.write(out.raster, overwrite=overwrite)
		}
		
	} else if (is.na(filename) ) {

		if (raster.content(raster) == 'row') {
			out.raster <- raster.set.data.row(out.raster, fun(raster.values(raster)), raster.get.row.from.cell(raster, raster.indices(raster)[1])) 

		} else if (raster.content(raster) == 'block') {
			out.raster <- raster.set.data.block(out.raster, fun(raster.values(raster)), raster.indices(raster)[1], raster.indices(raster)[2])  
		}
	} else if (!is.na(filename) ) {
			
		for (r in 1:raster@nrows) {
			raster <- raster.read.row(raster, r)
			out.raster <- raster.set.data.row(fun(raster.values(raster)), r)
			out.raster <- raster.write.row(out.raster, overwrite=overwrite)
		}
	} 	
	return(out.raster)
}



raster.calc.init <- function(raster, fun=runif, filename=NA, overwrite=FALSE, INT=FALSE) {
	out.raster <- raster.set(raster)
	if (INT) { 
		out.raster <- raster.set.datatype(out.raster, "integer") 
		res <- vector(mode = "integer", length = raster.ncols(raster))
	} else { 
		out.raster <- raster.set.datatype(out.raster, "numeric") 
		res <- vector(mode = "numeric", length = raster.ncols(raster))
	}
	if (is.na(filename)) {
		n <- raster.ncells(raster)
		out.raster <- raster.set.data(out.raster, fun(n)) 
	} else {
		out.raster <- raster.set.filename(raster, filename)
		n <- length(raster.ncols(raster))
		for (r in 1:raster.nrows(raster)) {
			out.raster <- raster.set.data.row(out.raster, fun(n), r) 
			out.raster <- raster.write.row(out.raster, overwrite=overwrite)	
		}	
	}	
	return(out.raster)
}


raster.calc.reclass <- function(raster, rclmat, filename=NA, overwrite=FALSE, INT=FALSE)  {

	if ( is.null(dim(rclmat)) ) { 
		rclmat <- matrix(rclmat, ncol=3, byrow=TRUE) 
	} else if ( dim(rclmat)[2] == 1 ) { 
		rclmat <- matrix(rclmat, ncol=3, byrow=TRUE) }
	
	if ( dim(rclmat)[2] != 3 ) { stop('rclmat must have 3 columns') }

	colnames(rclmat) <- c("From", "To", "Becomes")	
	print(rclmat)

	out.raster <- raster.set(raster, filename)
	if (INT) { 
		out.raster <- raster.set.datatype(out.raster, "integer") 
		res <- vector(mode = "integer", length = raster.ncols(raster))
	} else { 
		out.raster <- raster.set.datatype(out.raster, "numeric") 
		res <- vector(mode = "numeric", length = raster.ncols(raster))
	}

	if (raster.content(raster) == 'all' | raster.content(raster) == 'sparse') {
		for (i in 1:length(rclmat[,1])) {
			if (is.na(rclmat[i,1]) | is.na(rclmat[i,2])) {
				res[ is.na(raster.values(raster)) ] <- rclmat[i, 3] 
			} else { 
				res[ (raster.values(raster) > rclmat[i,1]) & (raster.values(raster) <= rclmat[i,2]) ] <- rclmat[i , 3] 
			}
		}
		if (raster.content(raster) == 'all') { out.raster <- raster.set.data(out.raster, res) }
		if (raster.content(raster) == 'sparse') { out.raster <- raster.set.data.row(out.raster, res, raster.indices(raster)) }
		if (!is.na(filename)) {	out.raster <- raster.write(out.raster) }
	}

	for (r in 1:raster.nrows(raster)) {
		raster <- raster.read.row(raster, r)
		for (i in 1:length(rclmat[,1])) {
			if (is.na(rclmat[i,1]) | is.na(rclmat[i,2])) {
				res[ is.na(raster.values(raster)) ] <- rclmat[i, 3] 
			} else if (is.na(rclmat[i,1]) == is.na(rclmat[i,2])) {
				res[ (raster.values(raster) == rclmat[i,1]) ] <- rclmat[i , 3] 
			} else {
				res[ (raster.values(raster) > rclmat[i,1]) & (raster.values(raster) <= rclmat[i,2]) ] <- rclmat[i , 3] 
			}
		}
		out.raster <- raster.set.data.row(out.raster, res, r)
		out.raster <- raster.write.row(out.raster, overwrite=overwrite)
	}	
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
	res <- vector(length=length(rows[1,]))
	lr <- length(rows[1,])
    for (i in 1:length(rows[1,])) {
		d <- rows[, max(1,(i-lim)):min((i+lim),lr)]
		d <- as.vector(d)
		dd <- as.vector(na.omit(d))
		if (length(dd) == 0) {
			res[i] <- NA
		} else if (keepdata) { 
			res[i] <- fun(dd)
		} else {
			if (length(dd) == length(d)) { 
				res[i] <- fun(d)
			} else {
				res[i] <- NA
			}
		}
	}	
	return(res)
}


.calc.ngb2 <- function(rows, ngb, fun, keepdata) {
#TODO
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
	ngbdata <- ngbdata1
	
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

	ngbdata1 <- array(data = NA, dim = c(ngb, raster@ncols))
	for (r in (raster@nrows+1):(raster@nrows+lim)) {
		ngbdata <- rbind(ngbdata[2:ngb,], t(ngbdata1[1,]))
		ngbgrid <- raster.set.data.row(ngbgrid, .calc.ngb(ngbdata, ngb, fun, keepdata), rr)
		ngbgrid <- raster.write.row(ngbgrid, overwrite)
		rr <- rr + 1
	}
	return(ngbgrid)
}
	

