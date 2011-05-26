
Fcr_tier1b <- function(p, ...){
	
	crop_kg_per_ha = TOTarea_ha = dry_frac = slope = intercept = Cf = frac_ren = Nag_kg = frac_remv = Rbg = Nbg_kg = frac_burnt = NULL
	
	params <- c('crop_kg_per_ha', 'TOTarea_ha', 'dry_frac', 'slope', 'intercept', 'Cf', 'frac_ren', 'Nag_kg', 'frac_remv', 'Rbg', 'Nbg_kg', 'frac_burnt')
	
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
				stop('cropping systems in parameters do not match those of : ', v1)
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
		
	#res <- (crop_kg_per_ha * dry_frac) * (TOTarea_ha - frac_burnt * TOTarea_ha * Cf) * frac_ren * (  (crop_kg_per_ha * dry_frac * slope + intercept)*1000/(crop_kg_per_ha * dry_frac) * Nag_kg * (1 - frac_remv) + Rbg * ( (crop_kg_per_ha * dry_frac * slope + intercept) * 1000 + (crop_kg_per_ha * dry_frac) ) /(crop_kg_per_ha * dry_frac) * Nbg_kg )
	res <- 1000 * (crop_kg_per_ha * dry_frac * slope + intercept) * (TOTarea_ha - frac_burnt * TOTarea_ha * Cf) * frac_ren * ( Nag_kg * (1-frac_remv) + Rbg * Nbg_kg ) 
	if (!is.matrix(res)) {
		res <- matrix(res)
	}
	res <- apply(res, 2, sum)
	names(res) <- NULL
	return(res)
}