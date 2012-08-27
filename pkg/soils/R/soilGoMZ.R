# Author: Robert J. Hijmans
# May 2011
# Version 1.0
# Licence GPL v3

soilGoMZ <- function(zipdat, dpfrom=0, dpto=15, props=c("om_r", "claytotal_h"), sp=FALSE, tofile=TRUE, overwrite=FALSE, unzip="internal", verbose=TRUE, ... ) {

	files <- as.character(unzip(zipdat, list=TRUE, unzip=unzip)$Name)
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
	pfiles <- gsub('\\\\', '/', pfiles)

	for (i in 1:length(files)) {
		f <- files[i]
		if (verbose) {
			cat(f, '\n'); flush.console()
		}

		unzip(zipdat, f, exdir=tempdir(), unzip=unzip)
		if (tofile) {
			if (isTRUE(sp)) {
				filename  <- extension(f, '.shp')
			} else {
				filename  <- extension(f, '.txt')			
			}
			filename <- paste(out, '/', filename, sep='')
			if (!overwrite) {
				if (file.exists(filename)) next
			}
			try( x  <- soilGo(pfiles[i], props=props, dpfrom=dpfrom, dpto=dpto, sp=sp, filename=filename, overwrite=TRUE, verbose=FALSE, ...) )
		} else {
			try( lst[[i]]  <- soilGo(pfiles[i], props=props, dpfrom=dpfrom, dpto=dpto, sp=sp, overwrite=TRUE, verbose=FALSE, ...) )		
			i <- i + 1
		}
		file.remove(pfiles[i])
	}
	if (!tofile) {
		return(lst)
	} else {
		return(invisible(NULL))
	}
}

