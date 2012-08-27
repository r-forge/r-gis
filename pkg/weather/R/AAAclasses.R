# Author: Robert J. Hijmans
# Date : September 2012
# Version 0.1
# Licence GPL v3


setClass('WeatherStations', 
	contains = 'STFDF',
	representation (
	),
	prototype (	
	),
	validity = function(object) {
		return(TRUE)
	}	
)




setMethod ('show' , 'WeatherStations', 
	function(object) {
		cat('class       :' , class(object), '\n')

		ns <- length(object@sp)
		cat('n stations  :' , ns, '\n')
		#cat('attributes  :' , colnames(object@sp@data), '\n')
		cat('variables   :' , colnames(object@data), '\n')

		start <- object@time[1]
		end <- object@time[length(object@time)]
		if (inherits(start, 'xts')) {
			start <- index(start)
			end <- index(end)
		}
		cat('time        : ' , as.character(start), ', ', as.character(end), ' (start, end)\n', sep='')	
		
		if (ns > 1) {
			e <- bbox(object@sp)
			cat('sp. extent  : ' , e[1,1], ', ', e[1,2], ', ', e[2,1], ', ', e[2,2], '  (xmin, xmax, ymin, ymax)\n', sep="")
		} else {
			e <- coordinates(object@sp)
			cat('location    : ', e[1,1], ', ', e[1,2], '  (x, y)\n', sep="")
		}
		cat('coord. ref. :' , projection(object@sp, TRUE), '\n')
	}
)	
	


setMethod ('plot' , signature(x='WeatherStations', y='ANY'), 
	function(x, y, cex=0.2, type='l', ...) {
		ns <- length(x@sp)
		time <- index(x@time)
		if (ns == 1) {
			plot(time, x@data[,y], ylab=y, cex=cex, type=type, ...)
		} else {
			xx <- x[1,]
			ids <- x@sp@data$id
			plot(xx@time, xx@data[,y])
			for (i in 2:ns) {
				xx <- x[i,]
				points(xx@time, xx@data[,y], cex=cex, type=type, ...)
			}
		}
	}
)


setMethod ('plot' , signature(x='WeatherStations', y='missing'), 
	function(x, ...) {
		y <- colnames(x@data)[1]
		plot(x, y, ...)
	}
)


