
.as.raster.continuous <- function(out, x, type) {

	Z <- as.matrix(x, TRUE)
	Z[is.nan(Z) | is.infinite(Z)] <- NA

	z <- stats::na.omit(as.vector(Z))
	n <- length(z)
	if (n == 0) error("plot", "no values")
	if (type == "depends") {
		if (length(unique(z)) < 6) {
			return (.as.raster.classes(out, x))
		}
	} else if (length(unique(z)) == 1) {
		return (.as.raster.classes(out, x))
	}

	if (is.null(out$range)) {
		out$range <- range(z)
	} else {
		stopifnot(length(out$range) == 2)
		stopifnot(out$range[2] > out$range[1])
	}

	breaks <- .get_breaks(Z, length(out$cols), "eqint", out$range)
	Z[] <- out$cols[as.integer(cut(Z, breaks, include.lowest=TRUE, right=FALSE))]
	out$r <- as.raster(Z)

	out$legend_type <- "continuous"

	if (is.null(out$levels)) {
		out$levels <- 5
	} 
	if (is.null(out$leg$digits)) {
		dif <- diff(out$range)
		if (dif == 0) {
			out$leg_digits = 0;
		} else {
			out$leg$digits <- max(0, -floor(log10(dif/10)))
		}
	}

	if (is.null(out$leg$loc)) out$leg$loc <- "right"
	out
}


.as.raster.classes <- function(out, x, ...) {

	Z <- as.matrix(x, TRUE)
	Z[is.nan(Z) | is.infinite(Z)] <- NA
	if (all(is.na(Z))) {
		error("plot", "no values")
	}

	fz <- as.factor(Z)
	levs <- levels(fz)
	if (!is.null(out$levels)) {
		if (is.null(out$leg$legend)) {
			out$leg$legend <- as.character(out$levels)
		}
		levs <- out$levels
	} else if (!is.null(out$facts)) {
		uz <- as.integer(levels(fz))
		labs <- out$facts[[1]]$labels[uz+1]
		labs[is.na(labs)] <- "?"
		out$leg$legend <- labs
		out$levels <- uz
	} else {
		out$levels <- as.numeric(levs)
		if (is.null(out$leg$legend)) {
			out$leg$legend <- levs
		}
	}
	stopifnot(length(out$leg$legend) == length(out$levels))
	nlevs <- length(levs)

	cols <- out$cols
	ncols <- length(cols)
	if (nlevs < ncols) {
		i <- trunc((ncols / nlevs) * 1:nlevs)
		cols <- cols[i]
	} else {
		cols <- rep_len(cols, nlevs)
	}
	out$leg$fill <- cols
	Z[] <- cols[as.numeric(fz)]
	out$r <- as.raster(Z)
	out$legend_type <- "classes"

	if (is.null(out$leg$x)) {
		if (is.null(out$leg$ext)) {
			out$leg$x = "top"
			out$leg$y = NULL
		} else {
			if (length(out$leg$ext) == 4) {
				out$leg$x = out$leg$ext[1]
				out$leg$y = out$leg$ext[4]
			} else {
				out$leg$x = "top"
				out$leg$y = NULL
			}
		}
	}
	out
}

# to be merged with the vector variant.
.generic.interval <- function(out, Z) {
	if (is.null(out$breaks)) {
		out$breaks <- 5
	} 
	if (length(out$breaks) == 1) {
		out$breaks <- .get_breaks(Z, out$breaks, out$breakby, out$range)
	}
	fz <- cut(Z, out$breaks, include.lowest=TRUE, right=FALSE)
	out$vcut = as.integer(fz)
	levs <- levels(fz)
	nlevs <- length(levs)

	cols <- out$cols
	ncols <- length(cols)
	if (nlevs < ncols) {
		i <- trunc((ncols / nlevs) * 1:nlevs)
		cols <- cols[i]
	} else {
		cols <- rep_len(cols, nlevs)
	}
	#out$cols <- cols
	out$leg$fill <- cols
	#out$leg$levels <- levels(fz)
	out$legend_type <- "classes"

	if (!is.null(out$leg$legend)) {
		stopifnot(length(out$leg$legend) == nlevs)
	} else {
		levs <- gsub("]", "", gsub(")", "", gsub("\\[", "", levs)))
		levs <- paste(levs, collapse=",")
		m <- matrix(as.numeric(unlist(strsplit(levs, ","))), ncol=2, byrow=TRUE)
		m <- apply(m, 1, function(i) paste(i, collapse=" - "))
		out$leg$legend <- m
	}

	if (is.null(out$leg$x)) { # && is.null(out$leg$ext)) {
		out$leg$x <- "top"
	}
	out
}

.as.raster.interval <- function(out, x, ...) {
	Z <- as.matrix(x, TRUE)
	Z[is.nan(Z) | is.infinite(Z)] <- NA
	out <- .generic.interval(out, Z)
	Z[] <- out$leg$fill[out$vcut]
	out$r <- as.raster(Z)
	out
}

# leg.shrink=c(0,0), leg.main=NULL, leg.main.cex = 1, leg.digits=NULL, leg.loc=NULL, leg.ext=NULL, leg.levels=NULL, leg.labels=NULL, leg.at=NULL, 


.as.raster.colortable <- function(out, x, ...) {
	z <- round(values(x))
	z[z<0 | z>255] <- NA
	z[is.nan(z) | is.infinite(z)] <- NA
	if (all(is.na(z))) {
		error("plot", "no values")
	}
	out$cols <- grDevices::rgb(out$coltab[,1], out$coltab[,2], out$coltab[,3], out$coltab[,4], maxColorValue=255)
	z <- out$cols[z+1]
	z <- matrix(z, nrow=nrow(x), ncol=ncol(x), byrow=TRUE)
	out$r <- as.raster(z)
	out$legend_draw	 <- FALSE
	out
}


# legend 
#	border="black", box.lwd = graphics::par("lwd"), box.lty = graphics::par("lty"), 
#	box.col = graphics::par("fg"), bty = "o", bg = graphics::par("bg"), xjust = 0, 
#	yjust = 1, x.intersp = 1, y.intersp = 1, adj = c(0, 0.5), text.width = NULL, 
#	text.col = graphics::par("col"), text.font = NULL, ncol = 1, horiz = FALSE, title = NULL,
 #   inset = 0, title.col = text.col, title.adj = 0.5, 

.plotit <- function(x, xlab="", ylab="", type = "n", yaxs="i", xaxs="i", asp=x$asp, axes=TRUE, new=NA, ...) {

	if ((!x$add) & (!x$legend_only)) {

		if (!any(is.na(x$mar))) { graphics::par(mar=x$mar) }
		plot(x$lim[1:2], x$lim[3:4], type=type, xlab=xlab, ylab=ylab, asp=asp, xaxs=xaxs, yaxs=yaxs, axes=FALSE, ...)
	}

	if (!x$legend_only) {
		graphics::rasterImage(x$r, x$ext[1], x$ext[3], x$ext[2], x$ext[4], 
			angle = 0, interpolate = x$interpolate)

		if (axes) x <- .plot.axes(x)
	}
	if (x$legend_draw) {
		if (x$legend_type == "continuous") {
			x <- do.call(.plot.cont.legend, list(x=x))
#		} else if (x$legend_type == "classes") {
		} else {
			#y <- do.call(.plot.class.legend, x$leg)
			x <- do.call(.plot.class.legend, x$leg)
		}
	}
	x
}



.prep.plot.data <- function(x, type, maxcell, cols, mar=NULL, draw=FALSE, 
  interpolate=FALSE, legend=TRUE, legend.only=FALSE, pax=list(), plg=list(), 
  levels=NULL, add=FALSE, range=NULL, new=NA, breaks=NULL, breakby="eqint",
  coltab=NULL, facts=NULL, xlim=NULL, ylim=NULL, colNA=NA, alpha=NULL, ...) {

#mar=c(5.1, 4.1, 4.1, 7.1); legend=TRUE; axes=TRUE; pal=list(); pax=list(); maxcell=50000; draw=FALSE; interpolate=FALSE; legend=TRUE; legend.only=FALSE; pax=list(); pal=list(); levels=NULL; add=FALSE; range=NULL; new=NA; breaks=NULL; coltab=NULL; facts=NULL; xlim=NULL; ylim=NULL;
 
	out <- list()

	if (!(is.null(xlim) & is.null(ylim))) {
		e <- as.vector(ext(x))
		if (!is.null(xlim)) e[1:2] <- sort(xlim)
		if (!is.null(ylim)) e[3:4] <- sort(ylim)
		x <- crop(x, ext(e))
		out$ext <- as.vector(ext(x))
		out$lim <- e
	} else {
		out$lim <- out$ext <- as.vector(ext(x))
	}

	x <- spatSample(x, maxcell, method="regular", as.raster=TRUE)

	out$add <- isTRUE(add)
	out$axs <- pax 
	out$leg <- plg
	out$asp <- 1
	out$lonlat <- is.lonlat(x, perhaps=TRUE, warn=FALSE)
	if (out$lonlat) {
		out$asp <- 1/cos((mean(out$ext[3:4]) * pi)/180)
	}

	if (!is.null(alpha)) {
		alpha <- clamp(alpha[1]*255, 0, 255)
		cols <- grDevices::rgb(t(grDevices::col2rgb(cols)), alpha=alpha, maxColorValue=255)
	} else {
		alpha <- 255
	}

	out$cols <- cols
	out$facts <- facts
	out$breaks <- breaks
	out$breakby <- breakby
	out$interpolate <- FALSE
	out$legend_draw <- isTRUE(legend)
	out$legend_only <- isTRUE(legend.only)

	if (is.null(mar)) {
		if (out$legend_draw) {
			mar=c(3.1, 3.1, 2.1, 7.1)
		} else {
			mar=c(3.1, 3.1, 2.1, 2.1)
		}
	}
	out$mar <- mar

	if (type=="colortable") {
		out$coltab <- coltab
		out <- .as.raster.colortable(out, x)
	} else if (type=="classes") {
		out$levels <- levels
		out <- .as.raster.classes(out, x)
	} else if (type=="interval") {
		out <- .as.raster.interval(out, x)
	} else {
		out$interpolate <- isTRUE(interpolate)
		out$range <- range
		out <- .as.raster.continuous(out, x, type)
	}

	if (!is.null(colNA)) {
		if (!is.na(colNA)) {
			out$colNA <- grDevices::rgb(t(grDevices::col2rgb(colNA)), alpha=alpha, maxColorValue=255)
			out$r[is.na(out$r)] <- out$colNA
		}
	}

	if (draw) {
		out <- .plotit(out, new=new, ...)
	}
	invisible(out)
}


setMethod("plot", signature(x="SpatRaster", y="numeric"), 
	function(x, y=1, col, type, mar=NULL, legend=TRUE, axes=TRUE, plg=list(), pax=list(), maxcell=50000, smooth=FALSE, range=NULL, levels=NULL, fun=NULL, colNA=NULL, alpha=NULL, ...) {

		x <- x[[y]]
		if (!hasValues(x)) { error("plot", "SpatRaster has no cell values") }


		breaks <- list(...)$breaks
		coltab <- NULL
		facts  <- NULL
		if (!is.null(breaks)) {
			type <- "interval"
		} else {
			if (missing(type)) {
				if (x@ptr$hasColors()) {
					coltab <- coltab(x)[[1]]
					type <- "colortable"
				} else if (is.factor(x)) {
					type <- "classes"
					facts <- levels(x)
				} else {
					type <- "depends"
				}
			} else {
				type <- match.arg(type, c("continuous", "classes", "interval"))
			}
		}

		if (missing(col)) col <- rev(grDevices::terrain.colors(50))
		x <- .prep.plot.data(x, type=type, maxcell=maxcell, cols=col, mar=mar, draw=TRUE, plg=plg, pax=pax, legend=isTRUE(legend), axes=isTRUE(axes), coltab=coltab, facts=facts, interpolate=smooth, levels=levels, range=range, colNA=colNA, ...)

		if (!is.null(fun)) {
			if (!is.null(formals(fun))) {
				fun(1)
			} else {
				fun()
			}
		}
		invisible(x)
	}
)

setMethod("plot", signature(x="SpatRaster", y="missing"), 
	function(x, y, maxcell=50000, main, mar=NULL, nc, nr, maxnl=16, ...)  {

		nl <- max(1, min(nlyr(x), maxnl))

		if (nl==1) {
			if (missing(main)) main = ""
			out <- plot(x, 1, maxcell=maxcell, main=main[1], mar=mar, ...)
			return(invisible(out))
		}

		nrnc <- .get_nrnc(nr, nc, nl)
		old.par <- graphics::par(no.readonly = TRUE) 
		on.exit(graphics::par(old.par))
		if (is.null(mar)) {
			mar=c(1.5, 1.5, 1.5, 3)
		}
		graphics::par(mfrow=nrnc)
		maxcell=maxcell/(nl/2)

		if (missing("main")) {
			main <- names(x)
		} else {
			main <- rep_len(main, nl)
		}
		x <- spatSample(x, maxcell, method="regular", as.raster=TRUE)
		for (i in 1:nl) {
			plot(x, i, main=main[i], mar=mar, ...)
		}
	}
)



