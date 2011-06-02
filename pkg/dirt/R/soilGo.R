# Author: Robert J. Hijmans
# May 2011
# Version 1.0
# Licence GPL v3



soilGoMZ <- function(zipdat, depth=10, props=c("om_r", "claytotal_h"), tofile=TRUE, sp = NULL, verbose=TRUE, ... ) {
	files <- as.character(unzip(zipdat, list = TRUE)$Name)
	files <- files[tolower(extension(files)) == '.zip']
	stopifnot(length(files) > 0)
	
	if (tofile) {
		out <- extension(zipdat, '')
		dir.create(out, showWarnings=FALSE)
	} else {
		lst <- list()
		i <- 1
	}
	pfiles <- paste(tempdir(), "/", files, sep = "")

	for (i in 1:length(files)) {
		f <- files[i]
		if (verbose) {
			cat(f, '\n'); flush.console()
		}

		unzip(zipdat, f, exdir=tempdir())
		if (tofile) {
			if (isTRUE(sp)) {
				filename  <- extension(f, '.shp')
			} else {
				filename  <- extension(f, '.txt')			
			}
			filename <- paste(out, '/', filename, sep='')
			try( x  <- soilGo(pfiles[i], props=props, depth=depth, sp=sp, filename=filename, overwrite=TRUE, verbose=FALSE, ...) )
		} else {
			try( lst[[i]]  <- soilGo(pfiles[i], props=props, depth=depth, sp=sp, overwrite=TRUE, verbose=FALSE, ...) )		
			i <- i + 1
		}
		file.remove(pfiles[i])
	}
	if (!tofile) {
		return(lst)
	} else {
		return(NULL)
	}
}




soilGo <- function(dat, depth=10, props=c("om_r", "claytotal_h"), filename='', overwrite=FALSE, sp = NULL, raster=NULL, verbose=TRUE, ... ) {

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
		dat <- extension(basename(dat), '')
		dat <- paste(wdir, '/', dat, '/tabular', sep="")
		if (!file.exists(dat)) {
			stop('contents of zip file do not seem to be SSURGO or STATSGO data')
		}
		d <- .getSoilGoTxt(dat, props, ...)
		on.exit( unlink( wdir , recursive=TRUE) )
	} 
	
	d <- .processGo(d, depth, props)
	
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
