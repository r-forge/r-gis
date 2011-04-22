NMMS <- function(x){
	
	index <- 1
	NMMS <- 0
	for (syst in x$MM_system){
		NMMS <- NMMS + ( ( (x$Nt[index] * x$NEXt_kg[index] * x$MSts[index]) * (1 - x$FRAClossms_pct[index]/100) )+  ( (x$Nt[index] * x$MSts[index] * x$Nbeddingms_kg[index]) ) )
		index <- index + 1
	}
	
	return(NMMS)

}