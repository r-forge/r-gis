# Author: Robert J. Hijmans
# May 2011
# Version 1.0
# Licence GPL v3


.mergeSoilRaster <- function(r, d, props, filename='', ...) {
	stopifnot(require(raster))
    if (is.character(r)) {
		r <- raster(r)
    }
    r <- subs(r, d[ , c('mukey', props)], by = 1, which=1:length(props)+1, filename=filename, ...)
    r
}


.mergeSoilPol <- function(sp, d, filename='', overwrite=FALSE, verbose=TRUE, naValue=-9999) {

    if (is.character(sp)) {
		if (!(require(rgdal))) {
			stop("To read a shapefile you need the rgdal package; please install it")  
		}
		fn <- basename(sp)
        fn <- substr(fn, 1, nchar(fn)-4)
        sp <- readOGR(dirname(sp), fn, verbose=verbose)
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
	colnames(spd) <- raster:::.fixDBFNames(colnames(spd), verbose=verbose)
	sp@data <- spd
	
	if (filename != '') {
		extension(filename) <- '.shp'
		if (file.exists(filename)) {
			if (overwrite) {
				file.remove(filename)
				file.remove(extension(filename, '.dbf'))
				file.remove(extension(filename, '.shx'))
				
			} else {
				warning('file exists and "overwrite=FALSE". returning data.frame')
				return(d)
			} 
		}
		if (!is.na(naValue)) {
			sp@data[is.na(sp@data)] <- naValue
		}
		writeOGR(sp, filename, "soil", "ESRI Shapefile")
		return(invisible(sp))
	} else {
		return(sp)
	}
}


