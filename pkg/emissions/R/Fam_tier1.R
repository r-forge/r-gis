Fam_tier1 <- function(v, p, FracFEED, FracFUEL, FracCNST){
	  Nmmsavb <- NMMS(v, p)
	  Fam <- Nmmsavb * ( 1 - (FracFEED + FracFUEL + FracCNST) )
	  return(Fam)
}