# Read geographic data into R objects (first download  the data if not locally avaialble)"
# Part of Rgis package
# Author: Robert J. Hijmans, r.hijmans@gmail.com
# License GPL3
# Version 1, October 2008


SRTM <- function(x=106, y=-6, download=TRUE) {
	varname <- 'srtm'
	path <- dataPath()
	
	x <- min(180, max(-180, x))
	y <- min(60, max(-60, y))
	rs <- raster(nrows=24, ncols=72, xmn=-180, xmx=180, ymn=-60, ymx=60 )
	row <- rowFromY(rs, y)
	col <- colFromX(rs, x)
	if (row < 10) { row <- paste('0', row, sep='') }
	if (col < 10) { col <- paste('0', col, sep='') }
	
	f <- paste(varname, '_', col, '_', row, sep="")
	zipfilename <- paste(path, "/", f, ".ZIP", sep="")
	tiffilename <- paste(path, "/", f, ".TIF", sep="")
	
	if (!file.exists(tiffilename)) {
		if (!file.exists(zipfilename)) {
			if (download) { 
				theurl <- paste("http://hypersphere.telascience.org/elevation/cgiar_srtm_v4/tiff/zip/", f, ".ZIP", sep="")
				download.file(url=theurl, destfile=zipfilename, method="auto", quiet = FALSE, mode = 'wb', cacheOK = TRUE)
			} else {cat('file not available locally, use download=TRUE\n') }	
		}
		if (file.exists(zipfilename)) { 
			wd <- getwd()
			setwd( path )
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
		rs <- raster(tiffilename)
		projection(rs) <- "+proj=longlat +datum=WGS84"
		return(rs)
	}	
}

