
fwInfo <- function(x, options=NULL) {
	fwp <- paste(FWpath(), 'gdalinfo', sep='')
	x <- .getFilename(x)
	outfile <- extension(rasterTmpFile(), '.txt')
	fullcall <- paste(fwp, options, x)
	system(fullcall, intern=TRUE)
}

