# Read geographic admin boundaries data into R objects (first download  the data if not locally avaialble)
# Part of Rgis package
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 1,.1 October 2008


.get.indices <- function() {
	path <- dataPathDefault()
	d <- read.table(paste(path, "/index", sep=""), header=T, sep="\t")
	return(as.matrix(d))
}

.read.country.data <- function(var="adm", country="ABW", level=0, download=TRUE ) {
#  under development
	indices <- .get.indices()
	record <- subset(indices, indices[,1] == var)
	if (record["subvar1"] != "ISO") { stop( 'not a country dataset' ) }
}


countryData <- function(country="ABW", varname="adm", level=0, rasterformat="raster", download=TRUE) {
	path <- paste(dataPath(), "/", varname, sep="")
	if (!file.exists(path)) {  dir.create(path, recursive=T)  }
	path <- paste(path, "/", sep="")
	
	if (varname == "adm") {
		filename <- paste(path, varname, '_', country, level, ".RData", sep="")
		theurl <- paste("http://www.r-gis.org/rgis/data/", varname, "/", varname, '_', country, level, ".RData", sep="")
	} else {
		filename <- paste(path, varname, '_', country, ".RData", sep="") 
		theurl <- paste("http://www.r-gis.org/rgis/data/", varname, "/", varname, '_', country, ".RData", sep="")
	}	
	
	if (!file.exists(filename)) {
		isos <- .get.country.list()
		iso <- subset(isos, isos[,2] == country) 
		if (length(iso)==0) { stop('this is not a valid country country code. You can use list.country() to find one') }
	
		if (download) {
			download.file(url=theurl, destfile=filename, method="auto", quiet = FALSE, mode = "wb", cacheOK = TRUE)
			if (!file.exists(filename))
				{ cat("\nCould not download file -- perhaps it does not exist \n") }
		} else {
			cat("\nFile not available locally. Use 'download = TRUE'\n")
		}
	}	

	if (file.exists(filename)) {
		thisenvir = new.env()
		data <- get(load(filename, thisenvir), thisenvir)
		if (class(data) == 'Raster') {
			if (rasterformat != 'raster') {
#				data <- raster.to.sp(raster)
			}
		}
		return(data)
	} 
}


adm <- function(country="ABW", level=0, download=TRUE ) {
	varname <- "adm"
	path <- paste(dataPath(), "/", varname, sep="")
	if (!file.exists(path)) {  dir.create(path, recursive=T)  }
	path <- paste(path, "/", sep="")
		
	filename <- paste(path, varname, '_', country, level, ".RData", sep="")
	if (!file.exists(filename)) {
		if (download) {
			theurl <- paste("http://www.r-gis.org/rgis/data/adm/", varname, '_', country, level, ".RData", sep="")
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



.get.country.list <- function() {
	path <- dataPathDefault()
	d <- read.table(paste(path, "/countries", sep=""), header=T, sep="\t",  quote = "!@!")
	return(as.matrix(d))
}



countryCodes <- function(start=1, end=243) {
	d <- .get.country.list()
	showrange <- c(start:end)
	showrange <- showrange[showrange>0 && showrange<244]
	d[showrange,1:2]
}


admList <- function(country=NA, level=NA) {
	varname <- 'adm'
	path <- paste(dataPath(), "/", varname, sep="")
	
	if (is.na(country)) {
		if (is.na(level)) {
			ISOS <- list.files(path, pattern = "^adm_",full.names=TRUE)
		} else  {
			ISOS <- list.files(path, pattern = paste('^adm_...', level, sep=""), full.names=TRUE)
		}	
	} else {
		if (is.na(level)) {
			ISOS <- list.files(path, pattern = paste('^adm_', country, sep=""), full.names=TRUE)
		} else  {
			ISOS <- list.files(path, pattern = paste('^adm_', country, level, sep=""), full.names=TRUE)
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


admRemove <- function(country=NA, level=NA) {
	varname <- 'adm'
	path <- paste(dataPath(), "/", varname, sep="")

	if (is.na(country)) {cat("\nSpecify a country (country) code.\n") 
	} else if (country == "ALL") {
		if (is.na(level)) {
			ISOS <- list.files(path, pattern = "^adm_",full.names=TRUE)
		} else {
			ISOS <- list.files(path, pattern = paste('adm_...', level, sep="") ,full.names=TRUE)
		}
		for (j in 1:length(ISOS)) {
			file.remove(ISOS[j]) 	
			cat("removed", ISOS[j], "\n")
		}
	} else {
		if (is.na(level)) {
			for (i in 0:5) {
				filename <- paste(path, "adm_", country, i, ".RData", sep="")
				if (nchar(filename) > 0) { 
					res <- file.remove(filename) 
					if (res) {cat("removed", country, i, "\n") }
				}	
			}	
		} else {
			filename <- paste(path, "adm_", country, level, ".RData", sep="")
			if (nchar(filename) > 0) { 
				res <- file.remove(filename) 
				if (res) {cat("removed", country, level, "\n") }
			}
		}
	}	
}


