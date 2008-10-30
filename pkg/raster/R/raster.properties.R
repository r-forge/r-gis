# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  October 2008
# Version 0,2
# Licence GPL v3


filename <- function(object) {
	return(object@file@name)
}

ncols <- function(object) {
	return(object@ncols)
}

	
nrows <- function(object) {
	return(object@nrows)
}

ncells <- function(object) {
	return(return( as.numeric(nrows(object)) * ncols(object )))
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

.raster.zmin <- function(object) {
	return (object@bbox[3,1])
}

.raster.zmax <- function(object) {
	return (object@bbox[3,2])
}

xres <- function(object) {
	return ( (xmax(object) - xmin(object)) / ncols(object)  )
}

yres <- function(object) {
	return ( (ymax(object) - ymin(object)) / nrows(object)  )
}

resolution <- function(object) {
	x <- xres(object)
	y <- yres(object)
	return(c(x, y))
}

boundingbox <- function(object) {
	b <- bbox(object)[1:2, 1:2]
	rownames(b) <- c("x", "y")
	return(b)
}

origin <- function(object) {
	x <- xmin(object) - xres(object)*(round(xmin(object) / xres(object)))
	y <- ymax(object) - yres(object)*(round(ymax(object) / yres(object)))
	return(c(x, y))
}

projection <- function(object, asText=TRUE) {
	if (asText) {return(object@proj4string@projargs)}
	else {return(object@proj4string)}
}


values <- function(object, format='vector', names=FALSE) {
	if (object@data@content=="nodata") {stop("first read some data (e.g., raster.read.all()") }
	if (format=='matrix') {  
		return(.values.as.matrix(object, names)) 
	} else {
		return(object@data@values) 
	}
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
	res1 <- resolution(rasters[[1]])
	origin1 <- origin(rasters[[1]])
	for (i in 2:length(rasters)) { 
		if (rowcol) {
			if (ncols(rasters[[1]]) != ncols(rasters[[i]])) {
				res <- F
				if(stopiffalse) { stop('ncols different')} }
			}	
			if (nrows(rasters[[1]]) != nrows(rasters[[i]])) {
				res <- F
				if(stopiffalse) stop('nrows different')
			}
		}
		if (projection) {
			if (projection(rasters[[1]]) != projection(rasters[[i]])) {
				res <- F
				if(stopiffalse) stop('different projections')
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
				if(stopiffalse) { stop('different x origins')
			} 
			if ((abs(origini[2] - origin1[2])) > slack * yr) {
				res <- F
				if(stopiffalse) { stop('different y origins')}
			}	
		}
	}
}


.values.as.matrix <- function(raster, names=FALSE) {
	if (raster@data@content=="nodata") {stop("first read some data (e.g., raster.read.all() or raster.read.row()") }
	
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

