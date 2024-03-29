
setMethod("lines", signature(x="SpatRaster"),
function(x, mx=50000, ...) {
		if(prod(dim(x)) > mx) {
			error("lines", "too many lines (you can increase the value of mx)")
		}
		v <- as.polygons(x)
		lines(v, ...)
	}
)

setMethod("lines", signature(x="SpatVector"), 
	function(x, y=NULL, col, lwd=1, lty=1, arrows=FALSE, ...)  {
		gtype <- geomtype(x)
		if (missing(col)) col <- "black"
		if (!is.null(y)) {
			stopifnot(inherits(y, "SpatVector"))
			ytype <- geomtype(y)
			if ((ytype != "points") || (gtype != "points")) {
				error("lines", "when supplying two SpatVectors, both must have point geometry")
			}
			stopifnot(nrow(x) == nrow(y))	
			p1 <- geom(x)[, c("x", "y")]
			p2 <- geom(y)[, c("x", "y")]
			if (arrows) {
				arrows(p1[,1], p1[,2], p2[,1], p2[,2], col=col, lwd=lwd, lty=lty, ...)
			} else {
				a <- as.vector(t(cbind(p1[,1], p2[,1], NA)))
				b <- as.vector(t(cbind(p1[,2], p2[,2], NA)))
				lines(cbind(a, b), col=col, lwd=lwd, lty=lty, ...)
			}
		} else if (grepl("points", gtype)) {
			points(x, col=col, type="l", lwd=lwd, lty=lty, ...)
		} else {
			n <- size(x)
			col <- .getCols(n, col)
			lwd <- rep_len(lwd, n)
			lty <- rep_len(lty, n)
			g <- geom(x, df=TRUE)
			g <- split(g, g[,1])
			if (gtype == "polygons") {
				g <- lapply(g, function(x) split(x, x[,c(2,5)]))
			} else {
				g <- lapply(g, function(x) split(x, x[,2]))
			}
			#p <- sapply(g, function(x) lapply(x, function(y) graphics::lines(y[,3:4], ...)))
			for (i in 1:length(g)) {
				x <- g[[i]]
				for (j in 1:length(x)) {
					lines(x[[j]][,3:4], col=col[i], lwd=lwd[i], lty=lty[i], ...)
				}
			}
		}
	}
)


setMethod("points", signature(x="SpatVector"), 
	function(x, col, cex=1, pch=20, ...)  {
		if (missing(col)) col <- "black"
		n <- size(x)
		col <- .getCols(n, col)
		cex <- rep_len(cex, n)
		pch <- rep_len(pch, n)
		g <- geom(x, df=TRUE)
		if (any(table(g$id) > 1)) {
			g <- split(g, g[,1])
			for (i in 1:n) {
				graphics::points(g[[i]][,3:4], col=col[i], pch=pch[i], cex=cex[i], ...)
			}
		} else {
			graphics::points(g[,3:4], col=col,  pch=pch, cex=cex,...)
		}
	}
)

setMethod("polys", signature(x="SpatVector"), 
	function(x, col, border="black", lwd=1, lty=1, ...)  {
		gtype <- geomtype(x)
		if (gtype != "polygons") {
			error("polys", "expecting polygons")
		}
		if (missing(col)) {
			col <- NULL
		}
		cols <- .getCols(size(x), col)
		out <- list(main_cols=col)
		out$leg$border <- border
		.plotPolygons(x, out, lwd=lwd, lty=lty, ...)
	}
)

