
if (!isGeneric("crop")) {
	setGeneric("crop", function(x, y, ...)
		standardGeneric("crop"))
}	

if (!isGeneric("crs")) {
	setGeneric("crs", function(x)
		standardGeneric("crs"))
}	

if (!isGeneric("crs<-")) {
	setGeneric("crs<-", function(x, ..., value)
		standardGeneric("crs<-"))
}	


if (!isGeneric("ncell")) {
	setGeneric("ncell", function(x)
		standardGeneric("ncell"))
}	


if (!isGeneric("res")) {
	setGeneric("res", function(x)
		standardGeneric("res"))
}

if (!isGeneric("xres")) {
	setGeneric("xres", function(x)
		standardGeneric("xres"))
}
if (!isGeneric("yres")) {
	setGeneric("yres", function(x)
		standardGeneric("yres"))
}



if ( !isGeneric("rst") ) {
	setGeneric("rst", function(x, ...)
		standardGeneric("rst"))
}


if (!isGeneric("trim")) {
	setGeneric("trim", function(x, ...)
		standardGeneric("trim"))
}	


if (!isGeneric("values")) {
	setGeneric("values", function(x, ...)
		standardGeneric("values"))
}	

if (!isGeneric("values<-")) {
	setGeneric("values<-", function(x, ..., value)
		standardGeneric("values<-"))
}	


if (!isGeneric("setRange")) {
	setGeneric("setRange", function(x)
		standardGeneric("setRange"))
}	





if (!isGeneric('writeRaster')) {
	setGeneric('writeRaster', function(x, filename, ...)
		standardGeneric('writeRaster')) 
}


