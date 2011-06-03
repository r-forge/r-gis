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
		x <- unzip(dat, exdir=wdir)
		
		path <- strsplit(as.character(x[1,1]), '/')[[1]][1]
		hasTabular <- length(which(x[,1] == paste(path, '/tabular/', sep='')))
		if (!hasTabular) {
			stop('zip file has no tabular data')
		}
		hasSpatial <- length(which(x[,1] == paste(path, '/spatial/', sep='')))
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
		on.exit( unlink( wdir , recursive=TRUE) )
	} 
	
	d <- .processGo(d, dpfrom, dpto, props)
	
    if (!is.null(raster)) {
	
		return(.mergeSoilRaster(raster, d, props, filename, overwrite=overwrite))
		
    } else if (!is.null(sp)) {
	
		if (isTRUE(sp)) {
			dat <- gsub('\\\\', '/', dat)
			# remove 'tabular'
			shp <- substr(dat, 1, nchar(dat)-7)			
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
		return(invisible(d))
		
	} else {
	
        return(d)
		
    }
}
