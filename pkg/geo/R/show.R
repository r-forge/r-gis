# Author: Robert J. Hijmans
# Date :  June 2017
# Version 0.9
# Licence GPL v3



setMethod ('show' , 'GeoExtent', 
	function(object) {
		cat('class       :' , class(object), '\n')
		cat('xmin        :' , xmin(object), '\n')
		cat('xmax        :' , xmax(object), '\n')
		cat('ymin        :' , ymin(object), '\n')
		cat('ymax        :' , ymax(object), '\n')
	}
)	
	

setMethod ('show' , 'GeoRaster', 
	function(object) {
		
		cat('class       :' , class(object), '\n')

		d <- dim(object)
		cat('dimensions  : ', d[1], ', ', d[2], ', ', d[3], '  (nrow, ncol, nlayer)\n', sep="" ) 
		#cat ('ncell       :' , ncell(object), '\n')

		xyres <- res(object)
		cat('resolution  : ' , xyres[1], ', ', xyres[2], '  (x, y)\n', sep="")

		e <- extent(object)
		cat('extent      : ' , e@xmin, ', ', e@xmax, ', ', e@ymin, ', ', e@ymax, '  (xmin, xmax, ymin, ymax)\n', sep="")

		crs <- crs(object)
		cat('coord. ref. :' , crs(object), '\n')
		
		mnr <- 15
		if (.hasValues(object)) {
			nl <- nlayer(object)
		
			m <- .inMemory(object)
			f <- .filenames(object)
			sources <- rep('memory', length(m))
			sources[!m] <- f[!m] 
			cat('data source :', sources, '\n')
			
			ln <- names(object)
			
			if (nl > mnr) {
				ln <- c(ln[1:mnr], '...')
			}

			if (any(.hasRange(object))) {
				r <- range(object)
				minv <- format(r[[1]])
				maxv <- format(r[[2]])
				minv <- gsub('Inf', '?', minv)
				maxv <- gsub('-Inf', '?', maxv)
				if (nl > mnr) {
					minv <- c(minv[1:mnr], '...')
					maxv <- c(maxv[1:mnr], '...')
				}
				
				
				n <- nchar(ln)
				if (nl > 5) {
					b <- n > 26
					if (any(b)) {
						mid <- floor(n/2)
						ln[b] <- paste(substr(ln[b], 1, 9), '//', substr(ln[b], nchar(ln[b])-9, nchar(ln[b])), sep='')
					}
				}
				
				w <- pmax(nchar(ln), nchar(minv), nchar(maxv))
				m <- rbind(ln, minv, maxv)
				# a loop because 'width' is not recycled by format
				for (i in 1:ncol(m)) {
					m[,i]   <- format(m[,i], width=w[i], justify="right")
				}
				cat('names       :', paste(m[1,], collapse=', '), '\n')
				cat('min values  :', paste(m[2,], collapse=', '), '\n')
				cat('max values  :', paste(m[3,], collapse=', '), '\n')

			} else {
				cat('names       :', paste(ln, collapse=', '), '\n')
			}			
		}
		
		
	}
)


