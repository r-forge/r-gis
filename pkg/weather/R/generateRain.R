# based on function rngen from WOFOST
# Author: C. Rappoldt, October 1986, revised April 1991
# Copyright 1988, 2011 Alterra, Wageningen-UR
# Licensed under the EUPL, Version 1.1  http://www.osor.eu/eupl
#     This routine generates one year of daily rainfall data
#     on the basis of the given long term average monthly rainfall
#     and number of rainy days (wet is >0. or >.1 mm).
#     The method follows the proposal of Shu Geng et al. (1986).
#     The procedure is a combination of a Markov chain and a gamma distribution function.
#     The Markov chain uses the transitional probabilities of a wet day
#     after a dry day. The natural clustering of rainy days can be
#     described by a Markov parameter value of 0.75.
#     In the absence of clustering Markov=1.00. Check the value of Markov!
#     The parameters alfa and beta of the gamma distribution function
#     are derived from the mean rainfall per wet day.
#     The resulting number of rainy days and monthly totals of the generated
#     daily rainfall data are different from the given mean monthly values.


#### R version
# R.J. Hijmans
# Licence GPL v3

generateRain <- function(rain, raind, markov=0.75, reps=1) {

	A <- 2.16
	B <- 1.83
	mlimit <- 0.999*A/(0.999*B - 1)
	rnpwd <- rain / pmax(raind, 1)
    
	BETA <- B*rnpwd - A
    ALFA <- rnpwd / BETA

	nd <- c(31,28,31,30,31,30,31,31,30,31,30,31)
    PWD <- markov * raind / nd
	PWW <- PWD + 1 - markov

	i <- (rnpwd < mlimit) & (rnpwd > 0)
    ALFA[i] <- 0.999
    BETA[i] <- rnpwd[i] / 0.999
	i <- rnpwd == 0
    PWD[i] <- 0  # no rain
    PWW[i] <- 0  
	
	x <- .monthToYearM(cbind(PWD, PWW, ALFA, BETA))

	res <- list()
	for (r in 1:reps) {
		rain <- rep(0, 365)
		rnd <- runif(365)
		raind1 <- rnd < x[,1]  
		raind2 <- rnd < x[,2] 
		if (raind1[365]) {
			if (raind2[1]) {
				raind1[1] <- TRUE
			}	
		}
		for (i in 1:364) {
			if (raind1[i]) {
				if (raind2[i+1]) {
					raind1[i+1] <- TRUE
				}
				rain[i] <- rgamma(1, x[i,3], scale=x[i,4])
			}
		}
		if (raind1[365]) {
			rain[365] <- rgamma(1, x[365,3], scale=x[365,4])	
		}
		res[[r]] <- rain
	}
	res
}	
	

	