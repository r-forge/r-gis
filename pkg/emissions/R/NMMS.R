

.NMMS1 <- function(x){
	NMMS <- 0
	for (index in 1:nrow(x)){
		NMMS <- NMMS + ( ( (x$Nt[index] * x$NEXt_kg[index] * x$MSts[index]) * (1 - x$FRAClossms_pct[index]/100) )+  ( (x$Nt[index] * x$MSts[index] * x$Nbeddingms_kg[index]) ) )
	}
	return(NMMS)
}


.NMMS2 <- function(v, p, na.rm=FALSE){

	if (is.vector(v)) {
		v <- t(as.matrix(v))
	}
	stopifnot(all(colnames(v) %in% rownames(p)))
	p <- p[colnames(v), ,drop=FALSE]
	p <- (p$NEXt_kg * p$MSts * (1 - p$FRAClossms_pct/100) + ( p$MSts * p$Nbeddingms_kg))
	as.vector(apply(v, 1, function(x, ...)sum(x*p), na.rm=na.rm)  )
 }
 
 


NMMS <- function(p, ...){
	
	Nt = NEXt_kg = FRAClossms_pct = MSts = Nbeddingms_kg = NULL
	params <- c('Nt', 'NEXt_kg', 'FRAClossms_pct', 'MSts', 'Nbeddingms_kg')
	
	#checks that each variable is only entered once
	dots <- list(...)
	vars <- names(dots)
	if (length(vars) != length(unique(vars))) {
		stop('duplicate variables')
	}
	
	#finds variables that are not in the list of possible variables (params) and warns of these unknown variables
	x <- which(! vars %in% params)
	if (length(x) > 0) {
		stop('unknown variable(s) found: ', vars[x])
	}
	
	#if the user doesn't enter any variables and if there are no parameters given, the user is told that no data was supplied
	#otherwise, if not all the parameters in params are found in the colnames of data frame p, user is told that parameters are missing
	if (length(vars)==0) {
		if (missing(p)) {
			stop('no data supplied')
		} else {
			if (any(! params %in% colnames(p))) {
				stop('parameters missing')
			}
		} 
	} 
	
	#if there is no parameters data frame and if not all parameters in params are found in vars entered by user, warn that variables are missing
	#otherwise, find all unique names between p and vars, check whether it's true that each name in this set is found in params, and if not, warn the user which vars/params are missing
	else {
		if (missing(p)) {
			if (any(! params %in% vars)) {
				stop('variables missing: ', params[! params %in% vars])
			}		
		} else {
			allnames <- unique(colnames(p), vars)
			a <- allnames %in% params
			if (! all(a)) {
				stop('variables or parameters missing: ', paste(allnames[a], collapse=', '))
			}		
		}
	}
	
	#if variables are entered by the user
	if (length(vars) > 0) {
		v1 <- vars[1]
		if (is.vector(dots[[v1]])) {
			dots[[v1]] <- t(as.matrix(dots[[v1]]))
		}
		
		cnames <- colnames(dots[[v1]])
		if (! missing(p)) {
			if (! all(cnames %in% rownames(p))) {
				stop('manure systems in parameters do not match those of : ', v1)
			}
			if (dim(dots[[v1]])[2] != dim(p)[1] ) {
				stop('dimension of variable: ',v1 ,' does not match number of rows of p')
			}
		}
		
		assign(v1, t(dots[[v1]]))
		for (v in vars[-1]) {
			if (is.vector(dots[[v]])) {
				dots[[v]] <- t(as.matrix(dots[[v]]))
			}
			dots[[v]] <- dots[[v]][, cnames, drop=FALSE]
			if (! all( dim(dots[[v]]) == dim(dots[[1]])) ) {
				stop('dimensions of ', v, ' do not match those of ', v1)
			}
			assign(v, t(dots[[v]]))
		}
		rm(dots)
	}
	
	pnames <- params[(!params %in% vars)]
	if (! missing(p)) {
		stopifnot(all(cnames %in% rownames(p)))
		p <- p[cnames, pnames, drop=FALSE]
		for (n in pnames) {
			assign(n, as.vector(as.matrix(p[n])))
		}
	}
		
	res <- (Nt * NEXt_kg * MSts) * (1 - FRAClossms_pct/100) +  (Nt * MSts * Nbeddingms_kg)
	if (!is.matrix(res)) {
		res <- matrix(res)
	}
	res <- apply(res, 2, sum)
	names(res) <- NULL
	return(res)
}
 
 #NMMS(p, Nt=v)

 