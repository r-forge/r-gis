# Read geographic data into R objects (first download  the data if not locally avaialble)"
# Part of Rgis package
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 1, October 2008


read.srtm <- function(x=106, y=-6, download=TRUE) {
	pack <- 'Rgis'
	varname <- 'srtm'
	
	x <- min(180, max(-180, x))
	y <- min(60, max(-60, y))
	rs <- raster.create.new(nrows=24, ncols=72, ymin=-60, ymax=60 )
	row <- raster.get.row.from.y(rs, y)
	col <- raster.get.col.from.x(rs, x)
	if (row < 10) { row <- paste('0', row, sep='') }
	if (col < 10) { col <- paste('0', col, sep='') }
	
	f <- paste(varname, '_', col, '_', row, sep="")
	zipfilename <- paste(system.file(package=pack), "/data/", f, ".ZIP", sep="")
	tiffilename <- paste(system.file(package=pack), "/data/", f, ".TIF", sep="")
	
	if (!file.exists(tiffilename)) {
		if (!file.exists(zipfilename)) {
			if (download) { 
				theurl <- paste("http://hypersphere.telascience.org/elevation/cgiar_srtm_v4/tiff/zip/", f, ".ZIP", sep="")
				download.file(url=theurl, destfile=zipfilename, method="auto", quiet = FALSE, mode = 'wb', cacheOK = TRUE)
			} else {cat('file not available locally, use download=TRUE\n') }	
		}
		if (file.exists(zipfilename)) { 
			wd <- getwd()
			setwd( paste(system.file(package=pack), "/data", sep='') )
			zipfn <- paste(f, ".ZIP", sep="")
			fn <- paste(f, ".TIF", sep="")
			zip.file.extract(file = fn, zipname = zipfn)
			file.remove(zipfn)
			setwd(wd)
			tmpfile <- paste(tempdir(), '/', fn, sep="") 
			file.copy(tmpfile, tiffilename, overwrite = FALSE)
			file.remove(tmpfile)
		}	
	}
	if (file.exists(tiffilename)) { 
		rs <- raster.create.from.file(tiffilename)
		rs@projection <- CRS("+proj=longlat +datum=WGS84")
		return(rs)
	}	
}

