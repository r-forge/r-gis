
.seed <- function() {
  sample.int(.Machine$integer.max, 1)
}


.sampleCells <- function(x, size, method, replace) {
	lonlat <- is.lonlat(x, perhaps=TRUE, warn=TRUE)
	if (method == "random") {
		if (lonlat) {
			m <- ifelse(replace, 1.5, 1.25)
			n <- m * size
			r <- yFromRow(x, 1:nrow(x))
			w <- abs(cos(pi*r/180))
			rows <- sample.int(nrow(x), n, replace=TRUE, prob=w)
			cols <- sample.int(ncol(x), n, replace=TRUE)
			cells <- cellFromRowCol(x, rows, cols)
			if (!replace) {
				cells <- unique(cells)
			}
			if (length(cells) > size) {
				cells <- cells[1:size]
			} 
		} else {
			cells <- sample(ncell(x), size, replace=replace)
		}
	} else { # regular 
		if (lonlat) {
			ratio <- 0.5 * ncol(x)/nrow(x)
			n <- sqrt(size)
			nx <- max(1, (round(n*ratio)))
			ny <- max(1, (round(n/ratio)))
			xi <- ncol(x) / nx
			yi <- nrow(x) / ny
			rows <- unique(round(seq(.5*yi, nrow(x), yi)))

			w <- cos(pi*yFromRow(x, rows)/180)
			w <- w * length(w)/sum(w)
			xi <- xi / w
			xi <- pmax(1,pmin(xi, ncol(x)))
			z <- list()
			#off <- stats::runif(1) 			
			for (i in 1:length(rows)) {
				z[[i]] <- cbind(rows[i], unique(round(seq(0.5*xi[i], ncol(x), xi[i]))))
			}
			z <- do.call(rbind, z)
			cells <- cellFromRowCol(x, z[,1], z[,2])
	
		} else {
			f <- sqrt(size / ncell(x))
			nr <- ceiling(nrow(x) * f)
			nc <- ceiling(ncol(x) * f);
			xstep <- ncol(x) / nc
			ystep <- nrow(x) / nr
			xsamp <- seq(0.5*xstep, ncol(x), xstep)
			ysamp <- seq(0.5*ystep, nrow(x), ystep)
			xy <- expand.grid(round(ysamp), round(xsamp))
			cells <- cellFromRowCol(x, xy[,1], xy[,2]) 
		}
	}
	return(cells)
}

setMethod("spatSample", signature(x="SpatRaster"), 
	function(x, size, method="regular", replace=FALSE, na.rm=FALSE, as.raster=FALSE, cells=FALSE, ...) {
		size <- round(size)
		if (size < 1) {
			error("spatSample", "sample size must be a positive integer")
		}
		#if ((size > ncell(x)) & (!replace)) {
			#error("spatSample", "sample size is larger than ncell(x) and replace=FALSE")
		#}
		
		if (cells) {
			out <- .sampleCells(x, size, method, replace)
			if (length(out) < size) {
				warn("spatSample", "fewer cells returned than requested")
			}
			return(out)
		}
		if (!hasValues(x) & !as.raster) {
			error("spatSample", "SpatRaster has no values. Use cells=TRUE or as.raster=TRUE")
		}

		method <- tolower(method)
		stopifnot(method %in% c("random", "regular"))
		size <- round(size)
		stopifnot(size > 0)
		size <- min(ncell(x), size)

		if (method == "regular") {
			if (as.raster) {
				x@ptr <- x@ptr$sampleRegularRaster(size)
				x <- messages(x, "spatSample")
				return(x);
			} else {
				v <- x@ptr$sampleRegularValues(size)
				x <- messages(x, "spatSample")
				if (length(v) > 0) {
					v <- do.call(cbind, v)
					colnames(v) <- names(x)
				}
				return(v)
			}
		} else { # random
			if (as.raster) {
				x@ptr <- x@ptr$sampleRandomRaster(size, replace, .seed())
				x <- messages(x, "spatSample")
				return(x);
			} else {
				#v <- x@ptr$sampleRandomValues(size, replace, seed)
				if (size > 0.75 * ncell(x)) {
					if (na.rm) {
						out <- stats::na.omit(values(x))
						attr(x, "na.action") <- NULL
						if (nrow(out) < size) {
							warn("spatSample", "more non NA cells requested than available")
						} else {
							out <- out[sample(nrow(out), size), ]
						}
					} else {
						out <- out[sample(nrow(out), size, replace=replace), ]
					}
					return	(out)
				}

				if (na.rm) {
					scells <- NULL
					ssize <- size*2
					for (i in 1:10) {
						scells <- c(scells, .sampleCells(x, ssize, method, replace))
						if ((i>1) && (!replace)) {
							scells <- unique(scells)
						}
						out <- stats::na.omit(x[scells])
						if (nrow(out) >= size) {
							out <- out[1:size, ,drop=FALSE]
							attr(out, "na.action") <- NULL
							break
						}
					}
				} else {
					scells <- .sampleCells(x, size, method, replace)
					out <- x[scells]
				}
				if (NROW(out) < size) {
					warn("spatSample", "fewer values returned than requested")
				}
				return(out)
			}
		}
	}
)


setMethod("spatSample", signature(x="SpatExtent"), 
	function(x, size, method="regular", lonlat, ...) {
		if (missing(lonlat)) {
			error("spatSample", "provide a lonlat argument")
		}
		method = match.arg(method, c("regular", "random"))
		size <- round(size)
		stopifnot(size > 0)
		if (method=="random") {
			s <- x@ptr$sampleRandom(size, lonlat, .seed())
		} else {
			s <- x@ptr$sampleRegular(size, lonlat)
		}
		s <- do.call(cbind, s)
		colnames(s) <- c("x", "y")
		s
	}
)





.grid_sample <- function(xy, n=1, r, chess="") {

	cell <- cellFromXY(r, xy)
    uc <- unique(stats::na.omit(cell))
	
	chess <- trim(chess)
	if (chess != "") {
		chess <- match.arg(tolower(chess), c("white", "black"))
		nc <- ncol(r)
		if (nc %% 2 == 1) {
			if (chess=="white") {
				tf <- 1:ceiling(ncell(r)/2) * 2 - 1
			} else {
				tf <- 1:ceiling((ncell(r)-1)/2) * 2 
			}
		} else {
			nr <- nrow(r)
			row1 <- 1:(ceiling(nr / 2)) * 2 - 1
			row2 <- row1 + 1
			row2 <- row2[row2 <= nr]
			
			if (chess=="white") {
				col1 <- 1:(ceiling(nc / 2)) * 2 - 1
				col2 <- col1 + 1
				col2 <- col2[col2 <= nc]
			} else {
				col1 <- 1:(ceiling(nc / 2)) * 2
				col2 <- col1 - 1
				col1 <- col1[col1 <= nc]
			}
				
			cells1 <- cellFromRowColCombine(r, row1, col1)
			cells2 <- cellFromRowColCombine(r, row2, col2)
			tf <- c(cells1, cells2)
		}	
		uc <- uc[uc %in% tf]
	}
	
    cell <- cellFromXY(r, xy)
    cell <- cbind(1:nrow(xy), cell, stats::runif(nrow(xy)))
	cell <- stats::na.omit(cell)

    cell <- cell[order(cell[,3]), ]
    sel <- list()
    for (i in 1:length(uc)) {
        ss <- subset(cell, cell[,2] == uc[i])
        sel[[i]] <- ss[1:min(n, nrow(ss)), 1]
    }
	unlist(sel)
}


coordinates <- function(x) {
	do.call(cbind, x@ptr$coordinates())
}

get_field_name <- function(x, nms, sender="") {
	x <- x[1]
	if (is.numeric(x)) {
		x <- round(x)
		if (x > 0 && x <= length(nms)) {
			x = nms[x]
		} else {
			error(sender, "invalid index. there are ", length(nms), " columns")
		}
	} else if (is.character(x)) {
		if (!(x %in% nms)) {
			error(sender, "invalid name")
		}
	}
	x
}


setMethod("spatSample", signature(x="SpatVector"), 
	function(x, size, method="regular", by_geom=TRUE, strata=NULL, chess="", ...) {
		method = match.arg(tolower(method), c("regular", "random"))
		stopifnot(size > 0)
		gtype <- geomtype(x)
		if (gtype == "polygons") {
			st <- ""
			if (!is.null(strata)) {
				st <- get_field_name(strata, names(x), "spatSample")
			} 
			x@ptr = x@ptr$sample(size[1], method[1], by_geom[1], st, .seed())
			return(messages(x))
		} else if (grepl(gtype, "points")) {
			if (!is.null(strata)) {
				if (inherits(strata, "SpatRaster")) {
					xy <- coordinates(x)
					strata <- rast(strata)
					i <- .grid_sample(xy, size, strata, chess) 
					return(x[i,])
				} else {
					error("spatSample", "not yet implemented for these strata")
				}
			} else {
				error("spatSample", "use `sample` to sample (point) geometries")
			}
		} else {
			error("spatSample", "not yet implemented for lines")
		}
	}
)

#spatSample(disaggregate(as.points(v)), 1, "stratified", strata=r, chess="")



# setMethod("spatSample", signature(x="SpatExtent"), 
	# function(x, size, method="regular", lonlat, ...) {
		# if (missing(lonlat)) {
			# stop("provide a lonlat argument")
		# }
		# method = match.arg(method, c("regular", "random"))
		# size <- round(size)
		# stopifnot(size > 0)
		# e <- as.vector(x)
		# if (method=="random") {
			# if (lonlat) {
				# d <- round((e[4] - e[3]) * 1000);
				# dx <- (e[4] - e[3]) / (2 * d)
				# r <- unique(seq(e[3], e[4], length.out=d))
				# w <- abs(cos(pi*r/180))
				# x <- sample.int(length(r), size, prob=w, replace=TRUE)
				# lat <- r[x] + stats::runif(size, -dx, dx)
				# lon <- stats::runif(size, min = e[1], max = e[2])
				# vect(cbind(lon,lat), crs="+proj=lonlat +datum=WGS84")
			# } else {
				# x <- stats::runif(size, min = e[1], max = e[2])
				# y <- stats::runif(size, min = e[3], max = e[4])
				# vect(cbind(x, y))
			# }
		# } else {
			# r <- range(x)
			# ratio <- 0.5 * r[1]/r[2]
			# n <- sqrt(size)
			# nx <- max(1, (round(n*ratio)))
			# ny <- max(1, (round(n/ratio)))
			# xi <- r[1] / nx
			# yi <- r[2] / ny
			# if (lonlat) {
				# lat <- seq(e[3]+0.5*yi, e[4], yi)
				# w <- cos(pi*lat/180)
				# w <- w * length(w)/sum(w)
				# xi <- xi / w
				# xi <- pmin(xi, 180)
				# z <- list()
				# #off <- stats::runif(1) 			
				# for (i in 1:length(lat)) {
					# z[[i]] <- cbind(seq(e[1]+0.5*xi[i], e[2], xi[i]), lat[i])
				# }
				# z <- do.call(rbind, z)
				# vect(z, crs="+proj=lonlat +datum=WGS84")		
			# } else {
				# x <- seq(e[1]+0.5*xi, e[2], xi)
				# y <- seq(e[3]+0.5*yi, e[4], yi)
				# vect(cbind(rep(x, length(y)), rep(y, each=length(x))))
			# }
		# }
	# }
# )
