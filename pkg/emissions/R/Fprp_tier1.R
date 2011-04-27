Fprp_tier1 <- function(x){
	Fprp <- 0
	index <- 1
	for (syst in x$MM_system){
		Fprp <- Fprp +  ( (x$Nt[index] * x$NEXt_kg[index]) * x$MStprp[index] )
		index <- index + 1
	}
	return(Fprp)
}