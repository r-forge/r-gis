Fon_tier1 <- function(v, p, FracFEED, FracFUEL, FracCNST, Fsew, Fcomp, Fooa){

	Fam <- Fam_tier1(v, p, FracFEED, FracFUEL, FracCNST)
	Fon <- Fam + Fsew + Fcomp + Fooa
	return(Fon)
	
}