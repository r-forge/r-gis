# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,7
# Licence GPL v3

distance.euclidean.xy <- function (point1, point2) {
	if (length(point1) == 2) {
		x1 <- point1[1]
		y1 <- point1[2]
	} else {
		x1 <- point1[,1]
		y1 <- point1[,2]
	}
	if (length(point2) == 2) {
		x2 <- point2[1]
		y2 <- point2[2]
	} else {
		x2 <- point2[,1]
		y2 <- point2[,2]
	}
	d <- sqrt((x1 - x2)^2 + (y1 - y2)^2)
	return(d)
}

distance.greatcircle.xy <- function (point1, point2, r=6378137) {
	if (length(point1) == 2) {
		x1 <- point1[1]
		y1 <- point1[2]
	} else {
		x1 <- point1[,1]
		y1 <- point1[,2]
	}
	if (length(point2) == 2) {
		x2 <- point2[1]
		y2 <- point2[2]
	} else {
		x2 <- point2[,1]
		y2 <- point2[,2]
	}
	y1 <- y1 * pi / 180;
	x1 <- y2 * pi / 180;
	y2 <- y2 * pi / 180;
	x2 <- x2 * pi / 180;
	cosd <- sin(y1)*sin(y2) +cos(y1)*cos(y2)*cos(x1-x2);
	d <- r * acos(cosd);
	return(d)
}
