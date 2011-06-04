# Author: Robert J. Hijmans
# May 2011
# Version 1.0
# Licence GPL v3


soilGo <- function(dat, dpfrom=0, dpto=15, props=c("om_r", "claytotal_h"), sp=TRUE, raster=FALSE, filename='', overwrite=FALSE,  verbose=TRUE, ... ) {

	stopifnot(dpto > dpfrom)
	
    ext <- tolower(extension(dat))
	if (!ext %in% c('.zip', '.mdb')) {
		stop('"dat" should be a .zip file or an access (.mdb) file')
	}
	props <- unique(props)
	
	if (ext == '.mdb') {
		d <- .getSoilGoAccess(dat, props)
		
	} else if (ext == '.zip') {
		wdir <- paste(tempdir(), "/R_dirt_ssurgo_tmp", sep = "")
		wdir <- gsub('\\\\', '/', wdir)
		on.exit( unlink( wdir , recursive=TRUE) )
		x <- unzip(dat, exdir=wdir)
		x <- gsub(paste(wdir, '/', sep=''), '', x)
		x <- strsplit(x, '/')
		hasTabular <- sum(sapply(x, function(y)y[2] == 'tabular')) > 10
		if (!hasTabular) {
			stop('zip file has no tabular data')
		}
		hasSpatial <- sum(sapply(x, function(y)y[2] == 'spatial')) > 2
		if (!hasSpatial) {
			if (isTRUE(sp)) {
				warning('zip file has no spatial data')
				sp <- FALSE
				filename <- ''
			}
		}
		
		dat <- extension(basename(dat), '')
		dat <- paste(wdir, '/', dat, '/tabular', sep="")
		if (!file.exists(dat)) {
			stop('contents of zip file do not seem to be SSURGO or STATSGO data')
		}
		d <- .getSoilGoTxt(dat, props, ...)
	} 
	
	d <- .processGo(d, dpfrom, dpto, props)
	
    if (isTRUE(sp)) {
	
		dat <- gsub('\\\\', '/', dat)
		# remove 'tabular'
		shp <- substr(dat, 1, nchar(dat)-7)			
		sp <- unlist(strsplit(dat, '/'))
		sp <- sp[length(sp)-1]
		sp <- unlist(strsplit(sp, '_'))
		sp <- paste(shp, 'spatial/', sp[1], 'mu_a_', sp[2], '.shp', sep='')
		return(.mergeSoilPol(sp, d, filename, overwrite=overwrite, verbose=verbose))
		
    } else if (isTRUE(raster)) {
	
		return(.mergeSoilRaster(raster, d, props, filename, overwrite=overwrite))
		
	} else if (filename!= '') {
		if (!overwrite & file.exists(filename)) {
			warning('file exists and "overwrite=FALSE". returning data.frame')
			return(d)
		}
		write.table(d, file=filename, row.names=FALSE, col.names=TRUE)
		return(invisible(d))
		
	} else {
	
        return(d)
		
    }
}
