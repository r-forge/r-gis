# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3


raster.write.ascii <- function(raster, overwrite=FALSE) {

  	resdif <- abs((yres(raster) - xres(raster)) / yres(raster) )
	if (resdif > 0.01) {
		print(paste("raster has unequal horizontal and vertical resolutions","\n", "these data cannot be stored in arc-ascii format"))
	}

	else {

		if (raster@data@indices[1] == 1)
		{
			raster <- set.filename(raster, file.change.extension(raster@file@name, '.asc'))
			if (!overwrite & file.exists(raster@file@name)) {
				stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) }

			thefile <- file(raster@file@name, "w")  # open an txt file connection
			cat("NCOLS", raster@ncols, "\n", file = thefile)
			cat("NROWS", raster@nrows, "\n", file = thefile)
			cat("XLLCORNER", xmin(raster), "\n", file = thefile)
			cat("YLLCORNER", ymin(raster), "\n", file = thefile)
			cat("CELLSIZE",  xres(raster), "\n", file = thefile)
			cat("NODATA_value", raster@file@nodatavalue, "\n", file = thefile)
			close(thefile) #close connection
		}
		
		raster@data@values[is.na(raster@data@values)] <- raster@file@nodatavalue 
		write.table(raster@data@values, raster@file@name, append = TRUE, quote = FALSE, sep = " ", eol = "\n", 
                          dec = ".", row.names = FALSE, col.names = FALSE)
    }
	return(raster)
}
 
 
.raster.write.sparse <- function(raster, overwrite=FALSE) {
	raster@file@name <- file.change.extension(raster@file@name, ".grd")
	if (!overwrite & file.exists(raster@file@name)) {
		stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) }

	raster@file@driver == 'raster'

	raster@data@values[is.nan(raster@data@values)] <- NA
	if (raster@file@datatype == "integer") { raster@data@values <- as.integer(raster@data@values) }
	raster <- raster.set.minmax(raster)

	binraster <- file.change.extension(raster@file@name, ".gri")
	con <- file(binraster, "wb")
	writeBin( as.vector(raster@data@indices), con, size = as.integer(4)) 
	writeBin( as.vector(raster@data@values), con, size = raster@file@datasize) 
	close(con)

	# add the 'sparse' key word to the hdr file!!!
	.raster.write.hdr(raster) 
	return(raster)
} 


 
raster.write <- function(raster, overwrite=FALSE) {

	if (raster@data@content == 'sparse') { .raster.write.sparse(raster, overwrite) }

	if (raster@data@content != 'all') {stop('first use raster.set.data()') }

	raster@file@name <- file.change.extension(raster@file@name, ".grd")
	if (!overwrite & file.exists(raster@file@name)) {
		stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) }

	raster@file@driver == 'raster'
	raster@data@values[is.nan(raster@data@values)] <- NA
	raster@data@values[is.infinite(raster@data@values)] <- NA

	if (raster@file@datatype == "integer") { raster@data@values <- as.integer(raster@data@values) }
	raster <- raster.set.minmax(raster)

	binraster <- file.change.extension(raster@file@name, ".gri")
	con <- file(binraster, "wb")
	writeBin( raster@data@values, con, size = raster@file@datasize) 
	close(con)

	.raster.write.hdr(raster) 
	return(raster)
}

 
raster.write.row <- function(raster, overwrite=FALSE) {

	if (raster@data@content != 'row') { stop('raster does not contain a row') }
	
	if (raster@data@indices[1] == 1) {
 	#  FIRST  ROW
		if (!overwrite & file.exists(raster@file@name)) {
			stop(paste(raster@file@name,"exists.","use 'overwrite=TRUE' if you want to overwrite it")) 
		}
		raster@file@name <- file.change.extension(raster@file@name, ".grd")
		binraster <- file.change.extension(raster@file@name, ".gri")
		attr(raster, "filecon") <- file(binraster, "wb")
		raster@data@min <- 3e34
		raster@data@max <- -3e34 	
		raster@data@haveminmax <- FALSE
		raster@file@driver == 'raster'
	}	

	if (raster@file@datatype == "integer") { raster@data@values <- as.integer(raster@data@values) }

	raster@data@values[is.nan(raster@data@values)] <- NA
	raster@data@values[is.infinite(raster@data@values)] <- NA
	rsd <- na.omit(raster@data@values) # min and max values
	if (length(rsd) > 0) {
		raster@data@min <- min(raster@data@min, min(rsd))
		raster@data@max <- max(raster@data@max, max(rsd))
	}	

#	raster@data@values[is.na(raster@data@values)] <-  raster@file@nodatavalue
	writeBin(as.vector(raster@data@values), raster@filecon, size = raster@file@datasize)
	
	if (raster@data@indices[2] == raster) {
	# LAST  ROW
		.raster.write.hdr(raster) 
		close(raster@filecon)
		raster@data@haveminmax <- TRUE
		raster@data@source <- 'disk'
		raster@data@content <- 'nodata'
		raster@data@values <- vector(length=0)
	}		
	return(raster)	
}


.raster.write.hdr <- function(raster) {
	rastergrd <- file.change.extension(filename(raster), ".grd")
	thefile <- file(rastergrd, "w")  # open an txt file connectionis
	cat("[General]", "\n", file = thefile)
	cat("CREATOR=R package:raster", "\n", file = thefile)
	cat("CREATED=", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n", file = thefile)
	cat("TITLE=", raster@file@shortname, "\n", file = thefile)
	
	cat("[GeoReference]", "\n", file = thefile)
	cat("Rows=",  raster@nrows, "\n", file = thefile)
	cat("Columns=",  raster@ncols, "\n", file = thefile)
	cat("MinX=", xmin(raster), "\n", file = thefile)
	cat("MinY=", ymin(raster), "\n", file = thefile)
	cat("MaxX=", xmax(raster), "\n", file = thefile)
	cat("MaxY=", ymax(raster), "\n", file = thefile)
	cat("ResolutionX=", xres(raster), "\n", file = thefile)
	cat("ResolutionY=", yres(raster), "\n", file = thefile)
	
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
	rsout <- set.filename(raster, outfile)
	for (r in 1:raster@nrows) {
		d <- raster.read.row(raster, r)
		raster.write.row(rsout, overwrite)
		}
	return(rsout)
}

raster.write.export <- function(raster, outfile, filetype, overwrite=FALSE) {
	rsout <- set.filename(raster, outfile)
	if (filetype == 'ascii') {
		for (r in 1:raster@rows) {
			d <- raster.read.row(raster, r)
			raster.write.ascii(rsout, overwrite) 
		}
	} else {
		stop("filetype not yet supported (sorry..., more coming ...)")
	}
	return(rsout)
}
