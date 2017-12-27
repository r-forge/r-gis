# Author: Robert J. Hijmans
# Date : December 2017
# Version 1.0
# Licence GPL v3


setMethod('focal', signature(x='GeoRaster'), 
function(x, w=3, fun='mean', na.rm=TRUE, filename="", ...)  {

	if (is.matrix(w)) {
		stopifnot(ncol(w) == nrow(w))	
		w <- as.vector(t(w))  # row-wise
		domat <- TRUE
	} else {
		w <- rep_len(w, 3)
		fun <- .makeTextFun(match.fun(fun))
		if (class(fun) == 'character') { 
			op <- as.integer(match(fun, c('sum', 'mean', 'min', 'max')) - 1)
		} else {
			op <- NA
		}
		domat <- FALSE		
	}
	
	overwrite <- .overwrite(...)
	
	if (domat) {
			r <- methods::new('GeoRaster')
			ptr <- try(x@ptr$focal(w, fun, na.rm, filename, overwrite));
			if (class(ptr) == 'try-error') { stop("focal error") } else { r@ptr <- ptr }
			return(r)
	
	} else {
		if (!is.na(op)) {	
			r <- methods::new('GeoRaster')
			#	fun='mean', expand=TRUE, na.rm=TRUE, filename=""
			ptr <- try(x@ptr$focal(w, fun, na.rm, filename, overwrite));
			if (class(ptr) == 'try-error') { stop("focal error") } else { r@ptr <- ptr }
			return(r)
		} else {
			out <- georst(x)
			readStart(x)
			b <- writeStart(out, filename)
			for (i in 1:b$n) {
				v <- matrix(x@ptr$focalValues(bs$row[i], bs$nrows[i], w), ncol=prod(w), byrow=TRUE)
				v <- apply(v, 1, fun, na.rm=na.rm)
				writeValues(out, v, b$row[i])
			}
			writeStop(out)
			readStop(x)
			return(out)
		}
	}
}	
)

