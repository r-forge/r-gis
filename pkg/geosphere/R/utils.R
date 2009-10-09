# Author: Robert J. Hijmans and Jacob van Etten
# Licence GPL v3


compareDim <- function(p1, p2, p3) {
	if(dim(p1)[1] != dim(p2)[1]) {
		if(dim(p1[1]) > 1 & dim(p2)[1] > 1) {
			stop('p1 and p2 do not have the same number of points and neither has only a single point')
		}
	}
	if (! missing(p3)) {
		if(dim(p1)[1] != dim(p3)[1]) {
			if(dim(p1[1]) > 1 & dim(p3)[1] > 1) {
				stop('p1 and p3 do not have the same number of points and neither has only a single point')
			}
		}
		if(dim(p2)[1] != dim(p3)[1]) {
			if(dim(p2[1]) > 1 & dim(p3)[1] > 1) {
				stop('p2 and p3 do not have the same number of points and neither has only a single point')
			}
		}
	}
	return(invisible(TRUE))
}


pointsToMatrix <- function(p) {
	if (class(p) == 'SpatialPoints' | class(p) == 'SpatialPointsDataFrame') {
		require(sp)
		if (is.projected(p)) {
			stop('data points should not be projected...')  
			# or rather transform them ....?
		}
		p <- coordinates(p)
	}
	if (is.data.frame(p)) {
		p <- as.matrix(p)
	}
	if (is.vector(p)){
		if (length(p) != 2) {
			stop('Wrong length for a vector, should be 2')
		} else {
			p <- matrix(p, ncol=2) 
		}
	} else if (is.matrix(p)) {
		if (length(p[1,]) != 2) {
			stop( 'A points matrix should have 2 columns')
		}
		cn <- colnames(p)
		if (length(cn) == 2) {
			if (toupper(cn[1]) == 'Y' | toupper(cn[2]) == 'X')  {
				stop('Highly suspect column names (x and y reversed?)')
			}
			if (toupper(substr(cn[1],1,3) == 'LAT' | toupper(substr(cn[2],1,3)) == 'LON'))  {
				stop('Highly suspect column names (longitude and latitude reversed?)')
			}
		}		
	} else {
		stop('points should be vectors of length 2, matrices with 2 columns, or a SpatialPoints* object')
	}

	if (min(p[,1]) < -360) { stop('longitude < -360') }
	if (max(p[,1]) > 360) {  stop('longitude > 360')  }
	if (min(p[,2]) < -90) {  stop('latitude < -90')  }
	if (max(p[,2]) > 90) {  stop('latitude > 90')  }
	
	return(p)
}

