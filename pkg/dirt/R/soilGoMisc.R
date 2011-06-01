
.mergeSoilRaster <- function(r, d, props, filename='', ...) {
	stopifnot(require(raster))
    if (is.character(r)) {
		r <- raster(r)
    }
    r <- subs(r, d[ , c('mukey', props)], by = 1, which=1:length(props)+1, filename=filename, ...)
    r
}


.mergeSoilPol <- function(sp, d, filename='') {
    if (is.character(sp)) {
		if (!(require(rgdal))) {
			stop("To read a shapefile you need the rgdal package; please install it")  
		}
		fn <- basename(sp)
        fn <- substr(fn, 1, nchar(fn)-4)
        sp <- readOGR(dirname(sp), fn)
	}
    if (! inherits(sp, 'SpatialPolygonsDataFrame')) {
        warning('not a good sp object (should be a SpatialPolygonsDataFrame), returning data.frame')
        return(d)
    }
	spd <- cbind(myid=1:nrow(sp@data), sp@data)
	i <- which(toupper(colnames(spd)) == 'MUKEY')
    if (length(i)==0) { stop('polygon attributes do not have a MUKEY field') }
	spd <- merge(spd, d, by.x=i[1], by.y=1, all.x=TRUE)
	spd <- spd[order(spd[,2]), -2]
	colnames(spd) <- .fixNames(colnames(spd))
	sp@data <- spd
	if (filename != '') {
		writeOGR(sp, filename, "soil", "ESRI Shapefile")
	} else {
		return(sp)
	}
}



.fixNames <- function(x) {
    n <- gsub('^[[:space:]]+', '',  gsub('[[:space:]]+$', '', x) )
    nn <- n
    n <- gsub('[^[:alnum:]]', '_', n)
    n[nchar(n) > 10] <- gsub('_', '', n[nchar(n) > 10])
    n[n==''] <- 'field'
    n <- gsub('^[^[:alpha:]]', 'X', n)
    n <- substr(n, 1, 10)

       # duplicate names
    nn  <- as.matrix(table(n))
    i <- which(nn > 1)
    if (! is.null(i)) {
        names <- rownames(nn)[i]
        n[n %in% names] <- substr(n[n %in% names], 1, 9)
        n <- make.unique(n, sep = "")
    }
	i <- x == n
    if (! all(i)) {
		x <- rbind(x, n)
		x <- x[, !i]
        rownames(x) = c('original name', 'adjusted name')
        print(x)
    }
    return(n)
}

