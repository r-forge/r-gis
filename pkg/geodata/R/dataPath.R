
.removeTrailingSlash <- function(path) {
#  adapted from code by Henrik Bengtsson
# Remove trailing "/", 
   path <- gsub("/$", "", path)
#2nd time to deal with e.g. c://temp//
   path <- gsub("/$", "", path)
#keep "C:/", "D:/"...; 
   path <- gsub(":$", ":/", path)
   return(path)
}

dataPathDefault <- function() {
#	path <- paste(system.file(package="geodata"), "/data", sep='')
	path <- getwd()
}

setDataPathDefault <- function() {
	setDataPath(dataPathDefault(), TRUE)
}

setDataPath <- function(path, create=FALSE) {
	path <- .removeTrailingSlash(path)
	if (!(file.exists(path))) { 
		if (create) {
			dir.create(path, recursive=T)
		} else { stop("path does not exist, use create=T to create it") }
	}
	if (file.exists(path)) { 
		Sys.setenv(geodata__DATA__DIR=path)
	}
#	try(   write(path, paste(system.file(package="geodata"), "/data/datadir", sep=''))  )
	try( 
		write(path, paste(getwd(), "/R_geodata.txt", sep=""))  
	)
}	

dataPath <- function() {
	path <- Sys.getenv("geodata__DATA__DIR")
	if (path == "") {
#		path <- try(  readLines(paste(system.file(package="geodata"), "/data/datadir", sep='')) )  
		path <- try(  readLines(paste(getwd(), "/R_geodata.txt", sep=""))  )  
	}
	if (path == "") {
		dataPathDefault()
	}
	path <- .removeTrailingSlash(path) 
	if (!(file.exists(path))) {
		setDataPathDefault()
		path <- dataPathDefault() 
	}
	return(path)
}


