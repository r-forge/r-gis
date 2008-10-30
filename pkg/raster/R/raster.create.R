# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date : June 2008
# Version 0,1
# Licence GPL v3

.raster.new.Spatial <- function(xmin, xmax, ymin, ymax, projection="") {
	bb <- new("Spatial")
	bb@bbox[1,1] <- xmin
	bb@bbox[1,2] <- xmax
	bb@bbox[2,1] <- ymin
	bb@bbox[2,2] <- ymax
	bb@bbox[3,1] <- 0
	bb@bbox[3,2] <- 1
	bb <- set.projection(bb, projection)
	return(bb)
}


raster.new <- function(xmin=-180, xmax=180, ymin=-90, ymax=90, nrows=180, ncols=360, projection="+proj=longlat +datum=WGS84") {
	valid <- TRUE
	nr = as.integer(round(nrows))
	nc = as.integer(round(ncols))
	if (nc < 1) { stop("ncols should be larger than 0") }
	if (nr < 1) { stop("nrows should be larger than 0") }
	bb <- .raster.new.Spatial(xmin, xmax, ymin, ymax, projection)
	if (validObject(bbox)) {
		raster <- new("Raster", bbox = bb@bbox, proj4string=bb@proj4string, ncols = nc, nrows = nr )
		raster@data@content <- 'nodata'
		return(raster) 
	} else {
		return <- NA 
	}
}


raster.from.file <- function(filename, band=1) {
	if (toupper(file.get.extension(filename)) == ".GRD") {
		raster <- .raster.create.from.file.binary(filename, band) 
	} else {
		raster <- .raster.create.from.file.gdal(filename, band) 
	}
	return(raster)
}	
	
	
.raster.create.from.file.gdal <- function(filename, band) {	
	gdalinfo <- GDALinfo(filename)
	nc <- as.integer(gdalinfo[["columns"]])
	nr <- as.integer(gdalinfo[["rows"]])
	xn <- gdalinfo[["ll.x"]]
	if (xn < 0) { ndecs <- 9 } else  { ndecs <- 8 }
	xn <- as.numeric( substr( as.character(xn), 1, ndecs) )

	xx <- xn + gdalinfo[["res.x"]] * nc
	if (xx < 0) { ndecs <- 9 } else  { ndecs <- 8 }
	xx <- as.numeric( substr( as.character(xx), 1, ndecs) )
		
#   as "ll" stands for lower left corner , it should be this,  yn <- gdalinfo[["ll.y"]];   yx <- ymin + gdalinfo[["res.y"]]  * raster$nrows
#  but in fact  the upper left corner "ul" is returned so we do this:
	yx <- gdalinfo[["ll.y"]]
	if (yx < 0) { ndecs <- 9 } else  { ndecs <- 8 }
	yx <- as.numeric( substr( as.character(yx), 1, ndecs) )

	yn <- yx - gdalinfo[["res.y"]] * nr
	if (yn < 0) { ndecs <- 9 } else { ndecs <- 8 }
	yn <- as.numeric( substr( as.character(yn), 1, ndecs) )
	raster <- raster.new(ncols=nc, nrows=nr, xmin=xn, ymin=yn, xmax=xx, ymax=yx, projection="")
	raster <- set.filename(raster, filename)
	raster <- raster.set.datatype(raster, "numeric")
	

	raster@file@driver <- 'gdal' 
		#attr(gdalinfo, "driver")

	raster@file@nbands <- as.integer(gdalinfo[["bands"]])
	band <- as.integer(band)
	if (band > raster@file@nbands) {
		warning("band too high. Set to nbands")
		band <- raster@file@nbands }
	if ( band < 1) { 
		warning("band too low. Set to 1")
		band <- 1 }
	raster@file@band <- as.integer(band)

	raster <- set.projection(raster, attr(gdalinfo, "projection"))
	
	raster@file@gdalhandle[1] <- GDAL.open(filename)
#oblique.x   0  #oblique.y   0 
	raster@data@source <- 'disk'
	return(raster)
}



.readini <- function(filename) {
# readini thanks to Gabor Grothendieck <ggrothendieck_at_gmail.com> 
	f  <- function(x) {
		section <- ""
		if (length(x) == 1) section <<- gsub("[\\[\\]]", "", x)
		if (length(x) <= 1) return()
		return(c(x, section))
	}
	Lines <- readLines(filename)
	ini <-  do.call("rbind", lapply(strsplit(Lines, "="), f)) 
	for (i in 1:length(ini[,1])) {ini[i,1] = toupper(ini[i, 1])}
	return(ini)
}


.raster.create.from.file.binary <- function(filename, band=1) {
    if (!file.exists(filename)) { 
		stop(paste(filename," does not exist")) 
		}
	ini <- .readini(filename)
	byteorder <- .Platform$endian
	nbands <- as.integer(1)
	band <- as.integer(1)
	bandorder <- "BSQ"
	ncellvals <- -9
	projstring <- ""
	for (i in 1:length(ini[,1])) {
		if (ini[i,1] == "MINX") {xn <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "MAXX") {xx <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "MINY") {yn <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "MAXY") {yx <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "ROWS") {nr <- as.integer(ini[i,2])} 
		else if (ini[i,1] == "COLUMNS") {nc <- as.integer(ini[i,2])} 
		else if (ini[i,1] == "MINVALUE") {minval <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "MAXVALUE") {maxval <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "NODATAVALUE") {nodataval <- as.numeric(ini[i,2])} 
		else if (ini[i,1] == "DATATYPE") {inidatatype <- ini[i,2]} 
		else if (ini[i,1] == "BYTEORDER") {byteorder <- ini[i,2]} 
		else if (ini[i,1] == "NBANDS") {nbands <- ini[i,2]} 
		else if (ini[i,1] == "BANDORDER") {bandorder <- ini[i,2]} 
#		else if (ini[i,1] == "NCELLVALS") {ncellvals <- ini[i,2]} 
		else if (ini[i,1] == "PROJECTION") {projstring <- ini[i,2]} 
    }  

    raster <- raster.new(ncols=nc, nrows=nr, xmin=xn, ymin=yn, xmax=xx, ymax=yx, projection=projstring)
	raster <- set.filename(raster, filename)
	raster@file@driver <- "raster"

	raster@data@min <- minval
	raster@data@max <- maxval
	raster@data@haveminmax <- TRUE
	raster@file@nodatavalue <- nodataval
	
	inidatatype <- string.trim(inidatatype)
	if (substr(inidatatype, 1, 3) == "INT") { datatp="integer"
	} else { datatp="numeric" }
	datasz <- as.integer(substr(inidatatype, 4, 4))
	raster <- raster.set.datatype(raster, datatype=datatp, datasize=datasz)
	if ((byteorder == "little") | (byteorder == "big")) { raster@file@byteorder <- byteorder } 	
	raster@file@nbands <- as.integer(nbands)
	raster@file@band <- as.integer(band)
	# check if   0 < band  <= nbands 
	raster@file@bandorder <- bandorder 
	# check if in ("BSQ", "BIP", "BIL")
#	raster@data@ncellvals <- as.integer(ncellvals)

	raster@data@source <- 'disk'
    return(raster)
}


