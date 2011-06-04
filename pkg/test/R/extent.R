# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febraruy 2010
# Version 0.0
# Licence GPL v3

if (!isGeneric("extent")) {
	setGeneric("extent", function(x, ...)
		standardGeneric("extent"))
}	

setMethod('extent', signature(x='GeoVector'), 
	function(x) {
		extent(as.vector(range(x@xy)))
	}
)

