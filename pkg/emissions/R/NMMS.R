

.NMMSold <- function(x){
	NMMS <- 0
	for (index in 1:nrow(x)){
		NMMS <- NMMS + ( ( (x$Nt[index] * x$NEXt_kg[index] * x$MSts[index]) * (1 - x$FRAClossms_pct[index]/100) )+  ( (x$Nt[index] * x$MSts[index] * x$Nbeddingms_kg[index]) ) )
	}
	return(NMMS)
}


NMMS <- function(v, p, na.rm=FALSE){

	if (is.vector(v)) {
		v <- t(as.matrix(v))
	}
	stopifnot(all(colnames(v) %in% rownames(p)))
	p <- p[colnames(v), ,drop=FALSE]
	p <- (p$NEXt_kg * p$MSts * (1 - p$FRAClossms_pct/100) + ( p$MSts * p$Nbeddingms_kg))
	as.vector(apply(v, 1, function(x, ...)sum(x*p), na.rm=na.rm)  )
 }
 
 
 