N2O_tier2 <- function(v, p){

	if (is.vector(v)) {
		v <- t(as.matrix(v))
	}
	
	stopifnot(all(colnames(v) %in% names(p)))
	varnames <- colnames(p)
	pp <- v[varnames]
	apply(p, 1, function(x, ...)sum(x*pp), na.rm=TRUE)
}