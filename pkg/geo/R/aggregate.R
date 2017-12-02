# Author: Robert J. Hijmans
# Date : July 2010
# Version 1.0
# Licence GPL v3

# October 2012: Major overhaul (including C interface)
# November 2012: fixed bug with expand=F
# June 2014: support for aggregation over z (layers) in addition to x and y


setMethod('aggregate', signature(x='GeoRaster'), 
function(x, fact=2, fun='mean', expand=TRUE, na.rm=TRUE, filename="", ...)  {

	fact <- round(fact)
	lf <- length(fact)
	if (lf == 1) {
		fact <- c(fact, fact, 1)
	} else if (lf == 2) {
		fact <- c(fact, 1)
	} else if (lf > 3) {
		stop('fact should have length 1, 2, or 3')
	}
	if (any(fact < 1)) {
		stop('fact should be > 0')
	}
	if (! any(fact > 1)) {
		warning('all fact(s) were 1, nothing to aggregate')
		return(x)
	}
	xfact <- fact[1]
	yfact <- fact[2]
	zfact <- fact[3]
	
	ncx <- ncol(x)
	nrx <- nrow(x)
	nlx <- nlayers(x)
	if (xfact > ncx) {
		warning('aggregation factor is larger than the number of columns') 
		 xfact <- ncx 
		 if (!na.rm) xfact <- xfact + 1
	}
	if (yfact > nrx) {
		warning('aggregation factor is larger than the number of rows')
		yfact <- nrx
		if (!na.rm) yfact <- yfact + 1
	}
	if (zfact > nlx) {
		warning('aggregation factor is larger than the number of layers')
		zfact <- nlx
		if (!na.rm) zfact <- zfact + 1
	}

	fun <- .makeTextFun(fun)
	if (class(fun) == 'character') { 
		op <- as.integer(match(fun, c('sum', 'mean', 'min', 'max')) - 1)
	} else {
		op <- NA
	}
	
	if (!is.na(op)) {
	
		dims <- as.integer(yfact, xfact, zfact);
		r <- methods::new('GeoRaster')
		#	fun='mean', expand=TRUE, na.rm=TRUE, filename=""
		r@ptr <- x@ptr$aggregate(dims);
		return(r)
	} else {
	
		
	}
}
)

