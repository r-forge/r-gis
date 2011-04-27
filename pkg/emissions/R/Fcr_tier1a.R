Fcr_tier1a <- function(x){
	
	index <- 1
	Fcr <- 0
	for (crop in x$crop_name){
	
		cropT <- x$crop_kg_per_ha[index] * x$dry_frac[index]
		AGdm <- cropT * x$slope[index] + x$intercept[index]
		Rag <- AGdm * 1000/cropT
		
		if ( is.na(x$Rbg[index]) || is.na(x$Nbg_kg[index]) ){
			Fcr <- Fcr + ( cropT * (x$TOTarea_ha[index] - x$BURNTarea_ha[index]) * x$frac_ren[index] * ( Rag * x$Nag_kg[index] * (1 - x$frac_remv[index]) ) )
			index <- index + 1
		}
		
		else{
			Fcr <- Fcr + ( cropT * (x$TOTarea_ha[index] - x$BURNTarea_ha[index]) * x$frac_ren[index] * ( Rag * x$Nag_kg[index] * (1 - x$frac_remv[index]) + x$Rbg[index] * x$Nbg_kg[index] ) )
			index  <- index + 1
		}
		
	}
	
	return(Fcr)
}
