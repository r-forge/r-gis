# R code for changing rasters (spatial data)
# Authors: Robert J. Hijmans and Jacob van Etten
# International Rice Research Institute
#contact: r.hijmans@gmail.com
# Date : October 2008
# Version 0,2
# Licence GPL v3



#raster.change.disaggregate <- function(raster, filename, fun=mean, factor=2, overwrite=FALSE) {
#	stop("sorry, not implemented yet")
#}

#raster.change.resample <- function(raster, filename, xmin, xmax, ymin, ymax, ncols, nrows, method="bilinear", overwrite=FALSE) {
#	stop("sorry, not implemented yet")
#}

#raster.change.expand <- function(raster, xmin, xmax, ymin, ymax, filename=NA, overwrite=FALSE) {
#	stop("sorry, not implemented yet")
#}


raster.merge <- function(rasters, filename, overwrite=FALSE) {
	#check resolution
	#check origin
	#check projection
	#if raster1 overlaps all of raster2 return raster1
	#if there is no overlap combine
	#if there is some overlap raster1 values are used in those places (
	bb <- bbox(rasters[[1]])
	for (i in 2:length(rasters)) {
		bb2 <- bbox(rasters[[i]])
		bb[,1] <- pmin(bb[,1], bb2[,1])
		bb[,2] <- pmax(bb[,2], bb2[,2])
	}
	outrs <- raster.set(rasters[[1]])
	outrs <- raster.set.bbox(outrs, bb[1,1],bb[1,2],bb[2,1],bb[2,2], keepres=TRUE)

	rowcol <- matrix(0, ncol=3, nrow=length(rasters))
	for (i in 1:length(rasters)) {
		xy1 <- raster.get.xy.from.cell(rasters[[i]], 1)
#		xy2 <- raster.get.xy.from.cell(rasters[[i]], raster.ncols(rasters[[i]]))
		xy3 <- raster.get.xy.from.cell(rasters[[i]], raster.ncells(rasters[[i]]) )
		rowcol[i,1] <- raster.get.row.from.y(outrs, xy1[2]) #start row
		rowcol[i,2] <- raster.get.row.from.y(outrs, xy3[2]) #end row
		rowcol[i,3] <- raster.get.col.from.x(outrs, xy1[1]) #start col
#		rowcol[i,4] <- raster.get.col.from.x(outrs, xy2[1]) #end col
	}
	
	for (r in 1:raster.nrows(outrs)) {
		rd <- as.vector(matrix(NA, nrow=1, ncol=raster.ncols(outrs))) 
		for (i in length(rasters):1) {
			if (r >= rowcol[i,1] & r <= rowcol[i,2]) { 
				rasters[[i]] <- raster.read.row(rasters[[i]], r + 1 - rowcol[i,1]) 
				d <- raster.values(rasters[[i]])
				id2 <- seq(1:raster.ncols(rasters[[i]])) + rowcol[i,3] - 1
				d <- cbind(id2, d)
				d <- na.omit(d)
				rd[d[,1]] <- d[,2]
			}		
		}
		outrs <- raster.set.data.row(outrs, rd, r)
		outrs <- raster.write.row(outrs)
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
	xmin <- max(xmin, raster.xmin(raster))
	xmax <- min(xmax, raster.xmax(raster))
	ymin <- max(ymin, raster.ymin(raster))
	ymax <- min(ymax, raster.ymax(raster))
	
	if (xmin == xmax) {stop("xmin and xmax are less than one cell apart")}
	if (ymin == ymax) {stop("ymin and ymax are less than one cell apart")}
	
	outraster <- raster.set(raster)
	outraster <- raster.set.bbox(outraster, xmin, xmax, ymin, ymax, keepres=T)
	outraster <- raster.set.filename(outraster, filename)
	
	if (raster@data@content == 'all')  {
		first.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster.xres(raster), ymax - 0.5 * raster.yres(raster) ))	
		last.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster.xres(raster), ymin + 0.5 * raster.yres(raster) ))
		start.cells <- seq(first.start.cell, last.start.cell, by = raster@ncols)
		end.cells <- start.cells + outraster@ncols - 1
		selected.cells <- unlist(mapply(seq, start.cells, end.cells))
		outraster@data@values <- raster@data[selected.cells]
		outraster@data@min <- min(raster@data@values, na.rm=TRUE)
		outraster@data@max <- max(raster@data@values, na.rm=TRUE)
		outraster@data@haveminmax <- TRUE
		outraster@data@content <- 'all'
		if (nchar(outraster@file@name) > 0 ) { outraster <- try(raster.write(outraster)) }
		
	} else {
		first.col <- raster.get.col.from.x(raster, xmin + 0.5 * raster.xres(outraster))
		first.row <- raster.get.row.from.y(raster, ymax - 0.5 * raster.yres(outraster))
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
				outraster <- raster.set.data.row(outraster, raster@data@values, rownr)
				outraster <- raster.write.row(outraster, overwrite)
			}	
			rownr <- rownr + 1
		} 
	}
	return(outraster)
}


raster.aggregate <- function(raster, fun = mean, factor = 2, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
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
	yexpansion <- (rsteps * factor - raster@nrows)  * raster.xres(raster)
	xexpansion <- (csteps * factor - raster@ncols) * raster.yres(raster)
		
	outraster <- raster.set.filename(raster, filename)
	outraster@bbox[1,2] <- raster.xmax(raster) + xexpansion
	outraster@bbox[2,1] <- raster.ymin(raster) - yexpansion
	outraster <- raster.set.rowcol(outraster, nrows=rsteps, ncols=csteps) 
	
	if (INT) { outraster <- raster.set.datatype(outraster, 'integer') }
	else { outraster <- raster.set.datatype(outraster, 'numeric') }
	if (raster@data@content == 'all') 
	{
		col.index <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=raster@nrows)
		row.index <- rep(1:rsteps,each=raster@ncols*factor)[1:raster.ncells(raster)]
		cell.index <- (csteps * (row.index - 1)) + col.index
		if (rm.NA) {outraster@data@values <- as.vector(tapply(raster@data@values, cell.index, function(x){fun(na.omit(x))}))}
		else {outraster@data@values <- as.vector(tapply(raster@data@values, cell.index, fun))}
		outraster@data@min <- min(raster@data@values, na.rm=TRUE)
		outraster@data@max <- max(raster@data@values, na.rm=TRUE)
		outraster@data@haveminmax <- TRUE
		outraster@data@content <- 'all'
		if (nchar(outraster@file@name) > 0 ) { outraster <- try(raster.write(outraster)) }
		
	} else if (raster@data@source == 'disk') {
		col.index <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=factor)
		new.data <- vector(length=rsteps*csteps)
		for (r in 1:rsteps) 
		{
			startrow <- 1 + (r - 1) * factor
			endrow <- min(raster@nrows, startrow + factor - 1)
			nrows <- endrow - startrow + 1
			data.selected.rows <- raster.read.rows(raster, startrow = startrow, nrows = nrows)
			raster@data@values <- as.vector(raster@data@values)
			col.index <- col.index[1:(nrows*raster@ncols)]
			row.index <- rep(startrow:endrow,each=raster@ncols*nrows)
			cell.index <- (as.integer(csteps * (row.index - 1)) + col.index)
			if (rm.NA) { values <- as.vector(tapply(raster@data@values,cell.index,function(x){fun(na.omit(x))}))}
			else { values <- as.vector(tapply(raster@data@values,cell.index,fun))}
			
			if (outraster@file@name == '') {
				if (r == 1) {
					outraster@data@values  <- values
					outraster@data@content <- 'all'
				} else {
					outraster@data@values  <- c(outraster@data@values, values)
				}		
			} else {
				outraster <- raster.set.data.row(outraster, values, rownr)
				outraster <- raster.write.row(outraster, overwrite)
			}	
			rownr <- rownr + 1
		} 			
	}
	return(outraster)
}


