# Author: Robert J. Hijmans
# May 2011
# Version 1.0
# Licence GPL v3


.processGo <- function(d, depth, vars, type='mean') {

	d$contr <- (pmin(depth, d$hzdepb_r) - pmin(depth, d$hzdept_r)) / depth
	d <- subset(d, d$contr > 0)
	d[, vars] <- d[, vars] * d$contr

    mysum <- function(x) {
		x <- na.omit(x)
		if (length(x) == 0) { 
			return(NA)
		} else {
			return( sum(x) ) 
		}
	}

	# aggregate horizons by soil type
	dd1 = aggregate(d[, vars], list(d$cokey), mysum)
	if (ncol(dd1)==2) {
		# single variable...
		colnames(dd1)[2] = vars
	}
	colnames(dd1)[1] = 'cokey'

	if (type=='mean') {

	# assure that contributions add up to 100%
		dd2 = aggregate(d$contr, list(d$cokey), mysum)
		colnames(dd2) = c('cokey', 'contr')
		stopifnot(all(dd1[,1] == dd2[,1]))
		dd1[,vars] = dd1[,vars] / dd2[,2]

	#dd3 = merge(dd1, dd2, 'cokey')
		m = unique(d[,c('mukey', 'cokey', 'comppct_r')])
		md = merge(m, dd1, by='cokey')
		md[,vars] = md[,vars] * md$comppct_r

	# aggregate soil type by map unit
		ddd = aggregate(md[,vars], list(md$mukey), mysum)
		if (ncol(ddd)==2) {
			# single variable...
			colnames(ddd)[2] = vars
		}
		colnames(ddd)[1] = 'mukey'

	# assure that contributions add up to 100%
		ddd2 = aggregate(md$comppct_r, list(md$mukey), mysum)
		stopifnot( all(ddd[,1] == ddd2[,1]) )  # should not be necessary to check, it seems
		ddd$pctSoil <- ddd2[,2]
		ddd[,vars] = ddd[,vars] / ddd$pctSoil
		
	} else {
		stop()
	}
	
	ddd
}
