# Author: Robert J. Hijmans
# Date : December 2017
# Version 1.0
# Licence GPL v3




setMethod('readStart', signature(x='GeoRaster'), 
	function(x, ...) {
		success <- try(x@ptr$readStart(), silent=TRUE)
		if (!isTRUE(success)) {
			stop("Cannot read from file")
		} else {
			invisible(success)
		}
	}
)


setMethod('readStop', signature(x='GeoRaster'), 
	function(x) {
		success <- try(x@ptr$readStop(), silent=TRUE)
		if (!isTRUE(success)) {
			stop("Cannot close an input file")
		}
		invisible(success)
	}
)


setMethod('writeStart', signature(x='GeoRaster', filename='character'), 
	function(x, filename, overwrite=FALSE, ...) {
		success <- try(x@ptr$writeStart(filename, overwrite), silent=TRUE)
		if (inherits(success, "try-error")) {
			stop("Cannot open file for writing")
		} 
		b <- x@ptr$blockSize 
		bb <- list(row=b$row+1, nrows=b$nrows, n=b$n, filename=b$filename) 
	}
)


setMethod('writeStop', signature(x='GeoRaster'), 
	function(x) {
		success <- try(x@ptr$writeStop(), silent=TRUE)
		if (!isTRUE(success)) {
			stop("Cannot close the output file")
		}
		invisible(success)
	} 
)


setMethod('writeValues', signature(x='GeoRaster', v='vector'), 
	function(x, v, start) {
		success <- try(x@ptr$writeValues(v, start-1), silent=TRUE)
		if (!isTRUE(success)) {
			stop("Cannot write to the output file")
		}
		invisible(success)
	}
)

