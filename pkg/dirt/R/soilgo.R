

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
	
		if (is.logical(sp)) {
			dat <- gsub('\\\\', '/', dat)
			tst <- tolower(substr(dat, nchar(dat)-6, nchar(dat)))
			if ( tst %in% c('abular/') ) {
				shp <- substr(dat, 1, nchar(dat)-8)
			} else if (tst == 'tabular') {
				shp <- substr(dat, 1, nchar(dat)-7)			
			} else {
				stop('cannot find shapefile')
			}
			sp <- unlist(strsplit(dat, '/'))
			sp <- sp[length(sp)-1]
			sp <- unlist(strsplit(sp, '_'))
			sp <- paste(shp, 'spatial/', sp[1], 'mu_a_', sp[2], '.shp', sep='')
			
		}
		return(.mergeSoilPol(sp, d, filename))
		
	} else if (filename!= '') {
	
		write.table(d, file=filename, row.names=FALSE, col.names=TRUE)
		
	} else {
	
        return(d)
		
    }
}
