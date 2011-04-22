
N2O_tier1 <- function(x){

	 index <- 1
	 for (EF in x$EF){
		 if ( (EF <  x$EF_L[index]) || (EF > x$EF_H[index])){
			 print.noquote("Warning: emission factor outside the IPCC uncertainty bounds.")
		 }
		index <- index + 1
	 }

	N2O_Ninputs_non_rice <- (x$amount_kg[1] + x$amount_kg[2] + x$amount_kg[3] + x$amount_kg[4]) * x$EF[1]
	
	N2O_Ninputs_rice <- (x$amount_kg[5] + x$amount_kg[6] + x$amount_kg[7] + x$amount_kg[8]) * x$EF[5]
	
	N2O_organic_soils <-  (x$area_ha[9] * x$EF[9]) + (x$area_ha[11] * x$EF[10]) + (x$area_ha[11] * x$EF[11]) + (x$area_ha[12] * x$EF[12]) + (x$area_ha[13] * x$EF[13])
	
	N2O_urine_dung <- (x$amount_kg[14] * x$EF[14]) + (x$amount_kg[15] * x$EF[15])
	
	N2O_total_direct <- N2O_Ninputs_non_rice + N2O_Ninputs_rice + N2O_organic_soils + N2O_urine_dung
	return(N2O_total_direct)
	
}	