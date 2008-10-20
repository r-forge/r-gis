# Read geographic admin boundaries data into R objects (first download  the data if not locally avaialble)
# Part of Rgis package
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 1,.1 October 2008


.get.indices <- function() {
	path <- get.data.path.default()
	d <- read.table(paste(path, "/index", sep=""), header=T, sep="\t")
	return(as.matrix(d))
}

.read.country.data <- function(var="adm", ISO3="ABW", level=0, download=TRUE ) {
#  under development
	indices <- .get.indices()
	record <- subset(indices, indices[,1] == var)
	if (record["subvar1"] != "ISO") { stop( 'not a country dataset' ) }
	isos <- .get.ISO3()
	iso <- subset(isos, isos[,2] == ISO3) 
	if (length(iso)==0) { stop('this is not a valid ISO3 code. You can use list.ISO3() to find one') }
}

read.adm <- function(ISO3="ABW", level=0, download=TRUE ) {
	varname <- "adm"	
	path <- paste(get.data.path(), "/", varname, sep="")
	if (!file.exists(path)) {  dir.create(path, recursive=T)  }
	path <- paste(path, "/", sep="")
		
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



.get.ISO3 <- function() {
	path <- get.data.path.default()
	d <- read.table(paste(path, "/ISO3", sep=""), header=T, sep="\t",  quote = "!@!")
	return(as.matrix(d))
}



list.ISO3 <- function(start=1, end=243) {
	d <- .get.ISO3()
	showrange <- c(start:end)
	showrange <- showrange[showrange>0 && showrange<244]
	d[showrange,]
}


list.adm <- function(ISO3=NA, level=NA) {
	path <- get.data.path()
	if (is.na(ISO3)) {
		if (is.na(level)) {
			ISOS <- list.files(path, pattern = "^adm_",full.names=TRUE)
		} else  {
			ISOS <- list.files(path, pattern = paste('^adm_...', level, sep=""), full.names=TRUE)
		}	
	} else {
		if (is.na(level)) {
			ISOS <- list.files(path, pattern = paste('^adm_', ISO3, sep=""), full.names=TRUE)
		} else  {
			ISOS <- list.files(path, pattern = paste('^adm_', ISO3, level, sep=""), full.names=TRUE)
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
	path <- get.data.path()
	if (is.na(ISO3)) {cat("\nSpecify a country (ISO3) code.\n") 
	} else if (ISO3 == "ALL") {
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
				filename <- paste(path, "adm_", ISO3, i, ".RData", sep="")
				if (nchar(filename) > 0) { 
					res <- file.remove(filename) 
					if (res) {cat("removed", ISO3, i, "\n") }
				}	
			}	
		} else {
			filename <- paste(path, "adm_", ISO3, level, ".RData", sep="")
			if (nchar(filename) > 0) { 
				res <- file.remove(filename) 
				if (res) {cat("removed", ISO3, level, "\n") }
			}
		}
	}	
}


