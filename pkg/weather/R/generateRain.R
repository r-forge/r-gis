# R.J. Hijmans
# Licence GPL v3

# f <- function(proprd=0.5, n=30, markov=0.75) {
	 # Pwd <- markov * proprd
	 # Pww <- markov + Pwd
	 # rnd <- runif(n)
	 # d1 <- rnd < Pwd
	 # d2 <- (rnd < Pww) & c(d1[n], d1[-n])
	 # sum(d1 | d2) / n
# }

# x =list()
# p = seq(0,1,0.05)
# for (i in 1:length(p)) {
	# x[[i]] = mean(replicate(1000, f(p[i], markov=0.62)))
# }
# plot(p, unlist(x))
# abline(0,1)


genRain <- function(rain, rainydays) {
	stopifnot(length(rain)==12)
	stopifnot(all(rain > 0))
	stopifnot(length(rainydays)==12)
	stopifnot(all(rainydays > 0))
	
	nd <- c(31,28,31,30,31,30,31,31,30,31,30,31)
	rainydays <- pmin(rainydays, nd)
	
	rainWD <- rain / pmax(rainydays, 1)
	slope <- 0.62
	Pwd <- slope * rainydays / nd
	Pww <- 1 - slope + Pwd
	
	beta <- pmax(-2.159 + 1.834 * rainWD, 0.01)
	alpha <- pmin(pmax(rainWD / beta, 0.01), 0.998)
	
	x <- .monthToYearM(cbind(Pwd, Pww, alpha, beta))
	r <- matrix(0, nrow=365, ncol=100)
	rnd <- matrix(runif(365*100), nrow=365, ncol=100)
	
	for (year in 1:100) {	
		d1 <- rnd[,year] < x[,1]
		d2 <- rnd[,year] < x[,2] & c(d1[365], d1[-365])
		d <- which(d1 | d2)
		for (i in d) {
			r[i,year] <- rgamma(1, x[i,3], scale=x[i,4])
		}
	}
	
	month <- unlist(sapply(1:12, function(i) rep(i, nd[i])))
	adj <- rowMeans(aggregate(r, list(month), sum)) / rain
	adjust <- unlist(sapply(1:12, function(i) rep(adj[i], nd[i])))
	r / adjust
}	

