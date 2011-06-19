# Author: Robert J. Hijmans
# Date : May 2010
# Version 0.1
# Licence GPL v3


.getDBFHeader <- function(fn) {
# based on read.dbf by Ben Stabler
# in shapefiles pacakge
    extension(fn) <- '.dbf'
	f <- file(fn, "rb")
	on.exit(close(f))
	dbf <- new('.GeoAttributesDBF')
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

	fn <- shp@file
	extension(fn) <- '.dbf'
	f <- file(fn, "rb")
    on.exit(close(f))
	off <- shp@att@header.length + (start-1) * shp@att@record.length
	seek(f, off)
	n <- nrec * shp@att@record.length
	rawbin <- readBin(f, "raw", n=n)
	reclng <- shp@att@record.length
	
	getRec <- function(i) {
		from <- reclng * (i-1) + 1
		to <- from + reclng
		recbin <- rawbin[from:to]
		readBin(recbin, "character", 1)
	}

	records <- lapply(1:nrec, function(x) getRec(x))
	rm(rawbin)
	
	z <- matrix(ncol=shp@att@nfields, nrow=nrec)
	colnames(z) <- shp@att@fields$NAME
	
	if (ncol(z) > 1) {
		x <- shp@att@fields$LENGTH
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
	for (i in 1:nrow(shp@att@fields)) {
		if (shp@att@fields[i,2]=='C') {
			z[,i] <- trim(z[,i])
			z[z[,i]=="", i] <- NA
		} else if (shp@att@fields[i,2]=='F') {
			z[,i] <- as.numeric(z[,i])
		} else if (shp@att@fields[i,2]=='N') {
			z[,i] <- as.integer(z[,i])
		} else if (shp@att@fields[i,2]=='D') {		
			z[,i] <- as.Date(z[,i], format="%Y%m%d")
		}
	}
	z
}
 
