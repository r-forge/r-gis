# .Fprp_tier1 <- function(x){
	# Fprp <- 0
	# index <- 1
	# for (syst in x$MM_system){
		# Fprp <- Fprp +  ( (x$Nt[index] * x$NEXt_kg[index]) * x$MStprp[index] )
		# index <- index + 1
	# }
	# return(Fprp)
# }



Fprp_tier1 <- function(v, p, na.rm=FALSE){

	if (is.vector(v)) {
		v <- t(as.matrix(v))
	}
	
	stopifnot(all(colnames(v) %in% rownames(p)))
	p <- p[colnames(v), ,drop=FALSE]
	p <- p$NEXt_kg * p$MStprp
	as.vector(apply(v, 1, function(x, ...)sum(x*p), na.rm = na.rm)  )

}