
.onLoad <- function(lib, pkg)  {

#  library.dynam("Rgis", package = pkg, lib.loc = lib)
	path <- ''
	path <- paste(system.file(package="geodata"), "/data", sep='' ) 
	filename <- paste(path, "/datadir", sep='')
	datapath <- ''
	if (file.exists(filename)) {	try(  datapath <- readLines(filename) , silent=TRUE)  }
	if (file.exists(datapath)) { path <- datapath } 
	Sys.setenv(R_GIS_DATA_DIR=path)
 
	messages <- as.logical(ifelse(is.null(getOption("geodata.messages")), TRUE, getOption("geodata.messages")))
	messages <- TRUE  
	if(messages){
		pkg.info <- drop(read.dcf(file=system.file("DESCRIPTION", package="Rgis"), fields=c("Version","Date")))
		cat("\n")
		cat("-------------------------------------------------------------\n")
			cat(paste(pkg, " version ", pkg.info["Version"], " (built on ", pkg.info["Date"], ")\n", sep=""))
			cat(paste("Data path =", path, "\n"))
		cat("-------------------------------------------------------------\n")
		cat("\n")
	}
  			
	return(invisible(0))
}

