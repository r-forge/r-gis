# Read geographic data into R objects (first download  the data if not locally avaialble)
# Part of Rgis package
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 1, October 2008

read.adm <- function(ISO3="ABW", level=0, download=TRUE ) {
	varname <- "adm"	

# path should become a variable that user can set:	
	path=paste(system.file(package="Rgis"),'/data/', sep='')
	
	filename <- paste(path, varname, '_', ISO3, level, ".RData", sep="")
	if (!file.exists(filename)) {
		if (download) {
			theurl <- paste("http://www.r-gis.org/rgis/data/adm/", varname, '_', ISO3, level, ".RData", sep="")
			download.file(url=theurl, destfile=filename, method="auto", quiet = FALSE, mode = "wb", cacheOK = TRUE)
			if (!file.exists(filename))
				{ cat("\nCould not download file -- perhaps it does not exist\n\n") }
		} else {
			cat("\nFile not available locally. Use 'download = TRUE'\n")
		}
	}	
	if (file.exists(filename)) {
		thisenvir = new.env()
		data <- get(load(filename, thisenvir), thisenvir)
		return(data)
	} 
}

list.ISO3 <- function(start=1, end=243) {
	pack <- "Rgis"
	d <- read.table(paste(system.file(package=pack),"/data/ISO3", sep=""), header=T, sep="\t",  quote = "!@!")
	showrange <- c(start:end)
	showrange <- showrange[showrange>0 && showrange<244]
	d[showrange,]
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
	varname <- "adm"
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
				filename <- system.file(paste("data/", varname, '_', ISO3, i, ".RData", sep=""), package=pack)
				if (nchar(filename) > 0) { 
					res <- file.remove(filename) 
					if (res) {cat("removed", ISO3, i, "\n") }
				}	
			}	
		} else {
			filename <- system.file(paste("data/", varname, '_', ISO3, level, ".RData", sep=""), package=pack)
			if (nchar(filename) > 0) { 
				res <- file.remove(filename) 
				if (res) {cat("removed", ISO3, level, "\n") }
			}
		}
	}	
}


