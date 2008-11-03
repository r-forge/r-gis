raster.change.cut <- function(raster, xmin, xmax, ymin, ymax, filename=NA, overwrite=FALSE) {
	if (xmin > xmax) {
		x <- xmin
		xmin <- xmax
		xmax <- x
	}
	if (ymin > ymax) {
		y <- ymin
		ymin <- ymax
		ymax <- y
	}
	# we could also allow the raster to expand but for now let's make a separate expand function
	xmin <- max(xmin, raster@xmin)
	xmax <- min(xmax, raster@xmax)
	ymin <- max(ymin, raster@ymin)
	ymax <- min(ymax, raster@ymax)
	
	xmin <- round(xmin/raster@xres)*raster@xres
	xmax <- round(xmax/raster@xres)*raster@xres
	ymin <- round(ymin/raster@yres)*raster@yres
	ymax <- round(ymax/raster@yres)*raster@yres
	
	if (xmin == xmax) {stop("xmin and xmax are less than one cell apart")}
	if (ymin == ymax) {stop("ymin and ymax are less than one cell apart")}
	
	ncols <- round((xmax-xmin)/raster@xres) 
	nrows <- round((ymax-ymin)/raster@yres)
	cut.raster <- raster.create.new(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, nrows=nrows, ncols=ncols )
	if (!is.na(filename)) {cut.raster <- raster.set.filename(cut.raster, filename)} #This function should be able to take a NA as a valid argument
	else 
	{
		cut.raster@filename <- ""
	}
	raster <- raster.determine.datasource(raster, makearray=T)
	if (raster@datasource == 'array')  {
		first.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster@xres, ymax - 0.5 * raster@yres))	
		last.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster@xres, ymin + 0.5 * raster@yres))
		start.cells <- seq(first.start.cell, last.start.cell, by = raster@ncols)
		end.cells <- start.cells + ncols - 1
		selected.cells <- unlist(mapply(seq, start.cells, end.cells))
		cut.raster@data <- raster@data[selected.cells]
		cut.raster@minvalue <- min(cut.raster@data, na.rm=T)
		cut.raster@maxvalue <- max(cut.raster@data, na.rm=T)
	} else if (raster@datasource == 'file') {
		if (is.na(cut.raster@filename)) {  
			stop("output filename is not valid")
		} else {
			first.col <- raster.get.col.from.x(raster, xmin + 0.5 * cut.raster@xres)
			first.row <- raster.get.row.from.y(raster, ymax - 0.5 * cut.raster@yres)
			last.row <- first.row + cut.raster@nrows
			for (r in first.row:last.row) {
				raster <- raster.read.part.of.row(raster, r, first.col, cut.raster@ncols )
				cut.raster@data <- raster@data
				cut.raster <- raster.write.row(cut.raster)
			} 
		}
	}
	return(cut.raster)
}

raster.change.aggregate <- function(raster, fun = mean, factor = 2, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename=NA, overwrite=FALSE) 
{
	factor <- round(factor)
	if (factor < 2) {
		stop("factor should be > 1") }
	if (expand) {
		rsteps <- as.integer(ceiling(raster@nrows/factor))
		csteps <- as.integer(ceiling(raster@ncols/factor))
	} else 	{
		rsteps <- as.integer(floor(raster@nrows/factor))
		csteps <- as.integer(floor(raster@ncols/factor))
	}
	yexpansion <- (rsteps * factor - raster@nrows)  * raster@xres # formula modified
	xexpansion <- (csteps * factor - raster@ncols) * raster@yres # formula modified
		
	if (!is.na(filename)) {raster.aggregated <- raster.set.filename(raster, filename)} #This function should be able to take a NA as a valid argument
	else 
	{
		raster.aggregated <- raster
		raster.aggregated@filename <- ""
	}
	raster.aggregated@xmax <- raster@xmax + xexpansion
	raster.aggregated@ymin <- raster@ymin - yexpansion
	raster.aggregated <- raster.set.rowcol(raster.aggregated, nrows=rsteps, ncols=csteps) 
	
	if (INT) { raster.aggregated <- raster.set.datatype(raster.aggregated, "integer")  }
	else { raster.aggregated <- raster.set.datatype(raster.aggregated, "numeric") }
	
	raster <- raster.determine.datasource(raster, makearray=T)
	
	if (raster@datasource == 'array') 
	{
		names(raster@data) <- ""
		col.index <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=raster@nrows)
		row.index <- rep(1:rsteps,each=raster@ncols*factor)[1:raster@ncells]
		cell.index <- (csteps * (row.index - 1)) + col.index
		if (rm.NA) {raster.aggregated@data <- as.array(tapply(raster@data,cell.index,function(x){fun(na.omit(x))}))}
		else {raster.aggregated@data <- as.array(tapply(raster@data,cell.index,fun))}
		raster.aggregated@minvalue <- min(raster@data, na.rm=T)
		raster.aggregated@maxvalue <- max(raster@data, na.rm=T)
		
	}
	else if (raster@datasource == 'file' ) 
	{
		col.index <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=factor)
		new.data <- vector(length=rsteps*csteps)
		for (i in 1:rsteps) 
		{
			startrow <- 1 + (i - 1) * factor
			endrow <- min(raster@nrows, startrow + factor - 1)
			nrows <- endrow - startrow + 1
			data.selected.rows <- raster.read.rows(raster, startrow = startrow, nrows = nrows, band = raster@band)
			names(raster@data) <- ""
			col.index <- col.index[1:(nrows*raster@ncols)]
			row.index <- rep(startrow:endrow,each=raster@ncols*nrows)
			cell.index <- (as.integer(csteps * (row.index - 1)) + col.index)
			if (rm.NA) {raster.aggregated@data <- as.array(tapply(raster@data,cell.index,function(x){fun(na.omit(x))}))}
			else {raster.aggregated@data <- as.array(tapply(raster@data,cell.index,fun))}
			raster.aggregated <- raster.write.binary.row(raster.aggregated, i, overwrite=overwrite)
		}
	}
	return(raster.aggregated)
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
	raster@filename <- filename
	shortname <- misc.file.get.name(filename)
	shortname <- misc.file.change.extension(shortname, "")
	shortname <- gsub(" ", "_", shortname)
	if (raster@nbands > 1) { shortname <- paste(shortname,"_",raster@band) } 
	raster@rastername <- shortname
	return(raster)
}

raster.determine.datasource  <- function(raster, makearray=TRUE) {
	raster@datasource <- ''
	d <- dim(raster@data)
	if (length(d) == 1 ) {
		if (d[1] == raster@ncells) {
			raster@datasource <- 'array' 
		}
	} else if (length(d) == 2 ) {
		if (d[1] == raster@nrows && d[2] == raster@ncols) { 
			raster@datasource <- 'matrix'
			if (makearray) {
				raster@data <- array(t(raster@data))			
				raster@datasource <- 'array'
			}
		} else if (d[1] == raster@ncols && d[2] == raster@nrows) { 
			raster@datasource <- 'transmatrix'
			if (makearray) {
				raster@data <- array(raster@data)			
				raster@datasource <- 'array'
			}
		}
	} 
	if (raster@datasource == '') {
		if ( is.na(raster@filename) | length(raster@filename) == 0 ) { 
			raster@datasource <- 'nodata' 
		} else { raster@datasource <- 'file' } 
	}
	return(raster)
}

misc.file.get.name <- function(filename) {
#   fileandpath <- gsub("\\", "/", fileandpath)  HOW TO DO THIS??
	split <- strsplit(filename, "/")
	l <- length(split[[1]])
	shortfilename <- split[[1]][[l]]
	return(shortfilename)
}   


misc.file.get.extension <- function(filename) {
	lfn <- nchar(filename)
	extstart <- -1
	for (i in lfn : 2) {
		if (substr(filename, i, i) == ".") {
			extstart <- i
			break
		}
	}
	if (extstart > 0) {
		ext <- substr(filename, extstart, lfn)
	}
	else { ext <- "" }   
	return(ext)  
}   


misc.file.change.extension <- function(filename, newextension="") {
	lfn <- nchar(filename)
	newextension <- misc.string.trim(newextension)
	if (newextension != "" & substr(newextension, 1, 1) != ".") { newextension <- paste(".", newextension, sep="") }
	extstart <- -1
	for (i in lfn : 2) {
		if (substr(filename, i, i) == ".") {
			extstart <- i
			break 
		}
	}
	if (extstart > 0) {
		fname <- paste(substr(filename, 1, extstart-1), newextension, sep="")
	}
	else { fname <- paste(filename, newextension, sep="")   
	}
	return(fname)  
}   

setClass ("raster",
		representation (
				filename ="character",
				gdalhandle="list",
				rastername ="character",
				filetype ="character",
				datatype ="character",
				datasize ="integer",
				datasigned="logical",
				datanotation="character",
				byteorder ="character",
				valid ="logical",
				projection="character",
				nbands ="integer",
				band = "integer",
				bandorder ="character",
				ncols ="integer",
				nrows ="integer",
				ncells ="integer",
				ncellvals="integer",
				xres ="numeric",
				yres ="numeric",
				xmin ="numeric",
				xmax ="numeric",
				ymin ="numeric",
				ymax ="numeric",
				minvalue ="numeric",
				maxvalue ="numeric",
				nodatavalue ="numeric",
				data="array",
				datasource="character"
#		datablock="vector"
#		datamat ="matrix"
#		.data ="vector",
		),
		prototype (
				filename = "",
				gdalhandle= list(),
				rastername ="",
				filetype = "",
				datatype = "numeric",
				datasize = as.integer(4),
				datasigned= TRUE,
				datanotation="FLT4S",
				byteorder = .Platform$endian,
				valid = TRUE,
				projection= "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs",
				nbands = as.integer(1),
				band = as.integer(1),
				bandorder = "BSQ",
				ncols = as.integer(360),
				nrows = as.integer(180),
				ncells = as.integer(360 * 180),
				ncellvals = as.integer(360 * 180),
				xmin = -180,
				xmax = 180,
				ymin = -90,
				ymax = 90,
				xres =  1,
				yres =  1,
				minvalue = numeric (1),
				maxvalue = numeric (1),
				nodatavalue = -9999,
				data=array(NA,0),
				datasource=""
#		datablock=vector("integer", length=2)
		)
)

