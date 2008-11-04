# R code for changing rasters (spatial data)
# Authors: Robert J. Hijmans and Jacob van Etten
# International Rice Research Institute
#contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,2
# Licence GPL v3


#r.resample <- function(raster, xmin, xmax, ymin, ymax, ncols, nrows, method="bilinear", filename="", overwrite=FALSE) {
#	stop("sorry, not implemented yet")
#	if (raster@data@content == 'all')  {
#	} else if (raster@data@source == 'disk')  {
#	}
#}



r.expand <- function(raster, boundingbox, filename="", overwrite=FALSE) {
	bbox <- boundingbox(boundingbox)
	res <- resolution(raster)
# snap points to pixel boundaries
	xmin <- round(bbox[1,1] / res[1]) * res[1]
	xmax <- round(bbox[1,2] / res[1]) * res[1]
	ymin <- round(bbox[2,1] / res[2]) * res[2]
	ymax <- round(bbox[2,2] / res[2]) * res[2]
	
# only expanding here, not cutting
	xmin <- min(xmin, xmin(raster))
	xmax <- max(xmax, xmax(raster))
	ymin <- min(ymin, ymin(raster))
	ymax <- max(ymax, ymax(raster))
	
	outraster <- set.raster(raster, filename)
	outraster <- set.bbox(outraster, xmin, xmax, ymin, ymax, keepres=T)

	startrow <- get.row.from.y(outraster, ymax(raster))
	startcol <- get.col.from.x(outraster, xmin(raster))
	
	if (data.content(raster) == 'all')  {
		d <- vector(length=ncells(outraster))
		d[] <- NA
		for (r in 1:nrow(raster)) {
			v <- get.row(raster, r) 
			startcell <- (r + startrow -2) * ncol(outraster) + startcol
			d[startcell:(startcell+ncol(raster)-1)] <- v
			outraster <- set.values(outraster, d)
		}
	} else if (data.source(raster) == 'disk')  {
		if (filename == "") {stop('invalid filename')}
		d <- vector(length=ncol(outraster))
		for (r in 1:nrow(raster)) {
			raster <- read.row(raster, r)
			v <- values(raster)
			d[] <- NA
			startcell <- (r + startrow -2) * ncol(outraster) + startcol
			d[startcell:(startcell+ncol(raster)-1)] <- v
			outraster <- set.values.row(outraster, d, r)
			outraster <- write.raster(outraster)
		}
	}
	return(outraster)
}



get.row <- function(raster, r) {
	if (data.content(raster) == 'sparse') {return (get.row.sparse(raster, r))
	} else if (data.content(raster) != 'all') {stop('cannot do. Need all data')
	} else {
		startcell <- get.cell.from.rowcol(raster, r, 1)
		endcell <- startcell+ncol(raster)-1
		return(values(raster)[startcell:endcell])
	}	
}


get.row.sparse <- function(raster, r, explode=TRUE) {
	if (data.content(raster) != 'sparse') {stop('cannot do. Need sparse')}
	startcell <- get.cell.from.rowcol(raster, r, 1)
	endcell <- startcell+ncol(raster)-1
	d <- cbind(data.indices(raster), values(raster))
	d <- d[d[,1] >= startcell & d[,1] <= endcell, ] 
	if (explode) { 
		cells <- startcell:endcell
		cells[] <- NA
		cells[d[,1]] <- d[,2]	
		return(cells)
	} else {
		return(d)
	}	
}


r.merge <- function(rasters, filename="", overwrite=FALSE) {
	res <- compare(rasters, rowcol=FALSE)
	
	for (i in 1:length(rasters)) {
		if (!(data.source(rasters[[i]]) == 'disk' | data.content(rasters[[i]]) == 'all' | data.content(rasters[[i]]) == 'sparse')) { 
			stop('rasters should be stored on disk or values should be in memory') 
		}
	}
	bb <- bbox(rasters[[1]])
	for (i in 2:length(rasters)) {
		bb2 <- bbox(rasters[[i]])
		bb[,1] <- pmin(bb[,1], bb2[,1])
		bb[,2] <- pmax(bb[,2], bb2[,2])
	}
	outrs <- set.raster(rasters[[1]], filename)
	outrs <- set.bbox(outrs, bb[1,1], bb[1,2], bb[2,1], bb[2,2], keepres=TRUE)

	rowcol <- matrix(0, ncol=3, nrow=length(rasters))
	for (i in 1:length(rasters)) {
		xy1 <- get.xy.from.cell(rasters[[i]], 1) # first row/col on old raster[[i]]
		xy2 <- get.xy.from.cell(rasters[[i]], ncells(rasters[[i]]) ) #last row/col on old raster[[i]]
		rowcol[i,1] <- get.row.from.y(outrs, xy1[2]) #start row on new raster
		rowcol[i,2] <- get.row.from.y(outrs, xy2[2]) #end row
		rowcol[i,3] <- get.col.from.x(outrs, xy1[1]) #start col
	}
	v <- vector(length=0)
	for (r in 1:nrow(outrs)) {
		rd <- as.vector(matrix(NA, nrow=1, ncol=ncol(outrs))) 
		for (i in length(rasters):1) {  #reverse order so that the first raster covers the second etc.
			if (r >= rowcol[i,1] & r <= rowcol[i,2]) { 
				if (rasters[[i]]@data@source == 'disk') {
					rasters[[i]] <- read.row(rasters[[i]], r + 1 - rowcol[i,1]) 
					d <- values(rasters[[i]])
				} else {
					d <- get.row(rasters[[i]], r + 1 - rowcol[i,1]) 
				}
				id2 <- seq(1:ncol(rasters[[i]])) + rowcol[i,3] - 1
				d <- cbind(id2, d)
				d <- na.omit(d)
				rd[d[,1]] <- d[,2]
			}		
		}
		if (filename != '') {
			outrs <- set.values.row(outrs, rd, r)
			outrs <- write.row(outrs, overwrite)
		} else {
			v <- c(v, rd)
		}
	}
	if (filename == '') { outrs <- set.values(outrs, v) }
	return(outrs)
}


r.cut <- function(raster, boundingbox, filename="", overwrite=FALSE) {
# we could also allow the raster to expand but for now let's not and first make a separate expand function
	bbox <- boundingbox(boundingbox)

	xmin <- max(bbox[1,1], xmin(raster))
	xmax <- min(bbox[1,2], xmax(raster))
	ymin <- max(bbox[2,1], ymin(raster))
	ymax <- min(bbox[2,2], ymax(raster))
	
	if (xmin == xmax) {stop("xmin and xmax are less than one cell apart")}
	if (ymin == ymax) {stop("ymin and ymax are less than one cell apart")}
	
	outraster <- set.raster(raster, filename)
	outraster <- set.bbox(outraster, xmin, xmax, ymin, ymax, keepres=T)
	
	if (raster@data@content == 'all')  {
		first.start.cell <- get.cell.from.xy(raster, c(xmin + 0.5 * xres(raster), ymax - 0.5 * yres(raster) ))	
		last.start.cell <- get.cell.from.xy(raster, c(xmin + 0.5 * xres(raster), ymin + 0.5 * yres(raster) ))
		start.cells <- seq(first.start.cell, last.start.cell, by = raster@ncols)
		end.cells <- start.cells + outraster@ncols - 1
		selected.cells <- unlist(mapply(seq, start.cells, end.cells))
		outraster@data@values <- raster@data@values[selected.cells]
		outraster@data@min <- min(raster@data@values, na.rm=TRUE)
		outraster@data@max <- max(raster@data@values, na.rm=TRUE)
		outraster@data@haveminmax <- TRUE
		outraster@data@content <- 'all'
		if (nchar(outraster@file@name) > 0 ) { outraster <- try(write.raster(outraster)) }		
	} else if (raster@data@source == 'disk')  {
		first.col <- get.col.from.x(raster, xmin + 0.5 * xres(outraster))
		first.row <- get.row.from.y(raster, ymax - 0.5 * yres(outraster))
		last.row <- first.row + outraster@nrows - 1
		rownr <- 1
		for (r in first.row:last.row) {
			raster <- read.part.of.row(raster, r, first.col, outraster@ncols )
			if (outraster@file@name == '') {
				if (r == first.row) {
					outraster@data@values  <- raster@data@values
					outraster@data@content <- 'all'
				} else {
					outraster@data@values  <- c(outraster@data@values, raster@data@values)
				}		
			} else {
				outraster <- set.values.row(outraster, raster@data@values, rownr)
				outraster <- write.row(outraster, overwrite)
			}	
			rownr <- rownr + 1
		} 
	}
	return(outraster)
}




r.disaggregate <- function(raster, factor=2, filename="", overwrite=FALSE) {
	factor <- round(factor)
	if (factor < 2) { stop('factor should be > 1') }
	outrs <- set.raster(raster)
	if ( data.content(raster) != 'all') { 
			stop('raster values should all be in memory for this version of raster.disaggregate()') 
	} else {
		outrs <- set.rowcol(outrs, nrow(raster) * factor, ncol(raster) * factor) 
		if ( data.content(raster)=='all') {
			cols <- rep(rep(1:ncol(raster), each=factor), times=raster@nrows * factor)
			rows <- rep(1:nrow(raster), each=raster@ncols*factor*factor)
			cells <- get.cell.from.rowcol(raster, rows, cols)
#			m <- matrix(cells, ncol=outrs@ncols, nrow=outrs@nrows, byrow=T)
			d <- values(raster)[cells]
			outrs <- set.values(outrs, d)
		}	
	}	
	return(outrs)
}


r.aggregate <- function(raster, factor = 2, fun = mean, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
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
	outraster <- set.rowcol(outraster, nrows=rsteps, ncols=csteps) 
	
	if (INT) { outraster <- set.datatype(outraster, 'integer')
	} else { outraster <- set.datatype(outraster, 'numeric') }
	if (raster@data@content == 'all') 
	{
		cols <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=raster@nrows)
		rows <- rep(1:rsteps,each=raster@ncols*factor)[1:ncells(raster)]
#		cell.index <- (csteps * (row.index - 1)) + col.index
		cells <- get.cell.from.rowcol(raster, rows, cols)
		
		if (rm.NA) {outraster@data@values <- as.vector(tapply(raster@data@values, cells, function(x){fun(na.omit(x))}))}
		else {outraster@data@values <- as.vector(tapply(raster@data@values, cells, fun))}

		outraster@data@min <- min(raster@data@values, na.rm=TRUE)
		outraster@data@max <- max(raster@data@values, na.rm=TRUE)
		outraster@data@haveminmax <- TRUE
		outraster@data@content <- 'all'
		if (nchar(outraster@file@name) > 0 ) { 
			outraster <- try(write.raster(outraster))
		}

	} else if (raster@data@source == 'disk') {
		cols <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=factor)
		newdata <- vector(length=rsteps*csteps)
		for (r in 1:rsteps) 
		{
			startrow <- 1 + (r - 1) * factor
			endrow <- min(raster@nrows, startrow + factor - 1)
			nrows <- endrow - startrow + 1
			data_selected_rows <- read.rows(raster, startrow = startrow, nrows = nrows)
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
				outraster <- set.values.row(outraster, values, rownr)
				outraster <- write.row(outraster, overwrite)
			}	
			rownr <- rownr + 1
		} 			
	}
	return(outraster)
}


