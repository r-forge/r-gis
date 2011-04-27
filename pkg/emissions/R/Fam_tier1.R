Fam_tier1 <- function(x, FracFEED, FracFUEL, FracCNST){
	  Nmmsavb <- NMMS(x)
	  Fam <- Nmmsavb * ( 1 - (FracFEED + FracFUEL + FracCNST) )
	  return(Fam)
}