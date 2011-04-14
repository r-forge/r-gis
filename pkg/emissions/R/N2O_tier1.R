
N2O_tier1 <- function(Fsn, Fon, Fcr, Fsom, FosCG, FosFNR, FosFNP, Fprp, EF, rice=FALSE) {

	#case where the user does not supply emission factors, so defaults from table_11.1 are used
	#??For the code fragment below (lines 7-10) I was originally getting a syntax error, but when I changed it to what it is now, it ran
	#However,  it doesn't recognize the EF.RData file when I call the function without EF (maybe something I don't yet understand abt. environments)??
	
	 if(missing(EF)){
		 thisenvir = new.env()
		 EF <- get(data("EF"), thisenvir, thisenvir)
	 }
	
	
	#case where the user supplies their own table (data frame) of emission factors
	#??The way we implement the function, we include the different "regional" emission factors that accound for both land use and climate
	#??However, it seems like we don't account for the different climates with the Fos (area) parameters.
	#??We just have annual areas of cropland/grassland, nutrient-poor forest (NP), and nutrient-rich forest (NR) (but then these land types don't get divided by climate)
	#??It seems like this messes up the second equation (N2O from organic soils), because we're just multiplying the different EFs by constant areas in each land use class, right?
	#??So we need more parameters, right? We need areas of CG (FosCG) in temperate AND tropics.  We also need to divide up the forest by temp/trop
	#??From the equation, it seems like NP and NR only apply to temperate; all tropical forest is considered the same, so we need just one more area parameter for tropical forest, right?
	#??Does this make sense?  I guess this would mean 3 additional input parameters.
	
	efneeded <- c('EF1', 'EF1FR', 'EF2CGtemp', 'EF2CGtrop', 'EF2FtempR', 'EF2FtempP', 'EF2Ftrop', 'EF3PRPCPP', 'EF3PRPSO')
	for (e in efneeded) {
		if (! e %in% colnames(EF)) {
			stop('variable missing in EF:', e)
		}
	}
	
	N2O_Ninputs <- (Fsn + Fon + Fcr + Fsom) * EF$EF1
	#return(N2O_Ninputs)
	
	N2O_organic_soils <- (FosCG * EF$EF2CGtemp) + (FosCG * EF$EF2CGtrop) + (FosFNR * EF$EF2FtempR) + (FosFNP * EF$EF2FtempP) + (FosFNP * EF$EF2Ftrop)
	#return(N2O_organic_soils)

	N2O_urine_dung <- (Fprp * EF$EF3PRPCPP) + (Fprp * EF$EF3PRPSO)
	#return(N2O_urine_dung)
	
	N2O_total_direct <- N2O_Ninputs + N2O_organic_soils + N2O_urine_dung
	return(N2O_total_direct)
	
}

