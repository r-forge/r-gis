# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3


hole <- function(x, i, j) {
	ij = cbind(i, j)
	h = rep(FALSE, nrow(ij))
	if (nrow(x@holes) > 0 ){
		for (n in nrow(ij)) {
			subs = subset(x@holes, x@holes[,1] == ij[n,1] & x@holes[,2] == ij[n,2])
			if (nrow(subs) > 0) { 
				h[n] <- TRUE 
			}
		}
	} 
	res <- cbind(data.frame(ij), h)
	colnames(res) <- c('part', 'piece', 'hole')
	return(res)
}


'hole<-' <- function(x, i, j, value) {
	ijv = cbind(i, j, as.logical(value))
	holeout <- subset(ijv, ijv[,3]==FALSE)
	holein <- subset(ijv, ijv[,3]==TRUE)
	h = x@holes
	if (nrow(holeout) > 0) {
		for (i in 1:nrow(holeout)) {
			h <- subset(h, h[,1] != holeout[i,1] & h[,2] != holeout[i,2])
		}
	}
	h <- rbind(h, holein[, 1:2])
	h <- unique(h)
	x@holes <- h
	return(hole)
}

