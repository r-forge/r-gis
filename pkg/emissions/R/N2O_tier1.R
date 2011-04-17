
N2O_tier1 <- function(T1_data){

	N2O_Ninputs_non_rice <- (T1_data$amount_kg[1] + T1_data$amount_kg[2] + T1_data$amount_kg[3] + T1_data$amount_kg[4]) * T1_data$EF[1]
	
	N2O_Ninputs_rice <- (T1_data$amount_kg[5] + T1_data$amount_kg[6] + T1_data$amount_kg[7] + T1_data$amount_kg[8]) * T1_data$EF[5]
	
	N2O_organic_soils <-  (T1_data$area_ha[9] * T1_data$EF[9]) + (T1_data$area_ha[11] * T1_data$EF[10]) + (T1_data$area_ha[11] * T1_data$EF[11]) + (T1_data$area_ha[12] * T1_data$EF[12]) + (T1_data$area_ha[13] * T1_data$EF[13])
	
	N2O_urine_dung <- (T1_data$amount_kg[14] * T1_data$EF[14]) + (T1_data$amount_kg[15] * T1_data$EF[15])
	
	N2O_total_direct <- N2O_Ninputs_non_rice + N2O_Ninputs_rice + N2O_organic_soils + N2O_urine_dung
	return(N2O_total_direct)
	
}	