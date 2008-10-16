# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

raster.write.ascii <- function(raster, overwrite=FALSE) {
	return(raster.write.ascii.row(raster, rownumber = -1, overwrite))
}


raster.write.ascii.row <- function(raster, rownumber, overwrite=FALSE) {
  	resdif <- abs((raster@yres - raster@xres) / raster@yres)
	if (resdif > 0.01) {
		print(paste("raster has unequal horizontal and vertical resolutions","\n", "these data cannot be stored in arc-ascii format"))
	}
	else {
		if (rownumber <= 1 ) {
			raster <- raster.set.filename(raster, file.change.extension(raster@file@name, '.asc'))
			if (!overwrite & file.exists(raster@file@name)) {
				stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) }

			thefile <- file(raster@file@name, "w")  # open an txt file connection
			cat("NCOLS", raster@ncols, "\n", file = thefile)
			cat("NROWS", raster@nrows, "\n", file = thefile)
			cat("XLLCORNER", raster@xmin, "\n", file = thefile)
			cat("YLLCORNER", raster@ymin, "\n", file = thefile)
			cat("CELLSIZE",  raster@xres, "\n", file = thefile)
			cat("NODATA_value", raster@file@nodatavalue, "\n", file = thefile)
			close(thefile) #close connection
		}
		raster@data[is.na(raster@data@values)] <- raster@file@nodatavalue 
		write.table(raster@data@values, raster@file@name, append = TRUE, quote = FALSE, sep = " ", eol = "\n", 
                          dec = ".", row.names = FALSE, col.names = FALSE)
    }
	return(raster)
}
 
 
raster.write.cellvals <- function(raster, cellvals, overwrite=FALSE) {
	cellv <- subset(cellvals, ((cellvals[,2] <= raster@ncells) & (cellvals[,2] > 0)))
	if (length(cellv) != length(cellvals))	{
		warning(paste("cellvals had", (length(cellvals)-length(cellv)), "cells outside of 0 - ", raster@ncells))
	}
	rm(cellvals)
	if (length(cellv[,1]) < 1) { stop("no valid cells") }
#	if (!sparse) {
		raster@data@values <- vector(length=raster@ncells)
		raster@data@values[cellv[,1]] <- cellv[,2]
		return(raster.write(raster, overwrite))		
#	} else {
#		raster@ncellvals <- length(cellv[,1])
#		raster@data @values<- as.array(as.vector(t(cellv))) 
#		raster@sparse <- TRUE
#		return(raster.write.sparse(raster, overwrite))
#	}
} 


#raster.write.binary.sparse <- function(raster, overwrite) {
#	raster@sparse <- TRUE
#	raster <- raster.write.(raster, overwrite)
#	raster@data @values<- vector(length=0)
#	return(raster)
#}
 
 
raster.write<- function(raster, overwrite=FALSE) {
	raster@file@name <- file.change.extension(raster@file@name, ".grd")
	if (!overwrite & file.exists(raster@file@name)) {
		stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) }

	# dir.create(fixed2, FALSE)		
		
		
	divagrid <- file.change.extension(raster@file@name, ".gri")
	con <- file(divagrid, "wb")
	raster@data@min <- min(raster@data@values, na.rm=TRUE )
	raster@data@max <- max(raster@data@values, na.rm=TRUE )
	raster@data@haveminmax <- TRUE
	raster@file@driver == 'raster'
	
#	raster@data[is.na(raster@data@values)] <- raster@nodatavalue
	if (raster@file@datatype == "integer") { raster@data@values <- as.vector(as.integer(raster@data@values)) }
	transpose <- FALSE
	if (is.matrix(raster@data@values)) {
		if (ncol(raster@data@values) == raster@ncols  &  nrow(raster@data@values) == raster@nrows ) {
			transpose <- TRUE
	    } 
		else if (ncol(raster@data@values) == raster@nrows  & nrow(raster@data@values) == raster@ncols) { 	
		}
		else if (ncol(raster@data@values) == 1  | nrow(raster@data@values) == 1) { #OK 
		}
		else { stop("unexpected data, I do not know how to write this")	}
	} 
	raster@data@values[is.nan(raster@data@values)] <- NA
	if (transpose) {writeBin(as.vector(t(raster@data@values)), con, size = raster@file@datasize) }
	else {writeBin(as.vector(raster@data@values), con, size = raster@file@datasize)}
	close(con)
	raster.write.hdr(raster) 
	return(raster)
}

 
raster.write.row <- function(raster, rownumber, overwrite=FALSE) {
	if (rownumber == 1) { 	#  FIRST  ROW
		if (!overwrite & file.exists(raster@file@name)) {
			stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) 
		}
		raster@file@name <- file.change.extension(raster@file@name, ".grd")
		divagrid <- file.change.extension(raster@file@name, ".gri")
		raster__binary__connection__wb <<- file(divagrid, "wb")
		raster@data@min <- 3e34
		raster@data@max <- -3e34 	
		raster@data@haveminmax <- FALSE
		raster@file@driver == 'raster'
	}	

	if (raster@file@datatype == "integer") { raster@data@values <- as.vector(as.integer(raster@data@values)) }

	rsd <- na.omit(as.vector(raster@data@values)) # min and max values
	if (length(rsd) > 0) {
		raster@data@min <- min(raster@data@min, min(rsd))
		raster@data@max <- max(raster@data@max, max(rsd))
		raster@data@haveminmax <- TRUE
	}	
	
	raster@data@values[is.nan(raster@data@values)] <- NA
	raster@data@values[is.infinite(raster@data@values)] <- NA

#	raster@data@values[is.na(raster@data@values)] <-  raster@file@nodatavalue

	writeBin(as.vector(raster@data@values), raster__binary__connection__wb, size = raster@file@datasize)
	
	if ( rownumber == raster@nrows ) { 	# LAST  ROW
		raster.write.hdr(raster) 
		close(raster__binary__connection__wb)		}
		
	return(raster)	
}


raster.write.hdr <- function(raster) {
	rastergrd <- file.change.extension(raster@file@name, ".grd")
	thefile <- file(rastergrd, "w")  # open an txt file connectionis
	cat("[General]", "\n", file = thefile)
	cat("CREATOR=R package:raster", "\n", file = thefile)
	cat("CREATED=", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n", file = thefile)
	cat("TITLE=", raster@file@shortname, "\n", file = thefile)
	
	cat("[GeoReference]", "\n", file = thefile)
	cat("Rows=",  raster@nrows, "\n", file = thefile)
	cat("Columns=",  raster@ncols, "\n", file = thefile)
	cat("MinX=", raster@xmin, "\n", file = thefile)
	cat("MinY=", raster@ymin, "\n", file = thefile)
	cat("MaxX=", raster@xmax, "\n", file = thefile)
	cat("MaxY=", raster@ymax, "\n", file = thefile)
	cat("ResolutionX=", raster@xres, "\n", file = thefile)
	cat("ResolutionY=", raster@yres, "\n", file = thefile)
	
	cat("[Data]", "\n", file = thefile)
	if (raster@file@datatype == 'integer') {  datatype <- "INT"  } else { datatype <- "FLT" }
	datatype <- paste(datatype, raster@file@datasize, "BYTES", sep="")
	cat("DataType=",  datatype, "\n", file = thefile)
	cat("ByteOrder=",  .Platform$endian, "\n", file = thefile)
	cat("nBands=",  raster@file@nbands, "\n", file = thefile)
	cat("BandOrder=",  raster@file@bandorder, "\n", file = thefile)
	cat("MinValue=",  raster@data@min, "\n", file = thefile)
	cat("MaxValue=",  raster@data@max, "\n", file = thefile)
	cat("NoDataValue=",  raster@file@nodatavalue, "\n", file = thefile)
#	cat("Sparse=", raster@sparse, "\n", file = thefile)
#	cat("nCellvals=", raster@data@ncellvals, "\n", file = thefile)	
	close(thefile)
}

#
#raster.write.gdal <- function(gdata, filename, filetype = "GTiff", gdata) {
#   datatype <- "Float32"
#   writeGDAL(gdata, filename, drivername = filetype, type = datatype, mvFlag = NA, options=NULL)
#}   


raster.write.import <- function(raster, outfile, overwrite=FALSE) {
# check extension
	rsout <- raster.set.filename(raster, outfile)
	for (i in 1:raster@ncols) {
		d <- raster.read.row(raster, i)
		raster.write.row(rsout, i, overwrite)
		}
	return(rsout)
}

raster.write.export <- function(raster, outfile, filetype, overwrite=FALSE) {
	rsout <- raster.set.filename(raster, outfile)
	if (filetype == 'ascii') {
		for (i in 1:raster@ncols) {
			d <- raster.read.row(raster, i)
			raster.write.ascii.row(rsout, i, overwrite) 
		}
	} else {
		stop("filetype not supported (sorry..., more coming ...)")
	}
	return(rsout)
}
