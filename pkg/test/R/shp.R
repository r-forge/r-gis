

setClass('VectorLayer',
	representation (
		filename = 'character',
		hdr = '.ShpHdr',
		dbf = '.DBF',
		nrecords = 'integer',
		index = 'matrix',
		crs = 'CRS'		
	)
)


setClass('.ShpHdr',
	representation (
		code = 'integer',
		length = 'integer',
		version = 'integer',
		type = 'integer',
		xmin = 'numeric',
		xmax = 'numeric',
		ymin = 'numeric',
		ymax = 'numeric',
		zmin = 'numeric',
		zmax = 'numeric',
		mmin = 'numeric',
		mmax = 'numeric'
	)
)


setClass('.DBF',
	representation (
		file.version = 'integer',
		file.date = 'character',
		nrecords = 'integer',
		nfields = 'integer',
		header.length = 'integer',
		record.length = 'integer',
		fields = 'data.frame'
	)
)


.shptype <- function(x) {
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

setMethod ('show' , 'VectorLayer', 
	function(object) {
		cat('class       :' , class(object), '\n')
		cat('filename    :' , object@filename, '\n')
		cat('type        :' , .shptype(object@hdr@type), '\n')
		cat('nrecords    :' , object@nrecords, '\n')
		cat('nfields     :' , object@dbf@nfields, '\n')
		cat('coord. ref. :' , projection(object, TRUE), '\n')
	}
)	


setMethod('dimnames', signature(x='VectorLayer'), 
function(x) { 
		return(list(NULL, x@dbf@fields$NAME)) 
	} 
)


setMethod('dimnames', signature(x='SpatialPolygonsDataFrame'), 
function(x) { 
		dimnames(x@data)
	} 
)


.shxHeader <- function(fn) {
# based on read.shx by Ben Stabler
# in shapefiles pacakge
	extension(fn) <- '.shx'
    f <- file(fn, "rb")
    on.exit(close(f))
	hdr <- new('.ShpHdr')
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
	hdr
}


.shxIndex <- function(shp) {
# based on read.shx by Ben Stabler
# in shapefiles pacakge
	fn <- shp@filename
	extension(fn) <- '.shx'
	f <- file(fn, "rb")
    on.exit(close(f))
	seek(f, 100)
    shp@nrecords <- as.integer((shp@hdr@length - 50)/4)
	shp@index <- matrix(readBin(f, "integer", 2 * shp@nrecords, endian = "big"), ncol=2, byrow=TRUE) * 2
    colnames(shp@index) <- c("Offset", "Length")
	shp
}


.dbfHeader <- function(fn) {
# based on read.dbf by Ben Stabler
# in shapefiles pacakge
    extension(fn) <- '.dbf'
	f <- file(fn, "rb")
	on.exit(close(f))
	dbf <- new('.DBF')
	dbf@file.version <- readBin(f, integer(), 1, size = 1,  endian = "little")
    year <- readBin(f, integer(), 1, size = 1, endian = "little")
    month <- readBin(f, integer(), 1, size = 1, endian = "little")
    day <- readBin(f, integer(), 1, size = 1, endian = "little")
	dbf@file.date <- paste(year, "-", month, "-", day, sep="")
    dbf@nrecords <- readBin(f, integer(), 1, size = 4, endian = "little")
    dbf@header.length <- readBin(f, integer(), 1, size = 2, endian = "little")
    dbf@record.length <- readBin(f, integer(), 1, size = 2, endian = "little")
    file.temp <- readBin(f, integer(), 20, size = 1, endian = "little")
 
	dbf@nfields <- as.integer((dbf@header.length - 32 - 1)/32)
    field.name <- NULL
    field.type <- NULL
    field.length <- NULL
    field.decimal <- NULL
    for (i in 1:dbf@nfields) {
        field.name.test <- readBin(f, character(), 1, size = 10, endian = "little")
        field.name <- c(field.name, field.name.test)
        if (nchar(field.name.test) != 10) {
            file.temp <- readBin(f, integer(), 10 - (nchar(field.name.test)), 1, endian = "little")
        }
        field.type <- c(field.type, readChar(f, 1))
        file.temp <- readBin(f, integer(), 4, 1, endian = "little")
        field.length <- c(field.length, readBin(f, integer(), 1, 1, endian = "little"))
        field.decimal <- c(field.decimal, readBin(f, integer(), 1, 1, endian = "little"))
        file.temp <- readBin(f, integer(), 14, 1, endian = "little")
    }
    fields <- data.frame(NAME = field.name, TYPE = field.type, LENGTH = field.length, DECIMAL = field.decimal, stringsAsFactors=FALSE)
    fields$LENGTH[fields$LENGTH < 0] <- (256 + fields$LENGTH[fields$LENGTH < 0])
    file.temp <- readBin(f, integer(), 1, 1, endian = "little")
    fields$LENGTH[1] <- fields$LENGTH[1] + 1
    dbf@fields <- fields
	dbf
 }



.dbfRecords <- function(shp, start, end) {
	start <- min(max(1, start), shp@nrecords)
	stopifnot(!is.na(start))
	if (missing(end)) { end <- shp@nrecords	}
	end <- min(max(1, end), shp@nrecords)
	stopifnot(!is.na(end))
	stopifnot(end >= start)
	nrec <- end - start + 1

	fn <- shp@filename
	extension(fn) <- '.dbf'
	f <- file(fn, "rb")
    on.exit(close(f))
	seek(f, shp@dbf@header.length)
	n <- nrec * shp@dbf@record.length
	rawb <- readBin(f, "raw", n=n)
	records <- list(length=nrec)
	a <- 1
	i <- 1
	for (j in start:end) {
		b <- a + shp@dbf@record.length - 1
		recb <- rawb[a:b]
		records[[i]] = readBin(recb, "character", 1)
		a <- b + 1
		i <- i + 1
	}
	rm(recb)
	z <- matrix(ncol=shp@dbf@nfields, nrow=nrec)
	colnames(z) <- shp@dbf@fields$NAME
	
	if (ncol(z) > 1) {
		x <- shp@dbf@fields$LENGTH
		from <- cumsum(c(1,x[-length(x)]))
		to <- from+x-1
		for (i in 1:length(records)) {
			a <- records[[i]]
			for (j in 1:length(from)) {
				z[i,j] <- substr(a, from[j], to[j])
			}
		}
	} else {
		for (i in 1:length(records)) {
			z[,1] <- unlist(records)
		}
	}

	z[z=="************************"] <- NA
	z <- data.frame(z, stringsAsFactors=FALSE)
	for (i in 1:nrow(shp@dbf@fields)) {
		if (shp@dbf@fields[i,2]=='N') {
			z[,i] <- as.integer(z[,i])
		} else if (shp@dbf@fields[i,2]=='F') {
			z[,i] <- as.numeric(z[,i])
		} else if (shp@dbf@fields[i,2]=='C') {
			x <- trim(z[,i])
			z[z[,i]=="", i] <- NA
		} else if (shp@dbf@fields[i,2]=='D') {		
			z[,i] <- as.Date(z[,i], format = "%Y%m%d")
		}
	}
	z
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
	
	fn <- shp@filename
	extension(fn) <- '.shp'
	f <- file(fn, "rb")
    on.exit(close(f))
	seek(f, shp@index[start,1])
	nrec <- end - start + 1
	n <- shp@index[end,1] + shp@index[end,2] - shp@index[start,1] + 8
	rawb <- readBin(f, "raw", n=n)

	if (shp@hdr@type == 1) {
		res <- matrix(NA, nrow=(end-start+1), ncol=2)
		j <- 1
		for (i in start:end) {
			a <- shp@index[i,1] - shp@index[start,1] + 1
			b <- a + shp@index[i,2] + 8
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
		
    } else if (shp@hdr@type == 3 || shp@hdr@type == 5 || shp@hdr@type == 13 || shp@hdr@type == 15) {
	
        shape <- list()
		seek(f, shp@index[start,1])
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




getShapes <- function(shp, start, end, sp=TRUE) {
	geo <- .shpRecords(shp, start, end)
	rec <- .dbfRecords(shp, start, end)
	if (sp) {
	
		if (shp@hdr@type==1) {
		
			geo <- SpatialPointsDataFrame(geo, data=rec)
			return(geo)
			
		} else if (shp@hdr@type==5) {

			npol <- length(geo)
			pols <- list()
			for (i in 1:npol) {
				subp <- list()
				npart <- geo[[i]]$num.parts
				idx <- c(geo[[i]]$parts, geo[[i]]$num.points)
				for (j in 1:npart) {
					p <- geo[[i]]$points[(idx[i]+1):idx[i+1], ]
					subp <- c(subp, Polygon( p ))
				}
				pols <- c(pols, Polygons( subp, as.character(i)) )
			}
			# to do: hole detection
			pols <- SpatialPolygons( pols )
			pols <- SpatialPolygonsDataFrame(pols, rec)	
			return(pols)
			
		} else if (shp@hdr@type==3) {

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

 
shape <- function(fn) {
	require(raster)
	x <- new('VectorLayer')
	extension(fn) <- 'shp'
	x@filename <- fn
	x@hdr <- .shxHeader(fn)
	x <- .shxIndex(x)
	x@dbf <- .dbfHeader(fn)
	x
}


#fn <- "MEX_adm1.shp"
#x <- shape(fn)
#d <- getShapes(x, 5, 13)
#plot(d)


