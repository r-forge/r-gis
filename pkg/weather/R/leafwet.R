# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 0.1  January 2009

eLW <- function(rhmin, rhmax, tmin) {
# emperical leaf wetness estimation according to Hijmans, Forbes and Walker, 2001
    ewhr <- exp(-8.093137318+0.11636662*rhmax-0.03715678*rhmin+0.000358713*rhmin*rhmin)
    if (rhmin < 52) {
      ewhr52 <- exp(-8.093137318+0.11636662*rhmax-0.03715678*52+0.000358713*52*52);
      ewhr <- ewhr52 - (ewhr - ewhr52);
	}
    ewhr <- max(0, min(ewhr, 24))
    if (tmin < 0) {ewhr <- 0}
	return(ewhr)
}


leafWet <- function(w, simple=TRUE) {
	lw <- vector(length=nrow(w@data))
	if (is.null(w$relhmin)) {
		rh <- rhMinMax(w)
		w$relhmin <- rh[, 1]
		w$relhmax <- rh[, 2]
	} else if (is.null(w$relh)) {
		w$relh <- (w$relhmin + w$relhmax) / 2
	}
	
	# for each station ...
	for (d in 1:length(lw)) {
		rh <- diurnalRH(w@sp$lat, index(w@time[d]), w$rhavg[d], w$tmin[d], w$tmax[d], w$tavg[d])
		if (simple) {
			lw[d] <- length(rh[rh>=90])
		} else {
			w <- rh
			x <- (rh - 80) / (95 - 80)
			w[rh > 95] <- 1
			w[rh < 95] <- x[rh < 95]
			w[rh < 80] <- 0
			lw[d] <- sum(w)
		}
	}
	return(lw)
}


leafWetWithRain <- function(w, simple=TRUE) {
	lw <- leafWet(w, simple=simple)
	prec[is.na(w$prec)] <- 0 
	prhrs <- pmin(12, w@w$prec / 5)
	return(lw + (1 - lw/24) * prhrs)
}

