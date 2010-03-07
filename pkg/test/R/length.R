# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3



setMethod('length', signature(x='GeoVector'), 
function(x) {
	return(length(unique(x@id[,1])))
}
)
