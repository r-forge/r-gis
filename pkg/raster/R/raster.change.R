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
	return(raster.change.cut(raster, cutraster@xmin, cutraster@xmax, cutraster@ymin, cutraster@ymax, filename, overwrite))
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
	out.raster <- raster.create.new(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, nrows=nrows, ncols=ncols )
	out.raster <- raster.set.filename(out.raster, filename)
	out.raster <- raster.set.datatype(out.raster, raster@file@datatype)

	
	if (raster@data@content == 'all')  {
		first.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster@xres, ymax - 0.5 * raster@yres))	
		last.start.cell <- raster.get.cell.from.xy(raster, c(xmin + 0.5 * raster@xres, ymin + 0.5 * raster@yres))
		start.cells <- seq(first.start.cell, last.start.cell, by = raster@ncols)
		end.cells <- start.cells + ncols - 1
		selected.cells <- unlist(mapply(seq, start.cells, end.cells))
		out.raster@data@values <- raster@data[selected.cells]
		out.raster@data@min <- min(raster@data@values, na.rm=TRUE)
		out.raster@data@max <- max(raster@data@values, na.rm=TRUE)
		out.raster@data@haveminmax <- TRUE
		out.raster@data@content <- 'all'
		if (nchar(out.raster@file@name) > 0 ) { out.raster <- try(raster.write(out.raster)) }
		
	} else {
		first.col <- raster.get.col.from.x(raster, xmin + 0.5 * out.raster@xres)
		first.row <- raster.get.row.from.y(raster, ymax - 0.5 * out.raster@yres)
		last.row <- first.row + out.raster@nrows - 1
		rownr <- 1
		for (r in first.row:last.row) {
			raster <- raster.read.part.of.row(raster, r, first.col, out.raster@ncols )
			if (out.raster@file@name == '') {
				if (r == first.row) {
					out.raster@data@values  <- raster@data@values
					out.raster@data@content <- 'all'
				} else {
					out.raster@data@values  <- c(out.raster@data@values, raster@data@values)
				}		
			} else {
				out.raster@data@values <- raster@data@values
				out.raster <- raster.write.row(out.raster, rownr, overwrite)
				if (r == last.row ) {
					out.raster@data@content <- 'nodata'
					out.raster@data@values <- vector(length=0)
				}
			}	
			rownr <- rownr + 1
		} 
	}
	return(out.raster)
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
	yexpansion <- (rsteps * factor - raster@nrows)  * raster@xres # formula modified
	xexpansion <- (csteps * factor - raster@ncols) * raster@yres # formula modified
		
	out.raster <- raster.set.filename(raster, filename)
	out.raster@xmax <- raster@xmax + xexpansion
	out.raster@ymin <- raster@ymin - yexpansion
	out.raster <- raster.set.rowcol(out.raster, nrows=rsteps, ncols=csteps) 
	
	if (INT) { out.raster <- raster.set.datatype(out.raster, 'integer') 
	else { out.raster <- raster.set.datatype(out.raster, 'numeric') }
	if (raster@data@content == 'all') 
	{
		col.index <- rep(rep(1:csteps,each=factor)[1:raster@ncols],times=raster@nrows)
		row.index <- rep(1:rsteps,each=raster@ncols*factor)[1:raster@ncells]
		cell.index <- (csteps * (row.index - 1)) + col.index
		if (rm.NA) {out.raster@data@values <- as.vector(tapply(raster@data@values, cell.index, function(x){fun(na.omit(x))}))}
		else {out.raster@data@values <- as.vector(tapply(raster@data@values, cell.index, fun))}
		out.raster@data@min <- min(raster@data@values, na.rm=TRUE)
		out.raster@data@max <- max(raster@data@values, na.rm=TRUE)
		out.raster@data@haveminmax <- TRUE
		out.raster@data@content <- 'all'
		if (nchar(out.raster@file@name) > 0 ) { out.raster <- try(raster.write(out.raster)) }
		
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
			
			if (out.raster@file@name == '') {
				if (r == 1) {
					out.raster@data@values  <- values
					out.raster@data@content <- 'all'
				} else {
					out.raster@data@values  <- c(out.raster@data@values, values)
				}		
			} else {
				out.raster@data@values <- values
				out.raster <- raster.write.row(out.raster, rownr, overwrite)
				if (r == rsteps ) {
					out.raster@data@content <- 'nodata'
					out.raster@data@values <- vector(length=0)
				}
			}	
			rownr <- rownr + 1
		} 			
	}
	return(out.raster)
}
