# Author: Robert J. Hijmans
# Date :  August 2009
# Version 0.9
# License GPL v3

parfun <- function(cls, data, fun, model, ...) {
	nr <- nrow(data)
	nc <- length(cls)
	s <- split(data, rep(1:nc, each=ceiling(nr/nc), length.out=nr))
	unlist(parallel::clusterApply(cls, s, function(i, ...) fun(model, i, ...), ...))
}


.runModel <- function(model, fun, d, nl, const, na.rm, index, cores=1, cls=NULL, ...) {
	if (!is.data.frame(d)) {
		d <- data.frame(d)
	}
	if (! is.null(const)) {
		for (i in 1:ncol(const)) {
			d <- cbind(d, const[,i,drop=FALSE])
		}
	}	 
	if (na.rm) {
		n <- nrow(d)
		i <- rowSums(is.na(d)) == 0
		d <- d[i,,drop=FALSE]
		if (nrow(d) > 0) {
			if (cores > 1) {
				r <- parfun(cls, d, fun, model, ...)
			} else {
				r <- fun(model, d, ...)
			}
			if (is.factor(r)) {
				r <- as.integer(r)
			} else if (is.data.frame(r)) {
				r <- sapply(r, as.numeric)
			}
			r <- as.matrix(r)
			if (!all(i)) {
				m <- matrix(NA, nrow=nl*n, ncol=ncol(r))
				m[i,] <- r
				colnames(m) <- colnames(r)
				r <- m
			}
		} else {
			r <- matrix(NA, nrow=nl*n, ncol=1)
		}
	} else {
		if (cores > 1) {
			r <- parfun(cls, d, fun, model, ...)
		} else {
			r <- fun(model, d, ...)
		}
		if (is.factor(r)) {
			r <- as.integer(r)
		} else if (is.data.frame(r)) {
			r <- sapply(r, as.numeric)
		}
		r <- as.matrix(r)
	}
	if (!is.null(index)) {
		r <- r[, index,drop=FALSE]
	}
	r
}



.getFactors <- function(m, facts=NULL, lyrnms) {

	if (!is.null(facts)) {
		stopifnot(is.list(factors))
		f <- names(factors)
		if (any(trimws(f) == "")) {
			error("predict", "all factors must be named")
		}
	} else if (inherits(m, "randomForest")) {
		f <- names(which(sapply(m$forest$xlevels, max) != "0"))
		if (length(f) > 0) { 
			factors <- m$forest$xlevels[f]
		}
	} else if (inherits(m, "gbm")) {
		dafr <- m$gbm.call$dataframe 
		i <- sapply(dafr, is.factor)
		if (any(i)) {
			j <- which(i)
			factors <- list()
			for (i in 1:length(j)) {
				factors[[i]] <- levels(dafr[[ j[i] ]])
			}
			names(factors) <- colnames(dafr)[j]
		}
	} else { #glm and others
		try(factors <- m$xlevels, silent=TRUE)
	}
	if (!all(names(factors) %in% lyrnms)) {
		ff <- f[!(f %in% lyrnms)]
		error("predict", paste("factor name(s):", paste(ff, collapse=", "), " not in layer names"))
	}
	factors
}

setMethod("predict", signature(object="SpatRaster"), 
	function(object, model, fun=predict, ..., factors=NULL, const=NULL, na.rm=FALSE, index=NULL, cores=1, filename="", overwrite=FALSE, wopt=list()) {

		nms <- names(object)
		if (length(unique(nms)) != length(nms)) {
			tab <- table(nms)
			error("predict", "duplicate names in SpatRaster: ", tab[tab>1])
		}

		#factors should come with the SpatRaster
		#haveFactor <- FALSE
		#if (!is.null(factors)) {
		#	factors <- .getFactors(model, factors, nms)
		#	fnames <- names(f)
		#	haveFactor <- TRUE
		#}

		nl <- 1
		nc <- ncol(object)
		tomat <- FALSE
		readStart(object)
		on.exit(readStop(object))
		d <- readValues(object, round(0.5*nrow(object)), 1, 1, min(nc,500), TRUE, TRUE)

		r <- .runModel(model, fun, d, nl, const, na.rm, index, ...)
		nl <- ncol(r)
		out <- rast(object, nlyr=nl)
		cn <- colnames(r)
		if (length(cn) == nl) names(out) <- make.names(cn, TRUE)

		if (cores > 1) {
			cls <- parallel::makeCluster(cores)
			on.exit(parallel::stopCluster(cls), add=TRUE)
			parallel::clusterExport(cls, c("model", "fun"), environment())
			dots <- list(...)
			if (length(dots) > 0) {
				nms <- names(dots)
				dotsenv <- new.env()
				lapply(1:length(dots), function(i) assign(nms[i], dots[[i]], envir=dotsenv))
				parallel::clusterExport(cls, nms, dotsenv)
			}
		} else {
			cls <- NULL
		}
		b <- writeStart(out, filename, overwrite, wopt)
		for (i in 1:b$n) {
			d <- readValues(object, b$row[i], b$nrows[i], 1, nc, TRUE, TRUE)
			r <- .runModel(model, fun, d, nl, const, na.rm, index, cores=cores, cls=cls, ...)
			writeValues(out, r, b$row[i], b$nrows[i])
		}
		writeStop(out)
		return(out)
	}
)

