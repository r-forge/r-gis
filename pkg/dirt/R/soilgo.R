
soilGo <- function(dat, depth=10, props=c("om_r", "claytotal_h", "claytotal_l"), sp = NULL, raster=NULL, ... ) {
    props <- unique(props)
	if (tolower(substr(dat, nchar(dat)-3, nchar(dat))) == '.mdb') {
		d <- .getSoilGoAccess(dat, props)
	} else {
		d <- .getSoilGoTxt(dat, props)
	}
	ddd <- .processGo(d, depth, props)
	
    if (!is.null(raster)) {
		require(raster)
        if (is.character(raster)) {
			raster <- raster(raster)
        }
        raster <- subs(raster, ddd[ , c('mukey', props)], by = 1, which=1:length(props)+1, filename=filename, ...)
        return(raster)
    } else if (!is.null(sp)) {
		.mergeSoilPol(sp, ddd)
	} else {
        return(ddd)
    }
}



.mergeSoilPol <- function(sp, ddd) {
    if (is.character(sp)) {
		if (!(require(rgdal))) { stop("To use the 'sp' option, you need the rgdal package; please install it")  }
		fn <- basename(sp)
        fn <- substr(fn, 1, nchar(fn)-4)
        sp <- readOGR(dirname(sp), fn)
	}
    if (! inherits(sp, 'SpatialPolygonsDataFrame')) {
        warning('not a good sp object (should be a SpatialPolygonsDataFrame), returning data.frame')
        return(ddd)
    }
    if (length(i)==0) { stop('polygon attributes do not have a MUKEY field') }
	i <- i[0]
	spd <- cbind(1:nrow(sp@data), sp@data)
	i <- which(toupper(colnames(spd)) == 'MUKEY')
	spd <- merge(spd, ddd, by.x=i, by.y=1, all.x=TRUE)
	spd <- spd[order(spd[,2]), -c(2:4)]
	colnames(spd) <- .fixNames(colnames(spd))
	sp@data <- spd

	if (filename == "") {
		return(sp)
	} else {
		writeOGR(sp, filename, 'soil', 'ESRI Shapefile')
	}
}

