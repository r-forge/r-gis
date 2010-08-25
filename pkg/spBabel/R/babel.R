# Author: 
# August 2010
# version 1
# license GPL3


	
if (!isGeneric("babel")) {
	setGeneric("babel", function(x, class, ...)
		standardGeneric("babel"))
}	


setMethod('babel', signature(x='ANY', class='character'), 
function(x, class, ...) {
	
	y <- try( as(x, class), silent=TRUE )
	if (class(y) == 'try-error') {
		stop('sorry')
	} else {
		return(y)
	}
}
)
