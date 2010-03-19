# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : March 2010
# Version 0.0
# Licence GPL v3


dbfnames <- function(x, silent=FALSE) {
	n <- gsub('^[[:space:]]+', '',  gsub('[[:space:]]+$', '', x) )
	nn <- n
	n <- gsub('[^[:alnum:]]', '_', n)
	n[n!=nn] <- gsub('__', '_', n[n!=nn])
	n[n==''] <- 'field'
	n <- gsub('^[^[:alpha:]]', 'X', n)
	n <- substr(n, 1, 11)
	
	# duplicate names
	nn  = as.matrix(table(n))
	i = which(nn > 1)
	if (! is.null(i)) {
		names = rownames(nn)[i]
		n[n %in% names] <- substr(n[n %in% names], 1, 9)
		n <- make.unique(n, sep = "")
	}
	
	if (! all(x == n) & ! silent) {
		warning('names changed to meet the DBF specification')
	}
	return(n)
}

# if driver == 'shp'
# names(x) <- dbfnames(x)

