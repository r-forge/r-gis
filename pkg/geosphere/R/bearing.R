# author of original JavaScript code: Chris Vennes
# (c) 2002-2009 Chris Veness
# http://www.movable-type.co.uk/scripts/latlong.html
# Liceence: LGPL, without any warranty express or implied

# Port to R by Robert Hijmans
# October 2009
# version 0.0


bearing <- function(p1, p2) {
#* calculate (initial) bearing between two points
#*   see http:#//williams.best.vwh.net/avform.htm#Crs
# source http://www.movable-type.co.uk/scripts/latlong.html
# (c) 2002-2009 Chris Veness

	p1 <- pointsToMatrix(p1)
	p2 <- pointsToMatrix(p2)
  
    compareDim(p1, p2)
  
	lon1 <- p1[,1]
	lat1 <- p1[,2]
	lon2 <- p2[,1]
	lat2 <- p2[,2]
	toRad <- pi / 180 
	lat1 <- lat1 * toRad
	lat2 <- lat2 * toRad
	dLon <- (lon2-lon1) * toRad
	y <- sin(dLon) * cos(lat2)
	x <- cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon)
	b <- atan2(y, x)
	b <- (b+360) %% 360
	return(b)
}


