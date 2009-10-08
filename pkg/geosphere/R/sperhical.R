# author of original JavaScript code: Chris Vennes
# (c) 2002-2009 Chris Veness
# http://www.movable-type.co.uk/scripts/latlong.html
# Liceence: LGPL, without any warranty express or implied

# Port to R by Robert Hijmans
# October 2009
# version 0.0



midPoint <- function(p1, p2) {
#* calculate midpoint of great circle line between p1 & p2.
#*   see http:#//mathforum.org/library/drmath/view/51822.html for derivation
# source http://www.movable-type.co.uk/scripts/latlong.html
# (c) 2002-2009 Chris Veness

  p1 <- pointsToMatrix(p1)
  p2 <- pointsToMatrix(p2)
  lon1 <- p1[,1]
  lat1 <- p1[,2]
  lon2 <- p2[,1]
  lat2 <- p2[,2]

  toRad <- pi / 180 
  toDeg <- 1 / toRad
  lat1 <- lat1 * toRad 
  lat2 <- lat2 * toRad
  dLon <- (lon2-lon1) * toRad

  Bx <- cos(lat2) * cos(dLon)
  By <- cos(lat2) * sin(dLon)

  lat3 <- atan2(sin(lat1)+sin(lat2), sqrt((cos(lat1)+Bx)*(cos(lat1)+Bx) + By*By ) )
  lon3 <- lon1 * toRad + atan2(By, cos(lat1) + Bx)

  if (is.nan(lat3) || is.nan(lon3)) return(NULL)
  res <- cbind(lon3, lat3)*toDeg
  colnames(res) <- c('lon', 'lat')
  return(res)
  
}



destPoint <- function(p, brng, d, R=6378137) {
#* calculate destination point given start point, initial bearing (deg) and distance (km)
#*   see http:#//williams.best.vwh.net/avform.htm#LL
# source http://www.movable-type.co.uk/scripts/latlong.html
# (c) 2002-2009 Chris Veness

  p <- pointsToMatrix(p)
  lon <- p[,1]
  lat <- p[,2]

  toRad <- pi / 180 
  toDeg <- 1 / toRad
  lat1 <- lat * toRad
  lon1 <- lon * toRad
  brng <- brng * toRad

  lat2 <- asin( sin(lat1)*cos(d/R) + cos(lat1)*sin(d/R)*cos(brng) )
  lon2 <- lon1 + atan2(sin(brng)*sin(d/R)*cos(lat1), cos(d/R)-sin(lat1)*sin(lat2))
  lon2 <- (lon2+pi)%%(2*pi) - pi  #// normalise to -180...+180

  if (is.nan(lat2) || is.nan(lon2)) return(NULL)
  res <- cbind(lon2, lat2) * toDeg
  colnames(res) <- c('lon', 'lat')
  return(res)
}



polePoint <- function(lat, brng) {
# ‘Clairaut’s formula’ : the maximum latitude of a great circle path, given a bearing and latitude on the great circle
# source http://www.movable-type.co.uk/scripts/latlong.html
# (c) 2002-2009 Chris Veness
	toRad <- pi / 180 
	
	latMax <- acos(abs(sin(brng * toRad) * cos(lat * toRad)))
	latMax <- latMax / toRad 
	return(latMax)
}


