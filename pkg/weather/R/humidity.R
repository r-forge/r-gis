# Author: Robert J. Hijmans
# License GPL3


.SVP <- function(tmp) {
   .611 * 10^(7.5 * tmp / (237.7 + tmp))  #kpa
}



saturatedVaporPressure <- function(w) {
	if (is.null(w$tmp)) { 
		if (is.null(w$tmin)) { stop('"w" does not have "tmp" (or "tmin") values') }
		if (is.null(w$tmax)) { stop('"w" does not have "tmp" (or "tmax") values') }
		w$tmp <- (w$tmin + w$tmax) / 2
	}
    w$svp <- .611 * 10^(7.5 * w$tmp / (237.7 + w$tmp))  #kpa
	w
#	6.112 * exp(17.67*temp/(243.5 + temp))
}



vaporPressureDeficit <- function(w) {
    svp <- saturatedVaporPressure(w$tmp)
    w$vpd <- (1-(w$rh/100)) * svp
	w
}


rhMinMax <- function(w) {

	#rh, tmin, tmax, tmp=(tmin+tmax)/2
	if (is.null(w$tmin)) { stop('"w" does not have "tmin" values') }
	if (is.null(w$tmax)) { stop('"w" does not have "tmax" values') }
	if (is.null(w$rh)) { stop('"w" does not have "rh" (relative humidity) values') }

	tmin <- pmax(w$tmin, -5)
	tmax <- pmax(w$tmax, -5)
	if (is.null(w$tmp)) { 
		w$tmp <- (w$tmin + w$tmax) / 2
	}
	tmp <- pmax(w$tmp, -5)
	
	es <- .SVP(tmp)
	vp <- w$rh / 100 * es
	
	es <- .SVP(tmax)
	rhmn <- 100 * vp / es;
	w$rhmn <- pmax(0, pmin(100, rhmn))
	
	es <- .SVP(tmin)
	rhmx <- 100*vp/es;
	w$rhmx <- pmax(0, pmin(100, rhmx))
	w
}	


rhMinMax2 <- function(w) {


	#rh, tmin, tmax, tmp=(tmin+tmax)/2
	if (is.null(w$tmin)) { stop('"w" does not have "tmin" values') }
	if (is.null(w$tmax)) { stop('"w" does not have "tmax" values') }
	if (is.null(w$rhum)) { stop('"w" does not have "rhum" (relative humidity) values') }

	tmin <- pmax(w$tmin, -5)
	tmax <- pmax(w$tmax, -5)
	if (is.null(w$tmp)) { 
		w$tmp <- (w$tmin + w$tmax) / 2
	}
	tmp <- pmax(w$tmp, -5)
	
	es <- .SVP(tmp)
	vp <- w$rhum / 100 * es
	
	es <- .SVP(tmax)
	rhmn <- 100 * vp / es;
	rhmn <- pmax(0, pmin(100, rhmn))
	
	es <- .SVP(tmin)
	rhmx <- 100*vp/es;
	rhmx <- pmax(0, pmin(100, rhmx))
	cbind(rhmn, rhmx)
}	

diurnalRH <- function(w) {
	if (is.null(w$rhmin)) {
		if (is.null(w$rh)) {
			stop('"w" does not have "rh" (relative humidity) values') 
		} else {
			w <- rhMinMax(w)
		}
	}
	if (is.null(w$tmin)) { stop('"w" does not have "tmin" values') }
	if (is.null(w$tmax)) { stop('"w" does not have "tmax" values') }
	tmin <- pmax(w$tmin, -5)
	tmax <- pmax(w$tmax, -5)
	if (is.null(w$tmp)) { 
		tmp <- (tmin + tmax) / 2
	} else {
		tmp <- pmax(w$tmp, -5)
	}
	vp <- .SVP(tmp) * w$rh / 100 
	
	lat <- w@locations$latitude
	hrtemp <- diurnalTemp(lat, date, tmin, tmax) 
	hr <- 1:24
	es <- .SVP(hrtemp[hr])
	rh <- 100*vp/es
	rh <- pmin(100, pmax(0, rh))
	return(rh)
}




.tDew <- function(temp, rh) {
	temp - (100 - rh)/5
}

.FtoC <- function(x) {(5/9)*(x-32) }
.CtoF <- function(x) { x*9/5 + 32 }

.atmp <- function(alt) {
  101.325 * (1 - 2.25577 * 10^-5 * alt) ^ 5.25588   # kPa 
}


.rel2abshum <- function(rh, t) {
	es <- .SVP(t)
	ea <- rh * es / 100
	M <- 18.02 # g/mol
	R <- 8.314472 # Pa?m?/(mol?K)
	T <- t + 273.15  # C to K
	hum <- ea*M/(T*R)
	return(hum)
}


.abs2rhumum <- function(hum, t) {
	M <- 18.02 # g/mol
	R <- 8.314472 # Pa?m?/(mol?K)
	T <- t + 273.15  # C to K
	ea <- hum / (M/(T*R))
	es <- .SVP(t)
	rh <- 100 * ea / es
	rh  <- pmin(rh, 100)
	return(rh)
}



.rel2spechum <- function(rh, t, alt) {
	es <- .SVP(t)
	ea <- es * (rh / 100)
	p <- .atmp(0)
	0.62198*ea / (p - ea)
}

.spec2rhumum <- function(spec, t, alt) {
	es <- .SVP(t)
	100 * (spec * .atmp(alt)) / ((0.62198 + spec) * es)
}

