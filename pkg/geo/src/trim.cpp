using namespace std;
#include "geo.h"

/*
setMethod('trim', signature(x='Raster'), 
function(x, padding=0, values=NA, filename='', ...) {


	filename <- trim(filename)

	nr <- nrow(x)
	nc <- ncol(x)
	nrl <- nr * nlayers(x)
	ncl <- nc * nlayers(x)
	
	cnt <- 0

	for (r in 1:nr) {
		v <- getValues(x, r)
		if (sum(v %in% values) < ncl) {
			break 
		}
		cnt <- cnt + 1
	}
	if ( cnt == nr) { stop('only NA values found') }
	firstrow <- min(max(r-padding, 1), nr)
	
	for (r in nr:firstrow) {
		v <- getValues(x, r)
		if (sum(v %in% values) < ncl) { 
			break 
		}
	}
	lastrow <- max(min(r+padding, nr), 1)
	
	if (lastrow < firstrow) { 
		tmp <- firstrow
		firstrow <- lastrow
		lastrow <- tmp
	}
	
	for (c in 1:nc) {
		v <- getValuesBlock(x, 1 ,nrow(x), c, 1)
		if (sum(v %in% values) < nrl) { break }
	}
	firstcol <- min(max(c-padding, 1), nc) 
	
	for (c in nc:1) {
		v <- getValuesBlock(x, 1 ,nrow(x), c, 1)
		if (sum(v %in% values) < nrl) { break }
	}
	lastcol <- max(min(c+padding, nc), 1)
	
	if (lastcol < firstcol) { 
		tmp <- firstcol
		firstcol <- lastcol
		lastcol <- tmp
	}
	
	xr <- xres(x)
	yr <- yres(x)
	e <- extent(xFromCol(x, firstcol)-0.5*xr, xFromCol(x, lastcol)+0.5*xr, yFromRow(x, lastrow)-0.5*yr, yFromRow(x, firstrow)+0.5*yr)
	
	return( crop(x, e, filename=filename, ...) )
}
)

*/