# Read geographic data into R objects (first download  the data if not locally avaialble)
# Part of Rgis package
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 1, October 2008


read.srtm <- function(row='37', col='08', download=TRUE) {
	pack <- "Rgis"
	varname <- "srtm"
	filename <- system.file(paste("data/", varname, '_', row, '_', col, ".ZIP", sep=""), package=pack)
	# if file does not exist, filename will be ""
	if (nchar(filename) == 0) {
		if (download) {
			theurl <- paste("http://hypersphere.telascience.org/elevation/cgiar_srtm_v4/tiff/zip/", varname, '_', row, '_', col, ".ZIP", sep="")
			destfilename <- paste(system.file(package=pack), "/data/", varname, '_', row, '_', col, ".ZIP", sep="")
			download.file(url=theurl, destfile=destfilename, method="auto", quiet = FALSE, mode = "wb", cacheOK = TRUE)
			filename <- system.file(paste("data/", varname, '_', row, '_', col, ".ZIP", sep=""), package=pack)
			if (nchar(filename) == 0) { cat("\nCould not download file -- perhaps it does not exist\n\n") }
			} else {
			cat("\nFile not available locally. Use 'download = TRUE'\n")
		}
	}		
	if (nchar(filename) > 0) {
		outfilename <- system.file(paste("data/", varname, '_', row, '_', col, "TIF", sep=""), package=pack)

	#thisenvir = new.env()
		unz(filename)
		#data <- get(load(filename, thisenvir), thisenvir)
		#return(data)
	} 
}


list.adm <- function(ISO3=NA, level=NA) {
	pack <- "Rgis"

	if (is.na(ISO3)) {
		if (is.na(level)) {
			ISOS <- list.files(paste(system.file(package=pack),"/data", sep=""), pattern = "^adm_",full.names=TRUE)
		} else  {
			ISOS <- list.files(paste(system.file(package=pack),"/data", sep=""), pattern = paste('^adm_...', level, sep=""), full.names=TRUE)
		}	
	} else {
		if (is.na(level)) {
			ISOS <- list.files(paste(system.file(package=pack),"/data", sep=""), pattern = paste('^adm_', ISO3, sep=""), full.names=TRUE)
		} else  {
			ISOS <- list.files(paste(system.file(package=pack),"/data", sep=""), pattern = paste('^adm_', ISO3, level, sep=""), full.names=TRUE)
		}	
	}
	if (length(ISOS) > 0) {
		for (i in 1:length(ISOS)) {	
			split <- strsplit(ISOS[i], "/")
			lng <- length(split[[1]])
			filename <- split[[1]][[lng]]
			filename <- gsub("adm_", "", gsub(".RData", "", filename))
			cat(filename, '\n') 
		} 
	} else {
		cat('No files found\n') 
	}	
}


remove.adm <- function(ISO3=NA, level=NA) {
	pack <- "Rgis"
	varname <- "adm_"
	if (is.na(ISO3)) {cat("\nSpecify a country (ISO3) code.\n") 
	} else if (ISO3 == "ALL") {
		if (is.na(level)) {
			ISOS <- list.files(paste(system.file(package=pack),"/data", sep=""), pattern = "^adm_",full.names=TRUE)
		} else {
			ISOS <- list.files(paste(system.file(package=pack),"/data", sep=""), pattern = paste('adm_...', level, sep="") ,full.names=TRUE)
		}
		for (j in 1:length(ISOS)) {
			file.remove(ISOS[j]) 	
			cat("removed", ISOS[j], "\n")
		}
	} else {
		if (is.na(level)) {
			for (i in 0:5) {
				filename <- system.file(paste("data/", varname, ISO3, i, ".RData", sep=""), package=pack)
				if (nchar(filename) > 0) { 
					res <- file.remove(filename) 
					if (res) {cat("removed", ISO3, i, "\n") }
				}	
			}	
		} else {
			filename <- system.file(paste("data/", varname, ISO3, level, ".RData", sep=""), package=pack)
			if (nchar(filename) > 0) { 
				res <- file.remove(filename) 
				if (res) {cat("removed", ISO3, level, "\n") }
			}
		}
	}	
}


