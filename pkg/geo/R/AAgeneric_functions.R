
if (!isGeneric("crop")) { setGeneric("crop", function(x, y, ...) standardGeneric("crop")) }	
if (!isGeneric("crs")) { setGeneric("crs", function(x)	standardGeneric("crs")) }	
if (!isGeneric("crs<-")) { setGeneric("crs<-", function(x, ..., value) standardGeneric("crs<-")) }	
if (!isGeneric("ncell")) { setGeneric("ncell", function(x) standardGeneric("ncell")) }	
if (!isGeneric("res")) { setGeneric("res", function(x) standardGeneric("res")) }
if (!isGeneric("xres")) { setGeneric("xres", function(x) standardGeneric("xres")) }
if (!isGeneric("yres")) { setGeneric("yres", function(x) standardGeneric("yres")) }
if (!isGeneric("georst") ) { setGeneric("georst", function(x, ...) standardGeneric("georst")) }
if (!isGeneric("trim")) { setGeneric("trim", function(x, ...) standardGeneric("trim")) }	
if (!isGeneric("values")) { setGeneric("values", function(x, ...) standardGeneric("values")) }	
if (!isGeneric("values<-")) { setGeneric("values<-", function(x, ..., value) standardGeneric("values<-"))}	
if (!isGeneric("setRange")) {setGeneric("setRange", function(x) standardGeneric("setRange"))}	
if (!isGeneric('writeRaster')) {setGeneric('writeRaster', function(x, filename, ...) standardGeneric('writeRaster'))}
if (!isGeneric("yFromRow")) { setGeneric("yFromRow", function(object) standardGeneric("yFromRow")) }              
if (!isGeneric("xFromCol")) { setGeneric("xFromCol", function(object) standardGeneric("xFromCol")) }                  
if (!isGeneric("colFromX")) { setGeneric("colFromX", function(object) standardGeneric("colFromX")) }                  
if (!isGeneric("rowFromY")) { setGeneric("rowFromY", function(object) standardGeneric("rowFromY")) }                  
if (!isGeneric("cellFromXY")) { setGeneric("cellFromXY", function(object) standardGeneric("cellFromXY")) }
if (!isGeneric("cellFromRowCol")) { setGeneric("cellFromRowCol", function(object) standardGeneric("cellFromRowCol")) }
if (!isGeneric("xyFromCell")) { setGeneric("xyFromCell", function(object) standardGeneric("xyFromCell")) } 
if (!isGeneric("yFromCell")) { setGeneric("yFromCell", function(object) standardGeneric("yFromCell")) }             
if (!isGeneric("xFromCell")) { setGeneric("xFromCell", function(object) standardGeneric("xFromCell")) }               
if (!isGeneric("rowcolFromCell")) { setGeneric("rowcolFromCell", function(object) standardGeneric("rowcolFromCell")) }
if (!isGeneric("rowFromCell")) { setGeneric("rowFromCell", function(object) standardGeneric("rowFromCell")) } 
if (!isGeneric("colFromCell")) { setGeneric("colFromCell", function(object) standardGeneric("colFromCell")) }

# (!isGeneric("#")) { setGeneric("#", function(object) standardGeneric("#")) }
