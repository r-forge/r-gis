# R code for reading raster (grid) data
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date : June 2008
# Version 0,3
# Licence GPL v3


# read entire raster


if (!isGeneric("read.all")) {
	setGeneric("read.all", function(object)
		standardGeneric("read.all"))
}	
setMethod('read.all', signature(object='RasterLayer'), 
	function(object){ return(.raster.read.all(object))}
)
setMethod('read.all', signature(object='RasterStack'), 
	function(object){ return(.stack.read.all(object))}
)


if (!isGeneric("read.row")) {
	setGeneric("read.row", function(object, rownr)
		standardGeneric("read.row"))
}
setMethod('read.row', signature(object='RasterLayer'), 
	function(object, rownr){ return(.raster.read.row(object, rownr))}
)
setMethod('read.row', signature(object='RasterStack'), 
	function(object, rownr){ return(.stack.read.row(object, rownr))}
)

	
if (!isGeneric("read.rows")) {
	setGeneric("read.rows", function(object, startrow, nrows=3)
		standardGeneric("read.rows"))
}	

setMethod('read.rows', signature(object='RasterLayer'), 
	function(object, startrow, nrows=3) { 
		return(.raster.read.rows(object, startrow, nrows))}
)		


if (!isGeneric("read.block")) {
	setGeneric("read.block", function(object, startrow, nrows=3, startcol=1, ncolumns=(ncols(object)-startcol+1))
		standardGeneric("read.block"))
}	

setMethod('read.block', signature(object='RasterLayer'), 
	function(object, startrow, nrows=3, startcol=1, ncolumns=(ncols(object)-startcol+1)) { 
		return(.raster.read.block(object, startrow, nrows, ncolumns))}
)

if (!isGeneric("read.part.of.row")) {
	setGeneric("read.part.of.row", function(object, rownr, startcol=1, ncolumns=(ncols(object)-startcol+1))
		standardGeneric("read.part.of.row"))
}	

setMethod('read.part.of.row', signature(object='RasterLayer'), 
	function(object, rownr, startcol=1, ncolumns=(ncols(object)-startcol+1)) { 
		return(.raster.read.part.of.row(object, rownr, startcol, ncolumns))}
)

setMethod('read.part.of.row', signature(object='RasterStack'), 
	function(object, rownr, startcol=1, ncolumns=(ncols(object)-startcol+1)) { 
		return(.stack.read.part.of.row(object, rownr, startcol, ncolumns))}
)


	
.raster.read.all <- function(raster) {
	raster <- .raster.read.row(raster, -1)
	return(raster)
}

#read a single row
.raster.read.row <- function(raster, rownr) {
	raster <- .raster.read.part.of.row(raster, rownr)
	return(raster)
}

#read multiple rows
.raster.read.rows <- function(raster, startrow, nrows=3) {
	return(.raster.read.block(raster, startrow, nrows))
}	

#read a block of data  (a rectangular area  of any dimension)  
.raster.read.block <- function(raster, startrow, nrows=3, startcol=1, ncolumns=(ncols(raster)-startcol+1)) {
	if (startrow < 1 ) { stop("startrow too small") } 
	if (startrow > raster@nrows ) { stop("startrow too high") }
	if (nrows < 1) { stop("nrows should be > 1") } 
	if (startcol < 1) { stop("startcol < 1") }
	if (startcol > raster@ncols) { stop("startcol  > raster@ncols")  }
	if (ncolumns < 1) { stop("ncolumns should be > 1") }
	if ((startcol + ncolumns - 1) > raster@ncols ) {
		warning("ncolumns too high, truncated")
		ncolumns <- raster@ncols-startcol }
		
	endrow <- startrow+nrows-1
	if (endrow > raster@nrows) {
		warning("Rows beyond raster not read")
		endrow <- raster@nrows
		nrows <- endrow - startrow + 1
	}
	raster <- .raster.read.part.of.row(raster, startrow, startcol, ncolumns)
	blockdata <- values(raster)
	if (nrows > 1) {
		for (r in (startrow+1):endrow) {
			raster <- .raster.read.part.of.row(raster, r,  startcol, ncolumns)
			blockdata <- c(blockdata, values(raster))
		}	
	}	
	startcell <- get.cell.from.rowcol(raster, startrow, startcol)
	endcell <- get.cell.from.rowcol(raster, endrow, (startcol+ncolumns-1))
	raster <- set.values.block(raster, blockdata, startcell, endcell)
	return(raster)
}


#read part of a single row
.raster.read.part.of.row <- function(raster, rownr,  startcol=1, ncolumns=(ncols(raster)-startcol+1)) {
	rownr <- round(rownr)
	if (rownr == 0) { stop("rownr == 0. It should be between 1 and nrows(raster), or -1 for all rows") }
	if (rownr > nrows(raster)) { stop("rownr too high") }
	if (startcol < 1) { stop("startcol < 1") }
	if (startcol > ncols(raster)) { stop("startcol > ncols(raster)") }
	if (ncolumns < 1) { stop("ncols should be > 1") }


	endcol <- startcol + ncolumns - 1
	if (endcol > ncols(raster)) { 
		endcol <- ncols(raster) 
		ncolumns <- ncols(raster) - startcol + 1  
	}

	if (raster@file@driver == 'raster') {
		rastergri <- file.change.extension(raster@file@name, ".gri")
		if (!file.exists( filename(raster))) { 
			stop(paste(filename(raster)," does not exist"))
		}
		con <- file(rastergri, "rb")
		if (raster@file@datatype == "integer") { 
			dtype <- integer()
		} else { 
			dtype <- numeric() 
		}
		if (rownr > 0) {
			seek(con, ((rownr-1) * ncols(raster) + (startcol-1)) * raster@file@datasize)
			result <- readBin(con, what=dtype, n = ncolumns, size = raster@file@datasize, endian = raster@file@byteorder) }	
		else {	
			result <- readBin(con, what=dtype, n = ncells(raster), size = raster@file@datasize, endian = raster@file@byteorder) 
		}
		close(con)
		result[result <=  (0.999 * raster@file@nodatavalue) ] <- NA 
	}
	else { #use GDAL  
		if (is.na(raster@file@band)) { result <- NA }
		else {
			if (rownr > nrows(raster)) {
				stop("rownr too high")
			}
			if (rownr <= 0) {
				offs <- c(0, 0) 
				reg <- c(nrows(raster), ncols(raster)) #	reg <- dim(raster@file@gdalhandle[[1]])
			}
			else {
				offs= c((rownr-1), (startcol-1)) 
				reg <- c(1, ncolumns)
			}
		}
		result <- getRasterData(raster@file@gdalhandle[[1]], offset=offs, region.dim=reg, band = raster@file@band)
		if (!is.vector(result)) { result <- as.vector(result) }
	} 
	raster@data@values <- as.vector(result)
	if (rownr < 0) {
		raster@data@indices <- c(1, ncells(raster))
		raster@data@content <- "all"
		raster <- set.minmax(raster)
	} else if (startcol==1 & ncolumns==(ncols(raster)-startcol+1)) {
		raster@data@indices <- c(get.cell.from.rowcol(raster, rownr, startcol), get.cell.from.rowcol(raster, rownr, endcol))
		raster@data@content <- "row"
	} else {
		raster@data@indices <- c(get.cell.from.rowcol(raster, rownr, startcol), get.cell.from.rowcol(raster, rownr, endcol))
		raster@data@content <- "block"
	}	
	
	return(raster)
}


#sample while reading and return matrix (for plotting )
.read.skip <- function(raster, maxdim=500) {
	rasdim <- max(ncols(raster), raster@nrows )
	if (rasdim <= maxdim) { 
		dd <- .values.as.matrix(.raster.read.all(raster))
	} else {
		fact <- maxdim / rasdim
		nc <- trunc(fact * raster@ncols)
		nr <- trunc(fact * raster@nrows)
		colint <- round(raster@ncols / nc)
		rowint <- round(raster@nrows / nr)
		nc <- trunc(raster@ncols / colint)
		nr <- trunc(raster@nrows / rowint)
		cols <- vector(length=nc)
		for (i in 1:nc) { 
			cols[i] <- 1 + (i-1) * colint 
		}
		for (i in 1:nr) {
			row <- 1 + (i-1) * rowint
			raster <- .raster.read.row(raster, row)
			if (i == 1) {
				dd <- t(raster@data@values[cols])
			} else {
				dd <- rbind(dd, raster@data@values[cols])
			}
		}	
	}
	return(dd)
}


#read data on the raster for xy coordinates
read.xy <- function(raster, xy) {
	if (!is.matrix(xy)) { xy <- as.matrix(t(xy)) }
	if (raster@file@driver == 'raster') {
		cells <- get.cell.from.xy(raster, xy)
		return(read.cells(raster, cells))
	}
	else {
		colrow <- matrix(ncol=5, nrow=length(xy[,1]))
		valuename <- raster@file@shortname
		if (valuename == "") {valuename <- "value" }
		colnames(colrow) <- c("id", "colnr", "rownr", "cell", valuename)
		for  (i in 1:length(xy[,1])) {
			colrow[i,1] <- i
			colrow[i,2] <- get.col.from.x(raster, xy[i,1])
			colrow[i,3] <- get.row.from.y(raster, xy[i,2])
			colrow[i,4] <- get.cell.from.xy(raster, xy[i,])	
			colrow[i,5] <- NA
		}	
		rows <- na.omit(unique(colrow[order(colrow[,3]), 3]))
		for (i in 1:length(rows)) {
			raster <- .raster.read.row(raster, rows[i])
			thisrow <- subset(colrow, colrow[,3] == rows[i])
			for (j in 1:length(thisrow[,1])) {
				thisrow[j,5] <- raster@data@values[thisrow[j,2]]
				colrow[colrow[,4]==thisrow[j,4],5] <- thisrow[j,5]
			}	
		}
		return(colrow[,4:5]) 
	}	
}	

#read data on the raster for cell numbers
read.cells <- function(raster, cells) {
	if (raster@file@driver == 'gdal') {
		xy <- get.xy.from.cell(raster, cells)
		return(read.xy(raster, xy))
	} else {
		id <- seq(1:length(cells))
		value <- NA
		cells <- cbind(id, cells, value)
	
		valuename <- raster@file@shortname
		if (valuename == "") {valuename <- "value" }
		colnames(cells) <- c("id", "cell", valuename)

		uniquecells <- na.omit(unique(cells[order(cells[,2]),2]))
		uniquecells <- uniquecells[(uniquecells > 0) & (uniquecells <= ncells(raster) )]
	
		rastergri <- file.change.extension(filename(raster), ".gri")
		if (!file.exists(raster@file@name)) { stop(paste(filename(raster)," does not exist")) }
		con <- file(rastergri, "rb")

		for (i in 1:length(uniquecells)) {
			seek(con, (uniquecells[i]-1) * raster@file@datasize)
			if (raster@file@datatype == "integer") { dtype <- integer() } else { dtype <- numeric() }
				result <- readBin(con, what=dtype, n=1, size=raster@file@datasize, endian=raster@file@byteorder) 
			cells[cells[,2]==uniquecells[i], 3] <- result
		}
		close(con)
		cells[cells[,3] <=  max(-3e+38, raster@file@nodatavalue)] <- NA
		return(cells[,2:3])
	}	
}



