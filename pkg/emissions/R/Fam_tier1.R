Fam_tier1 <- function(nmms, FracFEED, FracFUEL, FracCNST){
	  Fam <- nmms * ( 1 - (FracFEED + FracFUEL + FracCNST) )
	  return(Fam)
}



