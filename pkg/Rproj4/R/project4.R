
project4 <- function(xy, from, to) {
	xy <- .pjtransform(xy[,1], xy[,2], from, to)
	if (ncol(xy) == 1) {
		stop('invalid crs')
	}
	xy
}


# compileAttributes("C:\\@R\\rgis\\pkg\\Rproj4")

