# Author: Robert J. Hijmans
# Date : May 2010
# Version 0.1
# Licence GPL v3



.shpType <- function(x) {
	if (x==0) r <- "Null Shape"
	else if (x==1) r <- "Point"
	else if (x==3) r <- "PolyLine"
	else if (x==5) r <- "Polygon"
	else if (x==8) r <- "MultiPoint"
	else if (x==11) r <- "PointZ"
	else if (x==13) r <- "PolyLineZ"
	else if (x==15) r <- "PolygonZ"
	else if (x==18) r <- "MultiPointZ"
	else if (x==21) r <- "PointM"
	else if (x==23) r <- "PolyLineM"
	else if (x==25) r <- "PolygonM"
	else if (x==28) r <- "MultiPointM"
	else if (x==31) r <- "MultiPatch"
	else r <- "unknown"
	return(r)
}


.shpTypeSimple <- function(x) {
	if (x==0) r <- "null"
	else if (x==1) r <- "point"
	else if (x==3) r <- "line"
	else if (x==5) r <- "polygon"
	else if (x==8) r <- "point"
	else if (x==11) r <- "point"
	else if (x==13) r <- "line"
	else if (x==15) r <- "polygon"
	else if (x==18) r <- "point"
	else if (x==21) r <- "point"
	else if (x==23) r <- "line"
	else if (x==25) r <- "polygon"
	else if (x==28) r <- "point"
	else if (x==31) r <- "patch"
	else r <- "unknown"
	return(r)
}


.getShapeHeader <- function(fn, ext='.shx') {
# based on read.shx by Ben Stabler
# in shapefiles pacakge
	extension(fn) <- ext
    f <- file(fn, "rb")
    on.exit(close(f))
	hdr <- new('.GeoSpatialShape')
	hdr@code <- readBin(f, "integer", 1, endian = "big")
    unused <- readBin(f, "integer", 5, endian = "big")
    hdr@length <- readBin(f, "integer", 1, endian = "big")
    hdr@version <- readBin(f, "integer", 1, endian = "little")
    hdr@type <- readBin(f, "integer", 1, endian = "little")
	b <- readBin(f, "double", 8, endian = "little")
	hdr@xmin <- b[1]
    hdr@ymin <- b[2]
    hdr@xmax <- b[3]
    hdr@ymax <- b[4]
    hdr@zmin <- b[5]
    hdr@zmax <- b[6]
    hdr@mmin <- b[7]
    hdr@mmax <- b[8]
	seek(f, 100)
	hdr@nrecords <- as.integer((hdr@length-50)/4)
	hdr@index <- matrix(readBin(f, "integer", 2 * hdr@nrecords, endian = "big"), ncol=2, byrow=TRUE) * 2
    colnames(hdr@index) <- c("Offset", "Length")
	hdr
}



.shpRecords <- function(shp, start, end) {
# based on read.shp by Ben Stabler
# in shapefiles pacakge
	start <- min(max(1, start), shp@nrecords)
	stopifnot(!is.na(start))
	if (missing(end)) {
		end <- shp@nrecords
	}
	end <- min(max(1, end), shp@nrecords)
	stopifnot(!is.na(end))
	stopifnot(end >= start)
	
	fn <- shp@file
	extension(fn) <- '.shp'
	f <- file(fn, "rb")
    on.exit(close(f))
	
	seek(f, shp@vec@index[start,1])
	nrec <- end - start + 1
	n <- shp@vec@index[end,1] + shp@vec@index[end,2] - shp@vec@index[start,1] + 8
	rawb <- readBin(f, "raw", n=n)

	if (shp@vec@type == 1) {
		res <- matrix(NA, nrow=(end-start+1), ncol=2)
		j <- 1
		for (i in start:end) {
			a <- shp@vec@index[i,1] - shp@vec@index[start,1] + 1
			b <- a + shp@vec@index[i,2] + 8
			rawrec <- rawb[a:b]
			#x <- readBin(rawrec, "integer", 2, 4, endian = "big")
			# content.length <- x[2]  # *2
			#record.num <- x[1]
			record.num <- readBin(rawrec, "integer", 1, 4, endian = "big")
            if (record.num == 0) break
			shape.type <- readBin(rawrec[9:12], "integer", 1, 4, endian = "little")
			if (shape.type == 1) {
				res[j, ] <- readBin(rawrec[13:50], "double", 2, 8, endian = "little")
			} 
			j <- j + 1
        }
		return(res)
		
    } else if (shp@vec@type == 3 || shp@vec@type == 5 || shp@vec@type == 13 || shp@vec@type == 15) {
	
        shape <- list()
		seek(f, shp@vec@index[start,1])
		for (i in start:end) {
            record.num <- readBin(f, integer(), 1, endian = "big")
            if (length(record.num) == 0) 
                break
            content.length <- readBin(f, integer(), 1, endian = "big")
            shape.type <- readBin(f, integer(), 1, endian = "little")
            
			if (shape.type == 3 || shape.type == 5) {
                box <- readBin(f, double(), 4, endian = "little")
                names(box) <- c("xmin", "ymin", "xmax", "ymax")
                num.parts <- readBin(f, integer(), 1, endian = "little")
                num.points <- readBin(f, integer(), 1, endian = "little")
                parts <- readBin(f, integer(), num.parts, endian = "little")
                points <- readBin(f, double(), num.points * 2, endian = "little")
				points <- matrix(points, ncol=2, byrow=T)
				
            } else if (shape.type == 13 || shape.type == 15) {
                box <- readBin(f, double(), 4, endian = "little")
                names(box) <- c("xmin", "ymin", "xmax", "ymax")
                num.parts <- readBin(f, integer(), 1, endian = "little")
                num.points <- readBin(f, integer(), 1, endian = "little")
                parts <- readBin(f, integer(), num.parts, endian = "little")
                points <- readBin(f, double(), num.points * 2, endian = "little")
				points <- matrix(points, ncol=2, byrow=T)
    
				zrange <- readBin(f, double(), 2, endian = "little")
                Z <- readBin(f, double(), num.points, endian = "little")
                mrange <- readBin(f, double(), 2, endian = "little")
                M <- readBin(f, double(), num.points, endian = "little")
                points <- cbind(points, Z, M)
				
            } else if (shape.type == 0) {			
                box <- rep(NA, 4)
                num.parts <- NA
                num.points <- NA
                parts <- NA
                points <- data.frame(X = NA, Y = NA)
				
            }
            shape.info <- list(record = record.num, box = box, num.parts = num.parts, 
                num.points = num.points, parts = parts, points = points)
            shape <- c(shape, list(shape.info))
        }
		return(shape)
    }
}




.getShapes <- function(shp, start, end, sp=TRUE) {
	geo <- .shpRecords(shp, start, end)
	rec <- .dbfRecords(shp, start, end)
	if (sp) {
	
		if (shp@vec@type==1) {
		
			geo <- SpatialPointsDataFrame(geo, data=rec)
			return(geo)
			
		} else if (shp@vec@type==5) {
		
			getPols <- function(i) {
				npart <- geo[[i]]$num.parts
				idx <- c(geo[[i]]$parts, geo[[i]]$num.points)
				subp <- lapply(1:npart, function(j) Polygon(geo[[i]]$points[(idx[j]+1):idx[j+1], ]))
			# to do: hole detection
				list(Polygons( subp, as.character(i))) 
			}

			npol <- length(geo)
			pols <- SpatialPolygons( sapply(1:npol, function(x) getPols(x))	)
			pols <- SpatialPolygonsDataFrame(pols, rec)	
			return(pols)
			
		} else if (shp@vec@type==3) {

			nlns <- length(geo)
			lns <- list()
			for (i in 1:nlns) {
				subp <- list()
				npart <- geo[[i]]$num.parts
				idx <- c(geo[[i]]$parts, geo[[i]]$num.points)
				for (j in 1:npart) {
					p <- geo[[i]]$points[(idx[i]+1):idx[i+1], ]
					subp <- c(subp, Line( p ))
				}
				lns <- c(lns, Lines( subp, as.character(i)) )
			}
			# to do: hole detection
			pols <- SpatialLines( lns )
			pols <- SpatialLinesDataFrame(lns, rec)	
			return(lns)
			

		} else {
			warning('type not implemented')
			return(list(geo, rec))
		}
		
	} else {
	
		return(list(geo, rec))
		
	}
}


.existsShpFile <- function(f) {
	shp <- file.exists(extension(f, '.shp'))
	shx <- file.exists(extension(f, '.shx'))
	dbf <- file.exists(extension(f, '.dbf'))
	if (! shp & shx & dbf ) {
		stop('Shapefile does not exist or is incomplete')
	}
}


layer <- function(filename) {
	.existsShpFile(filename)
	hdr <- .getShapeHeader(filename) 
	type <- .shpTypeSimple(hdr@type)
	if (type == 'polygon') {
		x <- new('VectorLayerPolygons')
	} else if (type == 'line') {
		x <- new('VectorLayerLines')	
	} else if (type == 'point') {
		x <- new('VectorLayerPoints')
	} else {
		stop('unknown shp type')
	}
	extension(filename) <- 'shp'
	x@file <- filename
	x@driver <- 'shape'
	x@vec <- hdr
	x@att <- .getDBFHeader(filename) 
	x@nrecords <- as.integer((hdr@length-50)/4)
	if (x@att@nrecords != x@nrecords) {
		warning('number of attribute records does not much number of index file records. Shapfile might be invalid.')
	}
	prj <- extension(f, '.prj')
	if (file.exists(prj)) {
		prj <- unlist(readLines(prj, warn=FALSE))
		# now what?
		#crs = 
	}
	x
}

getVector <- function(layer, start=1, end, sp=TRUE) {
	start <- min( max(1, start), layer@nrecords )
	if (missing(end)) { end <- layer@nrecords }
	if (end < start) { end <- start }
	if (layer@driver == 'shape') {
		return(.getShapes(layer, start, end, sp=sp))
	}	
}

# fn <- "MEX_adm1.shp"
# x <- layer(fn)
# d <- getVector(x, 5, 13)
# plot(d)
