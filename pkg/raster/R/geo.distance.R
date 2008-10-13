# Author: Robert J. Hijmans, r.hijmans@gmail.com
# International Rice Research Institute
# Date :  June 2008
# Version 0,1
# Licence GPL v3

distance.euclidean.xy <- function (x1, y1, x2, y2) {
  d <- sqrt((x1 - x2)^2 + (y1 - y2)^2)
  return(d)
}

distance.greatcircle.xy <- function (x1, y1, x2, y2, r=6378137) {
  y1 <- y1 * pi / 180;
  x1 <- x1 * pi / 180;
  y2 <- y2 * pi / 180;
  x2 <- x2 * pi / 180;
  cosd <- sin(y1)*sin(y2) +cos(y1)*cos(y2)*cos(x1-x2);
  d <- r * acos(cosd);
  return(d)
}
