
.onLoad <- function(lib, pkg)  {

#  library.dynam("Rgis", package = pkg, lib.loc = lib)
	path <- ''
#	path <- paste(system.file(package="geodata"), "/data", sep='' ) 
#	filename <- paste(path, "/datadir", sep='')
	path <- getwd()
	filename <- paste(path, "/R_geodata", sep='')	
	datapath <- ''
	if (file.exists(filename)) {	try(  datapath <- readLines(filename) , silent=TRUE)  }
	if (file.exists(datapath)) { path <- datapath } 
	Sys.setenv(geodata__DATA__DIR=path)
 
	pkg.info <- drop(read.dcf(file=system.file("DESCRIPTION", package="geodata"), fields=c("Version","Date")))
	cat(paste(pkg, " version ", pkg.info["Version"], " (", pkg.info["Date"], "). dataPath=", path, "\n", sep=""))
  			
	return(invisible(0))
}

