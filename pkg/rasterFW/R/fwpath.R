


FWpath <- function(x=NULL, save=TRUE) {
	if (!is.null(x)) {
		lastchar <- substr(d, nchar(d), nchar(d))
		if (lastchar != "/" & lastchar != '\\') {
			x <- paste(x, .Platform$file.sep, sep="")
		}
		options(rasterFWpath = x)
		if (save) {
			fn <- paste(R.home(component="etc"), '/', 'Rprofile.site', sep='')
			x <- try( write(x, fn), silent = TRUE )
			if (class(x) == 'try-error') {
				warning('unable to write to:', fn, '\nFWpath set for current session only')
			}
		}
	} else {
		x <- getOption('rasterFWpath')
		if (is.null(x)) {
			stop('First use "FWpath" to set the path to the FWtools "bin" folder')
		}
		x
	}
}

