
spPolygons <- function(x) {

#	x <- list(  rbind(c(-180,-20), c(-140,55), c(10, 0), c(-140,-60), c(-180,-20)),
#				rbind(c(-10,0), c(140,60), c(160,0), c(140,-55), c(-10,0)),
#				rbind(c(-125,0), c(0,60), c(40,5), c(15,-45), c(-125,0)))

	p <- SpatPolyPart$new()
	pp <- SpatPoly$new()
	ppp <- SpatPolygons$new()

	for (i in 1:length(x)) {
		p$set(x[[i]][,1], x[[i]][,2])
		pp$addPart(p)
	}
	ppp$addPoly(pp)

	x <- methods::new('SpatPolygons')
	x@ptr <- ppp
	x
}

