
.remove.trailing.slash <- function(path) {
#  adapted from code by Henrik Bengtsson
# Remove trailing "/", 
   path <- gsub("/$", "", path)
#2nd time to deal with e.g. c://temp//
   path <- gsub("/$", "", path)
#keep "C:/", "D:/"...; 
   path <- gsub(":$", ":/", path)
   return(path)
}

get.data.path.default <- function() {
	path <- paste(system.file(package="Rgis"), "/data", sep='')
}

set.data.path.default <- function() {
	set.data.path(get.data.path.default(), TRUE)
}

set.data.path <- function(path, create=FALSE) {
	path <- .remove.trailing.slash(path)
	if (!(file.exists(path))) { 
		if (create) {
			dir.create(path, recursive=T)
		} else { stop("path does not exist, use create=T to create it") }
	}
	if (file.exists(path)) { 
		Sys.setenv(R_GIS_DATA_DIR=path)
	}
	try(   write(path, paste(system.file(package="Rgis"), "/data/datadir", sep=''))  )
}	

get.data.path <- function() {
	path <- paste(Sys.getenv("R_GIS_DATA_DIR"))
	if (path == "") {
		path <- try(  readLines(paste(system.file(package="Rgis"), "/data/datadir", sep='')) )  
	}
	if (path == "") {
		set.data.path.default()
	}
	path <- .remove.trailing.slash(path) 
	if (!(file.exists(path))) {
		set.data.path.default()
		path <- get.data.path.default() 
	}
	return(path)
}


