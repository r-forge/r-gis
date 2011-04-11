


N2O_tier2 <- function(Fsn, Fon, Fcr, Fsom, FosCG, FosFNR, FosFNP, Fprp, EF, rice=FALSE) {

	efneeded <- c('EF1', 'EF1FR', 'EF2CGtemp', 'EF2CGtrop', 'EF2FtempR', 'EF2FtempP', 'EF2Ftrop', 'EF3PRPCRP', 'EF3PRPSO')
	for (e in efneeded) {
		if (! e %in% colnames(EF)) {
			stop('variable missing in EF:', e)
		}
	}

	N_inputs <- (Fsn + Fon + Fcr + Fsom) * EF$EF1
	return(N_inputs * 2)
}

