
tier2a <- function(x){
	
	index <- 1
	 for (EF in x$EF){
		 if ( (EF <  x$EF_L[index]) || (EF > x$EF_H[index])){
			 print.noquote("Warning: emission factor outside uncertainty bounds.")
		 }
		index <- index + 1
	 }
		
	
	sum(x$amount_kg * x$EF, na.rm=TRUE) + sum(x$area_ha * x$EF, na.rm=TRUE)
	
}

	

tier2b <- function(v, p){
# v is a vector, matrix, or data.frame
# p is a data.frame or list

	if (is.vector(v)) {
		v <- t(as.matrix(v))
	}
	stopifnot(all(colnames(v) %in% names(p)))
	varnames <- colnames(v)
	pp <- p[varnames]
	apply(v, 1, function(x, ...)sum(x*pp), na.rm=TRUE)
}


	