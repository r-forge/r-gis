# R code for changing rasters (spatial data)
# Authors: Robert J. Hijmans and Jacob van Etten
# International Rice Research Institute
#contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,2
# Licence GPL v3


#raster.resample <- function(raster, xmin, xmax, ymin, ymax, ncols, nrows, method="bilinear", filename="", overwrite=FALSE) {
#	stop("sorry, not implemented yet")
#	if (raster@data@content == 'all')  {
#	} else if (raster@data@source == 'disk')  {
#	}
#}



raster.expand <- function(raster, xmin, xmax, ymin, ymax, filename="", overwrite=FALSE) {
	stop("sorry, not implemented yet")
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

	res <- resolution(raster)
# snap points to pixel boundaries
	xmin <- round(xmin / res[1]) * res[1]
	xmax <- round(xmax / res[1]) * res[1]
	ymin <- round(ymin / res[2]) * res[2]
	ymax <- round(ymax / res[2]) * res[2]
	
# only expanding here, not cutting
	xmin <- min(xmin, xmin(raster))
	xmax <- max(xmax, xmax(raster))
	ymin <- min(ymin, ymin(raster))
	ymax <- max(ymax, ymax(raster))
	
	outraster <- raster.set(raster)
	outraster <- set.bbox(outraster, xmin, xmax, ymin, ymax, keepres=T)
	outraster <- set.filename(outraster, filename)

	startrow <- raster.get.row.from.y(outraster, ymax(raster))
	startcol <- raster.get.col.from.x(outraster, xmin(raster))
	
	if (raster@data@content == 'all')  {
		d <- vector(length=ncells(outraster))
		d[] <- NA
		for (r in 1:nrows(raster)) {
			v <- raster@values@data[(r-1)*raster@ncols+1:r*raster@ncols]
			startcell <- ((startrow-1)*outraster@ncols)+((r-1)*raster@ncols) + startcol
			d[startcell:startcell+raster@ncols] <- v
		}
	} else if (raster@data@source == 'disk')  {
		if (filename == "") {stop('invalid filename')}
		d <- vector(length=ncols(outraster))
		for (r in 1:nrows(raster)) {
			raster <- raster.read.row(raster, 1)
			v <- values(raster)
			d[] <- NA
			startcell <- ((startrow-1)*outraster@ncols)+((r-1)*raster@ncols) + startcol
			d[startcell:(startcell+raster@ncols)] <- v
			outraster <- raster.set.values.row(outraster, d, r)
			outraster <- raster.write(outraster)
		}
	}
}




raster.merge <- function(rasters, filename, overwrite=FALSE) {
	
	res <- raster.compare(rasters, rowcol=FALSE)
	
	for (i in 1:length(rasters)) {
		if (rasters[[i]]@data@source != 'disk') { 
			stop('rasters should be stored on disk for this version of raster.merge()') 
		}
	}
	bb <- bbox(rasters[[1]])
	for (i in 2:length(rasters)) {
		bb2 <- bbox(rasters[[i]])
		bb[,1] <- pmin(bb[,1], bb2[,1])
		bb[,2] <- pmax(bb[,2], bb2[,2])
	}
	outrs <- raster.set(rasters[[1]])
	outrs <- set.filename(outrs, filename)
	outrs <- set.bbox(outrs, bb[1,1],bb[1,2],bb[2,1],bb[2,2], keepres=TRUE)

	rowcol <- matrix(0, ncol=3, nrow=length(rasters))
	for (i in 1:length(rasters)) {
		xy1 <- raster.get.xy.from.cell(rasters[[i]], 1) # first row/col on old raster[[i]]
		xy2 <- raster.get.xy.from.cell(rasters[[i]], ncells(rasters[[i]]) ) #last row/col on old raster[[i]]
		rowcol[i,1] <- raster.get.row.from.y(outrs, xy1[2]) #start row on new raster
		rowcol[i,2] <- raster.get.row.from.y(outrs, xy2[2]) #end row
		rowcol[i,3] <- raster.get.col.from.x(outrs, xy1[1]) #start col
	}
	
	for (r in 1:nrows(outrs)) {
		rd <- as.vector(matrix(NA, nrow=1, ncol=ncols(outrs))) 
		for (i in length(rasters):1) {  #reverse order so that the first raster covers the second etc.
			if (r >= rowcol[i,1] & r <= rowcol[i,2]) { 
				rasters[[i]] <- raster.read.row(rasters[[i]], r + 1 - rowcol[i,1]) 
				d <- values(rasters[[i]])
				id2 <- seq(1:ncols(rasters[[i]])) + rowcol[i,3] - 1
				d <- cbind(id2, d)
				d <- na.omit(d)
				rd[d[,1]] <- d[,2]
			}		
		}
		outrs <- raster.set.values.row(outrs, rd, r)
		outrs <- raster.write.row(outrs, overwrite)
	}
	return(outrs)
}


raster.cut.bbox <- function(raster, object, filename="", overwrite=FALSE) {
	bb <- bbox(object)
	return(raster.cut(raster, bb[1,1], bb[1,2], bb[2,1], bb[2,2], filename, overwrite))
}



raster.cut <- function(raster, xmin, xmax, ymin, ymax, filename='', overwrite=FALSE) {
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
	# we could also allow the raster to expand but for now let's not and first make a separate expand function
	xmin <- max(xmin, xmin(raster))
	xmax <- min(xmax, xmax(raster))
	ymin <- max(ymin, ymin(raster))
	ymax <- min(ymax, ymax(raster))
	
	if (xmin == xmax) {stop("xmin and xmax are less than one cell apart")}
	if (ymin == ymax) {stop("ymin and ymax are less than one cell apart")}
	
	outraster <- raster.set(raster)
	outraster <- set.bbox(outraster, xmin, xmax, ymin, ymax, keepres=T)
	outraster <- set.filename(outraster, filename)
	
	if (raster@data@content == 'all')  {
		first.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * xres(raster), ymax - 0.5 * yres(raster) ))	
		last.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * xres(raster), ymin + 0.5 * yres(raster) ))
		start.cells <- seq(first.start.cell, last.start.cell, by = raster@ncols)
		end.cells <- start.cells + outraster@ncols - 1
		selected.cells <- unlist(mapply(seq, start.cells, end.cells))
		outraster@data@values <- raster@data@values[selected.cells]
		outraster@data@min <- min(raster@data@values, na.rm=TRUE)
		outraster@data@max <- max(raster@data@values, na.rm=TRUE)
		outraster@data@haveminmax <- TRUE
		outraster@data@content <- 'all'
		if (nchar(outraster@file@name) > 0 ) { outraster <- try(raster.write(outraster)) }		
	} else if (raster@data@source == 'disk')  {
		first.col <- raster.get.col.from.x(raster, xmin + 0.5 * xres(outraster))
		first.row <- raster.get.row.from.y(raster, ymax - 0.5 * yres(outraster))
		last.row <- first.row + outraster@nrows - 1
		rownr <- 1
		for (r in first.row:last.row) {
			raster <- raster.read.part.of.row(raster, r, first.col, outraster@ncols )
			if (outraster@file@name == '') {
				if (r == first.row) {
					outraster@data@values  <- raster@data@values
					outraster@data@content <- 'all'
				} else {
					outraster@data@values  <- c(outraster@data@values, raster@data@values)
				}		
			} else {
				outraster <- raster.set.values.row(outraster, raster@data@values, rownr)
				outraster <- raster.write.row(outraster, overwrite)
			}	
			rownr <- rownr + 1
		} 
	}
	return(outraster)
}




raster.disaggregate <- function(raster, factor=2, filename="", overwrite=FALSE) {
	factor <- round(factor)
	if (factor < 2) { stop('factor should be > 1') }
	outrs <- raster.set(raster)
	if (raster.content(raster) != 'all') { 
			stop('raster values should all be in memory for this version of raster.disaggregate()') 
	} else {
		outrs <- raster.set.rowcol(outrs, nrows(raster) * factor, ncols(raster) * factor) 
		if (raster.content(raster)=='all') {
			cols <- rep(rep(1:ncols(raster), each=factor), times=raster@nrows * factor)
			rows <- rep(1:nrows(raster), each=raster@ncols*factor*factor)
			cells <- raster.get.cell.from.rowcol(raster, rows, cols)
#			m <- matrix(cells, ncol=outrs@ncols, nrow=outrs@nrows, byrow=T)
			d <- values(raster)[cells]
			outrs <- raster.set.values(outrs, d)
		}	
	}	
	return(outrs)
}


raster.aggregate <- function(raster, factor = 2, fun = mean, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
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
	yexpansion <- (rsteps * factor - raster@nrows)  * xres(raster)
	xexpansion <- (csteps * factor - raster@ncols) * yres(raster)
		
	outraster <- set.filename(raster, filename)
	outraster@bbox[1,2] <- xmax(raster) + xexpansion
	outraster@bbox[2,1] <- ymin(raster) - yexpansion
	outraster <- raster.set.rowcol(outraster, nrows=rsteps, ncols=csteps) 
	
	if (INT) { outraster <- raster.set.datatype(outraster, 'integer')
	} else { outraster <- raster.set.datatype(outraster, 'numeric') }
	if (raster@data@content == 'all') 
	{
		cols <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=raster@nrows)
		rows <- rep(1:rsteps,each=raster@ncols*factor)[1:ncells(raster)]
#		cell.index <- (csteps * (row.index - 1)) + col.index
		cells <- raster.get.cell.from.rowcol(raster, rows, cols)
		
		if (rm.NA) {outraster@data@values <- as.vector(tapply(raster@data@values, cells, function(x){fun(na.omit(x))}))}
		else {outraster@data@values <- as.vector(tapply(raster@data@values, cells, fun))}

		outraster@data@min <- min(raster@data@values, na.rm=TRUE)
		outraster@data@max <- max(raster@data@values, na.rm=TRUE)
		outraster@data@haveminmax <- TRUE
		outraster@data@content <- 'all'
		if (nchar(outraster@file@name) > 0 ) { 
			outraster <- try(raster.write(outraster))
		}

	} else if (raster@data@source == 'disk') {
		cols <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=factor)
		newdata <- vector(length=rsteps*csteps)
		for (r in 1:rsteps) 
		{
			startrow <- 1 + (r - 1) * factor
			endrow <- min(raster@nrows, startrow + factor - 1)
			nrows <- endrow - startrow + 1
			data_selected_rows <- raster.read.rows(raster, startrow = startrow, nrows = nrows)
			raster@data@values <- as.vector(raster@data@values)
			cols <- cols[1:(nrows * raster@ncols)]
			rows <- rep(startrow:endrow, each=raster@ncols * nrows)
			cells <- (as.integer(csteps * (rows - 1)) + cols)
			if (rm.NA) { values <- as.vector(tapply(raster@data@values, cells, function(x){fun(na.omit(x))}))}
			else { values <- as.vector(tapply(raster@data@values, cells, fun))}
			
			if (outraster@file@name == '') {
				if (r == 1) {
					outraster@data@values  <- values
					outraster@data@content <- 'all'
				} else {
					outraster@data@values  <- c(outraster@data@values, values)
				}		
			} else {
				outraster <- raster.set.values.row(outraster, values, rownr)
				outraster <- raster.write.row(outraster, overwrite)
			}	
			rownr <- rownr + 1
		} 			
	}
	return(outraster)
}


