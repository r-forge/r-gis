# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  October 2008
# Version 0,2
# Licence GPL v3


filename <- function(object) {
	return(object@file@name)
}

ncells <- function(object) {
	return(return( as.numeric(nrow(object)) * ncol(object )))
}

xmin <- function(object) {
	return (object@bbox[1,1])
}

xmax <- function(object) {
	return (object@bbox[1,2])
}

ymin <- function(object) {
	return (object@bbox[2,1])
}

ymax <- function(object) {
	return (object@bbox[2,2])
}

.zmin <- function(object) {
	return (object@bbox[3,1])
}

.zmax <- function(object) {
	return (object@bbox[3,2])
}

xres <- function(object) {
	return ( (xmax(object) - xmin(object)) / ncol(object)  )
}

yres <- function(object) {
	return ( (ymax(object) - ymin(object)) / nrow(object)  )
}

resolution <- function(object) {
	x <- xres(object)
	y <- yres(object)
	return(c(x, y))
}

boundingbox <- function(object) {
	if (class(object) == 'matrix') {
		object <- new.boundingbox(object[1,1], object[1,2], object[2,1], object[2,2])
	}
	b <- bbox(object)[1:2, 1:2]
	rownames(b) <- c("x", "y")
	return(b)
}


projection <- function(object, asText=TRUE) {
	if (asText) {
		if (is.na(object@proj4string@projargs)) { return('NA') 
		} else return(object@proj4string@projargs)
	} else {return(object@proj4string)}
}


values <- function(object, format='vector', names=FALSE) {
	if (object@data@content=="nodata") {stop("first read some data (e.g., read.all()") }
	if (format=='matrix') { 
		return(.values.as.matrix(object, names)) 
	} else {
		return(object@data@values) 
	}
}


origin <- function(object) {
	x <- xmin(object) - xres(object)*(round(xmin(object) / xres(object)))
	y <- ymax(object) - yres(object)*(round(ymax(object) / yres(object)))
	return(c(x, y))
}


minvalue <- function(raster) {
	return(raster@data@min)
}


maxvalue <- function(raster) {
	return(raster@data@max)
}


data.content <- function(raster) {
	return(raster@data@content)
}

data.indices <- function(raster) {
	i <- raster@data@indices
}

data.source <- function(raster) {
	return(raster@data@source)
}


compare <- function(rasters, origin=TRUE, resolution=TRUE, rowcol=TRUE, projection=TRUE, slack=0.01, stopiffalse=TRUE) {
	res <- TRUE
	if (length(rasters) < 2) {
		res <- F
		if(stopiffalse) {stop('length(rasters) < 2')}
	}	
	res1 <- resolution(rasters[[1]])
	origin1 <- origin(rasters[[1]])
	for (i in 2:length(rasters)) { 
		if (rowcol) {
			if (ncol(rasters[[1]]) != ncol(rasters[[i]])) {
				res <- F
				if(stopiffalse) { stop('ncols different') } 
			}	
			if (nrow(rasters[[1]]) != nrow(rasters[[i]])) {
				res <- F
				if(stopiffalse) { stop('nrows different') }
			}
		}
		if (projection) {
			if (projection(rasters[[1]]) != projection(rasters[[2]]) )  { 
				res <- F
				if(stopiffalse) {stop('different projections')}
			}
		}
		resi <- resolution(rasters[[i]])
		xr <-  min(res1[1], resi[1])
		yr <-  min(res1[2], resi[2])
		if (resolution) {
			if (abs(resi[1] - res1[1]) > slack * xr) {
				res <- F
				if(stopiffalse)  { stop('different x resolution') }
			}	
			if (abs(resi[2] - res1[2]) > slack * yr) { 
				res <- F
				if(stopiffalse) { stop('different y resolution') }
			}
		}
		if (origin) {
			origini <- origin(rasters[[1]])
			if ((abs(origini[1] - origin1[1])) > slack * xr) {
				res <- F
				if(stopiffalse) { stop('different x origins') }
			} 
			if ((abs(origini[2] - origin1[2])) > slack * yr) {
				res <- F
				if(stopiffalse) { stop('different y origins')}
			}	
		}
	}
	return(res)
}


.values.as.matrix <- function(raster, names=FALSE) {
	if (raster@data@content=="nodata") {stop("first read some data (e.g., read.all() or read.row()") }
	
	if (is.matrix(raster@data@values)) {
		return(raster@data@values)
		
	} else if (raster@data@content=="all") {
		mdata <- matrix(raster@data@values, nrow=raster@nrows, ncol=raster@ncols, byrow=TRUE)
		if (names) {
			colnames(mdata) <- seq(1:raster@ncols)
			rownames(mdata) <- seq(1:raster@nrows)
		}	
		return(mdata)

	} else if (raster@data@content=="sparse") {
		mdata <- matrix(NA, nrow=raster@nrows, ncol=raster@ncols, byrow=TRUE)
		vals <- cbind(raster@data@indices, raster@data@values)
		mdata[vals[,1]] <- vals[1,2]
		if (names) {
			colnames(mdata) <- seq(1:raster@ncols)
			rownames(mdata) <- seq(1:raster@nrows)
		}	
		return(mdata)
		
	} else if (raster@data@content=="row") {
		mdata <- matrix(raster@data@values, nrow=1, ncol=raster@ncols, byrow=TRUE)
		if (names) {
			colnames(mdata) <- seq(1:raster@ncols)
			therow <- get.row.from.cell(raster, raster@data@indices[1])
			rownames(mdata) <- therow
		}
		return(mdata)
		
	} else if (raster@data@content=="block") {
		startrow <- get.row.from.cell(raster, raster@data@indices[1])
		startcol <- get.col.from.cell(raster, raster@data@indices[1])
		endrow <- get.row.from.cell(raster, raster@data@indices[2])
		endcol <- get.col.from.cell(raster, raster@data@indices[2])
		ncols <- 1 + endcol - startcol
		nrows <- 1 + endrow - startrow
		
		mdata <- as.matrix(t(raster@data@values[1:ncols]))
		
		if (nrows > 1) {
			for (i in 2:nrows) {
				arow <- raster@data@values[((i-1)*ncols+1):((i-1)*ncols+ncols)]
				mdata <- rbind(mdata, t(arow))
			}
		}
		
		if (names) {
			rowlist <- list()
			for (i in 1:nrows) {
				r <- startrow + i - 1
				rowlist[i] <- paste(r, sep="")
				rownames(mdata) <- rowlist
				colnames(mdata) <- seq(1:ncols)+startcol-1
			}	
		}
		return(mdata)
	}	
}

