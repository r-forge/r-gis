# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  October 2008
# Version 0,2
# Licence GPL v3


raster.filename <- function(object) {
	return(object@file@name)
}

raster.ncols <- function(object) {
	return(object@ncols)
}

raster.nrows <- function(object) {
	return(object@nrows)
}

raster.ncells <- function(object) {
	return( as.numeric(object@nrows) * object@ncols )
}

raster.xmin <- function(object) {
	return (object@bbox[1,1])
}

raster.xmax <- function(object) {
	return (object@bbox[1,2])
}

raster.ymin <- function(object) {
	return (object@bbox[2,1])
}

raster.ymax <- function(object) {
	return (object@bbox[2,2])
}

raster.boundingbox <- function(object) {
	return(bbox(object)[1:2, 1:2])
}

.raster.zmin <- function(object) {
	return (object@bbox[3,1])
}

.raster.zmax <- function(object) {
	return (object@bbox[3,2])
}

raster.xres <- function(object) {
	return ( (raster.xmax(object) - raster.xmin(object)) / raster.ncols(object)  )
}

raster.yres <- function(object) {
	return ( (raster.ymax(object) - raster.ymin(object)) / raster.nrows(object)  )
}

raster.resolution <- function(object) {
	x <- raster.xres(object)
	y <- raster.yres(object)
	return(c(x, y))
}

raster.origin <- function(object) {
	x <- raster.xmin(object) - raster.xres(object)*(round(raster.xmin(object) / raster.xres(object)))
	y <- raster.ymax(object) - raster.yres(object)*(round(raster.ymax(object) / raster.yres(object)))
	return(c(x, y))
}

raster.projection <- function(object) {
	return(object@proj4string)
}


raster.content <- function(raster) {
	return(raster@data@content)
}

raster.indices <- function(raster) {
	return(raster@data@indices)
}

raster.source <- function(raster) {
	return(raster@data@source)
}


raster.values <- function(raster, format='vector', names=FALSE) {
	if (raster@data@content=="nodata") {stop("first read some data (e.g., raster.read.all()") }
	if (format=='matrix') {  return(.raster.get.matrix(raster, names)) 
	} else { return(raster@data@values) 
	}
}


raster.minvalue <- function(raster) {
	return(raster@data@min)
}


raster.maxvalue <- function(raster) {
	return(raster@data@max)
}




raster.compare <- function(rasters, origin=TRUE, resolution=TRUE, rowcol=TRUE, projection=TRUE, slack=0.01, stopiffalse=TRUE) {
	res <- TRUE
	if (length(rasters) < 2) {
		res <- F
		if(stopiffalse) stop('length(rasters) < 2')
	}	
	res1 <- raster.resolution(rasters[[1]])
	origin1 <- raster.origin(rasters[[1]])
	for (i in 2:length(rasters)) { 
		if (rowcol) {
			if (raster.ncols(rasters[[1]]) != raster.ncols(rasters[[i]])) {
				res <- F
				if(stopiffalse) { stop('ncols different')} }
			}	
			if (raster.nrows(rasters[[1]]) != raster.nrows(rasters[[i]])) {
				res <- F
				if(stopiffalse) stop('nrows different')
			}
		}
		if (projection) {
			if (raster.projection(rasters[[1]]) != raster.projection(rasters[[i]])) {
				res <- F
				if(stopiffalse) stop('different projections')
			}
		}
		resi <- raster.resolution(rasters[[i]])
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
			origini <- raster.origin(rasters[[1]])
			if ((abs(origini[1] - origin1[1])) > slack * xr) {
				res <- F
				if(stopiffalse) { stop('different x origins')
			} 
			if ((abs(origini[2] - origin1[2])) > slack * yr) {
				res <- F
				if(stopiffalse) { stop('different y origins')}
			}	
		}
	}
}


.raster.get.matrix <- function(raster, names=FALSE) {
	if (raster@data@content=="nodata") {stop("first read some data (e.g., raster.read.all() or raster.read.row()") }
	
	if (raster@data@content=="all") {
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
			therow <- raster.get.row.from.cell(raster, raster@data@indices[1])
			rownames(mdata) <- therow
		}
		return(mdata)
		
	} else if (raster@data@content=="block") {
		startrow <- raster.get.row.from.cell(raster, raster@data@indices[1])
		startcol <- raster.get.col.from.cell(raster, raster@data@indices[1])
		endrow <- raster.get.row.from.cell(raster, raster@data@indices[2])
		endcol <- raster.get.col.from.cell(raster, raster@data@indices[2])
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

