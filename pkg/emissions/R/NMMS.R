NMMS <- function(x){
	
	index <- 1
	NMMS <- 0
	for (syst in x$MM_system){
		NMMS <- NMMS + ( ( (x$Nt[index] * x$NEXt_kg[index] * x$MSts[index]) * (1 - x$FRAClossms_pct[index]/100) )+  ( (x$Nt[index] * x$MSts[index] * x$Nbeddingms_kg[index]) ) )
		index <- index + 1
	}
	
	return(NMMS)

}


# NMMS <- function(v, p){
	
	# if (is.vector(v)) {
		# v <- t(as.matrix(v))
	# }
	
	# stopifnot(all(rownames(p) %in% rownames(v)))  
	# varnames <- rownames(v)  
	# pp <- p[varnames]										##problem with this line (says: "Error in `[.data.frame`(p, varnames) : undefined columns selected")
	# apply(v, 1, function(x, ...)sum(x*pp), na.rm=TRUE)    ##need to apply formula in line 6 in this line
# }
 
 
 
 