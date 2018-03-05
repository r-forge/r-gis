

if (!isGeneric("spatPolygons") ) { setGeneric("spatPolygons", function(x, ...) standardGeneric("spatPolygons")) }

setMethod("spatPolygons", signature(x='missing'), 
	function(...) {
		p <- methods::new('SpatPolygons')
		p@ptr <- SpatRaster$new()
		return(p)
	}
)
