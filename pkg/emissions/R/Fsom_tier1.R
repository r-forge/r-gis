Fsom_tier1 <- function(Cmin, R){

	if (is.vector(Cmin)) {
		Cmin <- t(as.matrix(Cmin))
	}
	
	stopifnot(all(colnames(Cmin) %in% names(R)))
	varnames <- colnames(R)
	pp <- Cmin[varnames]  
	apply(R, 1, function(x, ...)sum(pp*1/x*1000), na.rm=TRUE)
}



.Fsom_tier1 <- function(p, ...){
	
	params <- c('deltaC', 'R')
	
	dots <- list(...)
	vars <- names(dots)
	if (length(vars) != length(unique(vars))) {
		stop('duplicate variables')
	}
	x <- which(! vars %in% params)
	if (length(x) > 0) {
		stop('unknown variable(s) found: ', vars[x])
	}
	if (length(vars)==0) {
		if (missing(p)) {
			stop('no data supplied')
		} else {
			if (any(! params %in% colnames(p))) {
				stop('parameters missing')
			}
		} 
	} else {
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

	if (length(vars) > 0) {
		v1 <- vars[1]
		if (is.vector(dots[[v1]])) {
			dots[[v1]] <- t(as.matrix(dots[[v1]]))
		}
		cnames <- colnames(dots[[v1]])
		
		if (! missing(p)) {
			if (! all(cnames %in% rownames(p))) {
				stop('land use changes in parameters do not match those of : ', v1)
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
		
	res <- deltaC * 1/R * 1000
	if (!is.matrix(res)) {
		res <- matrix(res)
	}
	res <- apply(res, 2, sum)
	names(res) <- NULL
	return(res)
}