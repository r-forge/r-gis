

soilGo <- function(dat, depth=10, props=c("om_r", "claytotal_h", "claytotal_l"), filename='', sp = NULL, raster=NULL, ... ) {

    props <- unique(props)
	if (tolower(substr(dat, nchar(dat)-3, nchar(dat))) == '.mdb') {
		d <- .getSoilGoAccess(dat, props)
	} else {
		d <- .getSoilGoTxt(dat, props)
	}
	
	d <- .processGo(d, depth, props)
	
    if (!is.null(raster)) {
		return(.mergeSoilRaster(raster, d, props, filename))
    } else if (!is.null(sp)) {
		#if (is.logical(sp)) {
		#	bname <- dat
		# check if mdb or tabular
		# get basename 
		# sp = basename / spatial / soil_mu_../shp
		#}
		return(.mergeSoilPol(sp, d, filename))
	} else if (filename!= '') {
		write.table(d, file=filename, row.names=FALSE, col.names=TRUE)
	} else {
        return(d)
    }
}
