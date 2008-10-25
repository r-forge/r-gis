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

#raster.change.merge <- function(raster1, raster2, filename, overwrite=FALSE) {
	#check resolution
	#check origin
	#if raster1 overlaps all of raster2 return raster1
	#if there is no overlap combine
	#if there is some overlap raster1 values are used in those places (
#	stop("sorry, not implemented yet")
#}

raster.change.cut.with.raster <- function(raster, cutraster, filename="", overwrite=FALSE) {
	return(raster.change.cut(raster, raster.xmin(cutraster), raster.xmax(cutraster), raster.ymin(cutraster), raster.ymax(cutraster), filename, overwrite))
}



raster.change.cut <- function(raster, xmin, xmax, ymin, ymax, filename='', overwrite=FALSE) {
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
	
#	xmin <- round(xmin/raster@xres)*raster@xres
#	xmax <- round(xmax/raster@xres)*raster@xres
#	ymin <- round(ymin/raster@yres)*raster@yres
#	ymax <- round(ymax/raster@yres)*raster@yres
	
	if (xmin == xmax) {stop("xmin and xmax are less than one cell apart")}
	if (ymin == ymax) {stop("ymin and ymax are less than one cell apart")}
	
	ncols <- round((xmax-xmin) / raster.xres(raster) ) 
	nrows <- round((ymax-ymin) / raster.yres(raster) )
	outraster <- raster.new(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, nrows=nrows, ncols=ncols, projection=raster@proj4string )
	outraster <- raster.set.filename(outraster, filename)
	outraster <- raster.set.datatype(outraster, raster@file@datatype)

	
	if (raster@data@content == 'all')  {
		first.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster.xres(raster), ymax - 0.5 * raster.yres(raster) ))	
		last.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster.xres(raster), ymin + 0.5 * raster.yres(raster) ))
		start.cells <- seq(first.start.cell, last.start.cell, by = raster@ncols)
		end.cells <- start.cells + ncols - 1
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


raster.change.aggregate <- function(raster, fun = mean, factor = 2, expand = TRUE, rm.NA = TRUE, INT = FALSE, filename="", overwrite=FALSE) 
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


