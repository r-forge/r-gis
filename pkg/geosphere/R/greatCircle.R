# author Robert Hijmans
# October 2009
# version 0.0
# license LGPL

greatCircle <- function(p1, p2, f=50, r=6378137) {

#Intermediate points on a great circle
# Here we find points (lat,lon) a given fraction of the distance (d) between them. Suppose the starting point is (lat1,lon1) 
# and the final point (lat2,lon2) and we want the point a fraction f along the great circle route. f=0 is point 1. f=1 is point 2. 
#The two points cannot be antipodal ( i.e. lat1+lat2=0 and abs(lon1-lon2)=pi) because then the route is undefined. The intermediate
# latitude and longitude is then given by:
	toRad <- pi / 180 
	d <- distCosine(p1, p2)
	p1 <- pointsToMatrix(p1)
	p2 <- pointsToMatrix(p2)
	if (nrow(p1) > 1 | nrow(p2) > 1) {
		stop('provide single points')
	}

	lon1 <- p1[,1] * toRad
	lat1 <- p1[,2] * toRad
	lon2 <- p2[,1] * toRad
	lat2 <- p2[,2] * toRad

	if (isTRUE(all.equal(lat1+lat2, 0)) & isTRUE(all.equal(abs(lon1-lon2), pi))) {
		stop('antipodal points, infinite number of great circles available')
	}
	
	f <- 0:(f-1) / f
	
    A <- sin(1-f) / sin(d)
    B <- sin(f) / sin(d)
    x <- A*cos(lat1)*cos(lon1) +  B*cos(lat2)*cos(lon2)
	y <- A*cos(lat1)*sin(lon1) +  B*cos(lat2)*sin(lon2)
	z <- A*sin(lat1)           +  B*sin(lat2)
    lat <- atan2(z,sqrt(x^2+y^2))
	lon <- atan2(y,x)
	
	gc <- cbind(lon,lat)/toRad
	return( gc[order(gc[,1]),] )
}

