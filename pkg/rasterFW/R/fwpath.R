


fwPath <- function(x=NULL, save=TRUE) {
	if (!is.null(x)) {
		x <- trim(x)
		x <- gsub('\\', '/', x)
		if (substr(x, nchar(x), nchar(x)) != '/') {
			x <- paste(x, '/', sep="")
		}
		bin <- tolower(substr(x, nchar(x)-3, nchar(x)-1))
		if (bin != 'bin') {
			stop('this is not the right "bin" folder' )
		}
		x <- normalizePath(x)
		if (x != '') {
			if (!file.exists(substr(x, 1, (nchar(x)-1)))) {
				stop('path does not exist')
			}
		}
		options(rasterfwPath = x)
		if (save) {
			return( invisible(.savePath(x)) )
		}
	} else {
		x <- getOption('rasterfwPath')
		if (is.null(x)) {
			stop('First use "fwPath" to set the path to the FWtools "bin" folder, or set it to "" of this folder is in your "path"')
		}
		x
	}
}


.savePath <- function(x) {

	fn <- paste(R.home(component="etc"), '/', 'Rprofile.site', sep='')
	if (file.exists(fn)) {
		p <- readLines(fn)
		if (length(p) == 0) { 
			p <- "" 
		} else {
			if (p[length(p)] != "") { p <- c(p, "") }
			i <- which(substr(p, 1, 20) == "options(rasterfwPath")
			p <- p[-i]
		}
	} else {
		p <- ""
	}
	
	x <- paste("options(rasterfwPath='", x, "')", sep='')
	p <- c(p, x)
	p <- try( write(p, fn), silent = TRUE )
	if (class(p) == 'try-error') {
		warning('unable to write to:', fn, '\nfwPath set for current session only')
		FALSE
	} else {
		TRUE
	}
}

	