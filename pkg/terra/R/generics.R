# Author: Robert J. Hijmans
# Date : October 2018
# Version 1.0
# License GPL v3


setMethod("origin", signature(x="SpatRaster"), 
	function(x, ...) {
		x@ptr$origin
	}
)


setMethod("align", signature(x="SpatExtent", y="SpatRaster"), 
	function(x, y, snap="near", ...) {
		x@ptr <- y@ptr$align(x@ptr, tolower(snap))
		#messages(x, "align")
		x
	}
)

setMethod("align", signature(x="SpatExtent", y="numeric"), 
	function(x, y, ...) {
		x@ptr <- x@ptr$align(y, "")
		x
	}
)


setMethod("area", signature(x="SpatRaster"), 
	function(x, sum=TRUE, correct=FALSE, filename="", overwrite=FALSE, wopt=list(), ...) {
		if (sum) {
			byvalue = FALSE
			opt <- .getOptions()
			if (byvalue) {
				v <- x@ptr$area_by_value(opt)
				v <- lapply(1:length(v), function(i) cbind(i, matrix(v[[i]], ncol=2)))
				v <- do.call(rbind, v)
				colnames(v) <- c("layer", "value", "area")
				return(v)
			} else {
				x@ptr$sum_area(correct, opt)
			}
		} else {
			opt <- spatOptions(filename, overwrite, wopt)
			x@ptr <- x@ptr$rst_area(correct, opt)
			messages(x, "area")
		} 
	}
)



setMethod("atan2", signature(y="SpatRaster", x="SpatRaster"),
	function(y, x) { 
		opt <- spatOptions(filename="", overwrite=TRUE, wopt=list())
		y@ptr <- y@ptr$atan2(x@ptr, opt)
		messages(y, "atan2")
	}
)


setMethod("boundaries", signature(x="SpatRaster"), 
	function(x, classes=FALSE, type="inner", directions=8, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite,wopt)
		x@ptr <- x@ptr$boundaries(classes[1], type[1], directions[1], opt)
		messages(x, "boundaries")
	}
)


.collapseSources <- function(x) {
	x@ptr <- x@ptr$collapse_sources()
	messages(x, "collapse")
}

setMethod("copy", signature("SpatRaster"), 
	function(x, ...) {
		x@ptr <- x@ptr$deepcopy() 
		x
	}
)


setMethod("add<-", signature("SpatRaster", "SpatRaster"), 
	function(x, value) {
		if (x@ptr$same(value@ptr)) {
			x@ptr <- x@ptr$deepcopy() 
		}
		x@ptr$addSource(value@ptr)
		messages(x, "add")
	}
)

setMethod("collapse", signature("SpatRaster"), 
	function(x, ...) {
		x@ptr <- x@ptr$collapse_sources()
		messages(x, "collapse")
	}
)

setMethod("collapse", signature("SpatRasterDataset"), 
	function(x, ...) {
		y <- new("SpatRaster")
		y@ptr <- x@ptr$collapse()
		messages(y, "collapse")
	}
)


#setMethod("c", signature(x="SpatRaster"), 
#	function(x, ...) {
#		s <- sds(list(x, ...))
#		x@ptr <- s@ptr$collapse()
#		x <- messages(x, "c")
#		try( x@ptr <- x@ptr$collapse_sources() )
#		messages(x, "c")
#	}
#)



setMethod("c", signature(x="SpatRaster"), 
	function(x, ...) {
		skipped <- FALSE
		dots <- list(...)
		for (i in dots) {
			if (inherits(i, "SpatRaster")) {
				x@ptr <- x@ptr$combineSources(i@ptr)
				if (x@ptr$messages$has_error) {
					messages(x, "c")
					return()
				}
			} else {
				skipped = TRUE
			}
		}
		if (skipped) warn("c,SpatRaster", "skipped object that are not SpatRaster")
		messages(x, "c")
	}
)


setMethod("c", signature(x="SpatVector"), 
	function(x, ...) {
		skipped <- FALSE
		dots <- list(...)
		for (i in dots) {
			if (inherits(i, "SpatVector")) {
				x@ptr <- x@ptr$append(i@ptr, FALSE)
				if (x@ptr$messages$has_error) {
					messages(x, "c")
					return()
				}
			} else {
				skipped = TRUE
			}
		}
		if (skipped) warn("c,SpatVector", "skipped object that are not SpatVector")
		messages(x, "c")
	}
)

setMethod("rep", signature(x="SpatRaster"), 
	function(x, ...) {
		i <- rep(1:nlyr(x), ...)
		x[[i]]
	}
)


setMethod("clamp", signature(x="SpatRaster"), 
	function(x, lower=-Inf, upper=Inf, values=TRUE, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite,wopt)
		x@ptr <- x@ptr$clamp(lower, upper, values[1], opt)
		messages(x, "clamp")
	}
)


setMethod("classify", signature(x="SpatRaster"), 
function(x, rcl, include.lowest=FALSE, right=TRUE, othersNA=FALSE, filename="", overwrite=FALSE, wopt=list(), ...) {

	if (is.data.frame(rcl)) {
		rcl <- as.matrix(rcl)
	}

	right <- ifelse(is.na(right), 2, ifelse(right, 1, 0))
	include.lowest <- as.logical(include.lowest[1])

	opt <- spatOptions(filename, overwrite, wopt)
    x@ptr <- x@ptr$classify(as.vector(rcl), NCOL(rcl), right, include.lowest, othersNA, opt)
	messages(x, "classify")
}
)


.getExt <- function(x) {
	return(x)
}

setMethod("crop", signature(x="SpatRaster", y="ANY"), 
	function(x, y, snap="near", filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite, wopt)

		if (!inherits(y, "SpatExtent")) {
			e <- try(ext(y), silent=TRUE)
			if (class(e) == "try-error") { 
				e <- try(raster::extent(y), silent=TRUE)
				if (class(e) == "try-error") { 
					error("crop", "cannot get an extent from y")
				}
				e <- ext(as.vector(t(raster::bbox(e))))
			}
			y <- e
		}

		x@ptr <- x@ptr$crop(y@ptr, snap[1], opt)
		messages(x, "crop")
	}
)


setMethod("selectRange", signature(x="SpatRaster"), 
	function(x, y, z=1, repint=0, filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$selRange(y@ptr, z, repint, opt)
		messages(x, "selectRange")
	}
)

setMethod("cover", signature(x="SpatRaster", y="SpatRaster"), 
	function(x, y, values=NA, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$cover(y@ptr, values, opt)
		messages(x, "cover")
	}
)


setMethod("diff", signature(x="SpatRaster"), 
	function(x, filename="", overwrite=FALSE, wopt=list(), ...) { 
		n = nlyr(x)
		if (n<2) return(rast(x))
		y = x[[-1]]
		x = x[[-n]]
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$arith_rast(y@ptr, "-", opt)
		messages(x, "diff")
	}
)


setMethod("disaggregate", signature(x="SpatRaster"), 
	function(x, fact, method="near", filename="", overwrite=FALSE, wopt=list(), ...) {
		stopifnot(method %in% c("near", "bilinear"))
		if (method == "bilinear") {
			y <- disaggregate(rast(x), fact)
			r <- resample(x, y, "bilinear", filename=filename, overwrite=overwrite, wopt=wopt, ...)
			return(r)
		}
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$disaggregate(fact, opt)
		messages(x, "disaggregate")
	}
)


setMethod("flip", signature(x="SpatRaster"), 
	function(x, direction="vertical", filename="", overwrite=FALSE, wopt=list(), ...) {
		d <- match.arg(direction, c("vertical", "horizontal")) 
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$flip(d == "vertical", opt)
		messages(x, "flip")
	}
)

setMethod("flip", signature(x="SpatVector"), 
	function(x, direction="vertical", ...) {
		d <- match.arg(direction, c("vertical", "horizontal")) 
		x@ptr <- x@ptr$flip(d == "vertical")
		messages(x, "flip")
	}
)


setMethod("freq", signature(x="SpatRaster"), 
	function(x, digits=0, value=NULL, bylayer=TRUE, ...) {

		opt <- spatOptions("", TRUE, list())

		if (!is.null(value)) {
			if (is.na(digits)) {
				v <- x@ptr$count(value, bylayer[1], FALSE, 0, opt)
			} else {
				v <- x@ptr$count(value, bylayer[1], TRUE, digits, opt)
				value <- round(value, digits)
			}
			if (bylayer) {
				v <- cbind(layer=1:nlyr(x), value=value, count=v)
			} else {
				v <- cbind(value=value, count=v)
			}
		} else {
			if (is.na(digits)) {
				v <- x@ptr$freq(bylayer[1], FALSE, 0, opt)
			} else {
				v <- x@ptr$freq(bylayer[1], TRUE, digits, opt)
			}
			if (bylayer) {
				v <- lapply(1:length(v), function(i) cbind(i, matrix(v[[i]], ncol=2)))
				v <- do.call(rbind, v)
				colnames(v) <- c("layer", "value", "count")
			} else {
				v <- matrix(v[[1]], ncol=2, dimnames=list(NULL, c("value", "count")))
			}
		}
		v
	}
)



setMethod("mask", signature(x="SpatRaster", mask="SpatRaster"), 
	function(x, mask, inverse=FALSE, maskvalues=NA, updatevalue=NA, filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite,wopt)
		x@ptr <- x@ptr$mask_raster(mask@ptr, inverse[1], maskvalues, updatevalue[1], opt)
		messages(x, "mask")
	}
)

setMethod("mask", signature(x="SpatRaster", mask="SpatVector"), 
	function(x, mask, inverse=FALSE, updatevalue=NA, touches=is.lines(mask), filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite,wopt)
		x@ptr <- x@ptr$mask_vector(mask@ptr, inverse[1], updatevalue[1], opt)
		messages(x, "mask")
	}
)


setMethod("project", signature(x="SpatRaster"), 
	function(x, y, method="bilinear", mask=FALSE, filename="", overwrite=FALSE, wopt=list(), ...)  {

		method <- ifelse(method == "ngb", "near", method)
		opt <- spatOptions(filename, overwrite, wopt)
		if (inherits(y, "SpatRaster")) {
			#x@ptr <- x@ptr$warp(y@ptr, method, opt)
			x@ptr <- x@ptr$warp(y@ptr, "", method, mask, opt)
		} else {
			if (!is.character(y)) {
				warn("project,SpatRaster", "crs should be a character value")
				y <- as.character(crs(y))
			}
			#x@ptr <- x@ptr$warpcrs(y, method, opt)
			x@ptr <- x@ptr$warp(SpatRaster$new(), y, method, mask, opt)
		}
		messages(x, "project")
	}
)


setMethod("project", signature(x="SpatVector"), 
	function(x, y, ...)  {
		if (!is.character(y)) {
			y <- crs(y)
		}
		x@ptr <- x@ptr$project(y)
		messages(x, "project")
	}
)


setMethod("quantile", signature(x="SpatRaster"), 
	function(x, probs=seq(0, 1, 0.25), na.rm=FALSE, filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$quantile(probs, na.rm[1], opt)
		messages(x, "quantile")
	}
)



setMethod("rectify", signature(x="SpatRaster"), 
	function(x, method="bilinear", aoi=NULL, snap=TRUE, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite, wopt)
		if (!is.null(aoi)) {
			if (inherits(aoi, "SpatExtent")) {
				aoi <- rast(aoi)
				useaoi <- 1
			} else if (inherits(aoi, "SpatRaster")) {
				aoi <- rast(aoi)
				useaoi <- 2
			} else {
				error("rectify", "ext must be a SpatExtent or SpatRaster")
			}
		} else {
			aoi <- rast()
			useaoi <- 0
		}
		snap <- as.logical(snap)
		x@ptr <- x@ptr$rectify(method, aoi@ptr, useaoi, snap, opt)
		messages(x, "rectify")
	}
)

setMethod("resample", signature(x="SpatRaster", y="SpatRaster"), 
	function(x, y, method="bilinear", filename="", overwrite=FALSE, wopt=list(), ...)  {
		method <- ifelse(method == "ngb", "near", method)
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$warp(y@ptr, "", method, FALSE, opt)
		messages(x, "resample")
	}
)



setMethod("rev", signature(x="SpatRaster"), 
	function(x) { 
		opt <- spatOptions("", FALSE, list())
		x@ptr <- x@ptr$reverse(opt)
		messages(x, "rev")
	}
)

setMethod("rotate", signature(x="SpatRaster"), 
	function(x, left=TRUE, filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$rotate(left, opt)
		messages(x, "rotate")
	}
)

setMethod("spin", signature(x="SpatVector"), 
	function(x, angle, x0, y0, ...) { 
		e <- as.vector(ext(x))
		if (missing(x0)) {
			x0 <- mean(e[1:2])
		}
		if (missing(y0)) {
			y0 <- mean(e[3:4])
		}
		angle <- angle[1]
		stopifnot(is.numeric(angle) && !is.nan(angle))
		x@ptr <- x@ptr$rotate(angle, x0[1], y0[1])
		messages(x, "spin")
	}
)

setMethod("separate", signature(x="SpatRaster"), 
	function(x, classes=NULL, keep=FALSE, other=0, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite,wopt)
		if (is.null(classes)) classes <- 1[0]
		x@ptr <- x@ptr$separate(classes, keep, other, opt)
		messages(x, "separate")
	}
)


setMethod("shift", signature(x="SpatRaster"), 
	function(x, dx=0, dy=0, filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$shift(dx, dy, opt)
		messages(x, "shift")
	}
)


setMethod("shift", signature(x="SpatExtent"), 
	function(x, dx=0, dy=0, ...) { 
		s <- c(dx[1], dx[1], dy[1], dy[1])
		ext(as.vector(x) + s)
	}
)


setMethod("shift", signature(x="SpatVector"), 
	function(x, dx=0, dy=0, ...) { 
		x@ptr <- x@ptr$shift(dx, dy)
		messages(x, "shift")
	}
)

setMethod("rescale", signature(x="SpatRaster"), 
	function(x, f=0.5, x0, y0, ...) { 
		e <- as.vector(ext(x))
		if (missing(x0)) {
			x0 <- mean(e[1:2])
		}
		if (missing(y0)) {
			y0 <- mean(e[3:4])
		}
		ex = x0 + f * (e[1:2] - x0);
		ey = y0 + f * (e[3:4] - y0);
		x@ptr <- x@ptr$deepcopy()
		ext(x) <- ext(c(ex, ey))
		messages(x, "rescale")
	}
)

setMethod("rescale", signature(x="SpatVector"), 
	function(x, f=0.5, x0, y0, ...) { 
		e <- as.vector(ext(x))
		if (missing(x0)) {
			x0 <- mean(e[1:2])
		}
		if (missing(y0)) {
			y0 <- mean(e[3:4])
		}
		x@ptr <- x@ptr$rescale(f, x0[1], y0[1])
		messages(x, "rescale")
	}
)


setMethod("scale", signature(x="SpatRaster"), 
	function(x, center=TRUE, scale=TRUE) { 
		opt <- spatOptions("", TRUE, list())

		if (is.logical(center)) {
			docenter = center[1];
			center = 1[0]
		} else {
			docenter = TRUE
		}
		if (is.logical(scale)) {
			doscale = scale[1]
			scale = 1[0]
		} else {
			doscale = TRUE;
		}
		x@ptr <- x@ptr$scale(center, docenter, scale, doscale, opt)
		messages(x, "scale")
	}
)


setMethod("slope", signature(x="SpatRaster"), 
	function(x, neighbors=8, unit="degrees", filename="", overwrite=FALSE, wopt=list(), ...) { 
		opt <- spatOptions(filename, overwrite, wopt)
		unit <- match.arg(unit, c("degrees", "radians"))
		x@ptr <- x@ptr$slope(neighbors[1], unit=="degrees", opt)
		messages(x, "slope")
	}
)



setMethod("stretch", signature(x="SpatRaster"), 
	function(x, minv=0, maxv=255, minq=0, maxq=1, smin=NA, smax=NA, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$stretch(minv, maxv, minq, maxq, smin, smax, opt)
		messages(x, "stretch")
	}
)



setMethod("summary", signature(object="SpatRaster"), 
	function(object, size=100000, warn=TRUE, ...)  {
		if (warn && (ncell(object) > size)) {
			warn("summary", "used a sample")
		}
		summary(spatSample(object, size, method="regular"), ...)
	}
)


setMethod("summary", signature(object="SpatVector"), 
	function(object, ...)  {
		summary(as.data.frame(object), ...)
	}
)


setMethod("t", signature(x="SpatRaster"), 
	function(x) {
		opt <- spatOptions(filename="", overwrite=TRUE, wopt=list())
		x@ptr <- x@ptr$transpose(opt)
		messages(x, "t")
	}
)

setMethod("t", signature(x="SpatVector"), 
	function(x) {
		x@ptr <- x@ptr$transpose()
		messages(x, "t")
	}
)


setMethod("trim", signature(x="SpatRaster"), 
	function(x, padding=0, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$trim(padding[1], opt)
		messages(x, "rasterize")
	}
)

setMethod("transpose", signature(x="SpatRaster"), 
	function(x, filename="", overwrite=FALSE, wopt=list(), ...) {
		opt <- spatOptions(filename, overwrite, wopt)
		x@ptr <- x@ptr$transpose(opt)
		messages(x, "transpose")
	}
)

setMethod("unique", signature(x="SpatRaster", incomparables="ANY"), 
	function(x, incomparables=FALSE, ...) {
		opt <- .getOptions()
		u <- x@ptr$unique(incomparables, opt)
		if (!incomparables) {
			if (!length(u)) return(u)
			u <- do.call(cbind, u)
			colnames(u) = names(x)
		}
		u
	}
)

setMethod("unique", signature(x="SpatVector", incomparables="ANY"), 
	function(x, incomparables=FALSE, ...) {
		u <- unique(as.data.frame(x, geom=TRUE), incomparables=incomparables, ...)
		v <- vect(u, geom="geometry")
		v$geometry <- NULL
		crs(v) <- crs(x)
		v
	}
)


#setMethod("warp", signature(x="SpatRaster", y="SpatRaster"), 
#	function(x, y, method="bilinear", filename="", overwrite=FALSE, wopt=list(), ...)  {
#		opt <- spatOptions(filename, overwrite, wopt)
#		x@ptr <- x@ptr$warp(y@ptr, "", method, opt)
#		messages(x, "warp")
#	}
#)

