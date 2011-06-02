# Author: Robert J. Hijmans
# May 2011
# Version 1.0
# Licence GPL v3


soilGo <- function(dat, depth=10, props=c("om_r", "claytotal_h"), filename='', overwrite=FALSE, sp = NULL, raster=NULL, verbose=TRUE, ... ) {

    ext <- tolower(substr(dat, nchar(dat)-3, nchar(dat)))
	if (!ext %in% c('.zip', '.mdb')) {
		stop('"dat" should be a .zip file or an access (.mdb) file')
	}
	props <- unique(props)
	
	if (ext == '.mdb') {
		d <- .getSoilGoAccess(dat, props)
		
	} else if (ext == '.zip') {
		wdir <- paste(dirname(tempdir()), "/R_dirt_ssurgo_tmp", sep = "")
		x <- unzip(dat, exdir=wdir)
		dat  <- substr(basename(dat), 1, nchar(dat)-4)
		dat <- paste(wdir, '/', dat, '/tabular', sep="")
		d <- .getSoilGoTxt(dat, props, ...)
		on.exit( unlink( wdir , recursive=TRUE) )
	} 
	
	d <- .processGo(d, depth, props)
	
    if (!is.null(raster)) {
	
		return(.mergeSoilRaster(raster, d, props, filename, overwrite=overwrite))
		
    } else if (!is.null(sp)) {
	
		if (isTRUE(sp)) {
		
			dat <- gsub('\\\\', '/', dat)
			tst <- tolower(substr(dat, nchar(dat)-6, nchar(dat)))
			if ( tst %in% c('abular/') ) {
				shp <- substr(dat, 1, nchar(dat)-8)
			} else if (tst == 'tabular') {
				shp <- substr(dat, 1, nchar(dat)-7)			
			} else {
				stop('cannot find shapefile')
			}
			sp <- unlist(strsplit(dat, '/'))
			sp <- sp[length(sp)-1]
			sp <- unlist(strsplit(sp, '_'))
			sp <- paste(shp, 'spatial/', sp[1], 'mu_a_', sp[2], '.shp', sep='')
			
		}
		return(.mergeSoilPol(sp, d, filename, overwrite=overwrite, verbose=verbose))
		
	} else if (filename!= '') {
		if (!overwrite & file.exists(filename)) {
			warning('file exists and "overwrite=FALSE". returning data.frame')
			return(d)
		}
		write.table(d, file=filename, row.names=FALSE, col.names=TRUE)
		
	} else {
	
        return(d)
		
    }
}
