# Author: Serge Savary & Rene Pangga. 
# R translation: Robert J. Hijmans & Rene Pangga, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  November 2008
# Version 0.1
# Licence GPL v3

leafblast_v1 <- function(wth, duration=120, startday=1) {
# this is  a draft model. Not suited for reserach or applications. 
    tmp <- (wth$tmax + wth$tmin) / 2
	rh <- wth$rh
	AGGR <- 1
	Rc <- 1
	AllSites <- 30000
	initInfection <- 1

	infectious_transit_time <- 20
	infectious <- vector(length=duration)
	infectious[] <- 0
	now_infectious <- vector(length=duration)
	now_infectious[] <- 0
	latency_transit_time <- 5
	latency <- vector(length=duration)
	latency[] <- 0
	now_latent <- vector(length=duration)
	now_latent[] <- 0
	Removed <- vector(length=duration)
	Removed[] <- 0
	Diseased <- vector(length=duration)
	Diseased[] <- 0
	Sites <- vector(length=duration)
	Sites[] <- 0
	Sites[1] <- AllSites

	AgeCoefRc <- cbind(0:24 * 5, c(0, 1, 1, 0.9, 0.8, 0.7, 0.64, 0.59, 0.53, 0.43, 0.32, 0.22, 0.16, 0.09, 0.03, 0.02, 0.02, 0.02, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01, 0.01))
	RHCoefRc <- cbind(0:20 * 5, c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.23, 0.33, 0.43, 0.52, 0.61, 0.69, 0.77, 0.84, 0.91, 1, 1))
	TempCoefRc <- cbind(2:9 * 5, c(0, 0.5, 1, 0.6, 0.2, 0.05, 0.01, 0))


	for (day in 1:duration) {

# initialization of the disease
		if (day==startday) {Rinfection <- initInfection}
 		latency[day] <- Rinfection
		latday <- day - latency_transit_time
		latday <- max(1, latday)
		now_latent[day] <- sum(latency[latday:day])
 
		if (day >= latency_transit_time ) {	Rtransfer <- latency[latday]
		} else { Rtransfer <- 0	}	
		

		infectious[day] <- Rtransfer
		infday <- day - infectious_transit_time
		infday <- max(1, infday)
		now_infectious[day] <- sum(infectious[infday:day])

		if (day > 1) { Sites[day] <- Sites[day-1] - Rinfection	}
	
		Diseased[day] <- sum(infectious) + now_latent[day]
		Removed[day] <- sum(infectious) - now_infectious[day]
		
		COFR <- 1-(Diseased[day]/AllSites)
		RcAgeTemp <- Rc * AFGen(AgeCoefRc, day) * AFGen(TempCoefRc, tmp[day]) * AFGen(RHCoefRc, rh[day])
		Rinfection <- now_infectious[day] * RcAgeTemp * (COFR^AGGR)
	}
	res <- cbind(Sites, now_latent, now_infectious, Removed, Diseased)
	res <- 100 * res / AllSites
	res <- cbind(1:duration, res)
	colnames(res) <- c("day", "sites", "latent", "infectious", "removed", "diseased")
	return(res)
}
