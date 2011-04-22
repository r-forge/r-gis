
N2O_tier2 <- function(x){
	
	index <- 1
	 for (EF in x$EF){
		 if ( (EF <  x$EF_L[index]) || (EF > x$EF_H[index])){
			 print.noquote("Warning: emission factor outside uncertainty bounds.")
		 }
		index <- index + 1
	 }
		
	
	index <- 1
	N2O_total_direct <- 0
	for (EF in x$EF_name){
		if (is.na(x$amount_kg[index]) == FALSE){
			N2O_total_direct <- N2O_total_direct + (x$amount_kg[index] * x$EF[index])
			index <- index + 1
		}
		else{
			N2O_total_direct <- N2O_total_direct + (x$area_ha[index] * x$EF[index])
			index <- index + 1
		}
		
	}
		
	return(N2O_total_direct)
}

	