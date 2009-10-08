# You are welcome to re-use these scripts [under a LGPL license, without any warranty express or implied] 
# provided solely that you retain my copyright notice and a link to this page.
# If you would like to show your appreciation, I would most gratefully accept donations.
# If you have any queries or find any problems, contact me at ku.oc.epyt-elbavom@oeg-stpircs.
# (c) 2002-2009 Chris Veness

# Port to R by Robert Hijmans


bearing <- function(p1, p2) {
#* calculate (initial) bearing between two points
#*   see http:#//williams.best.vwh.net/avform.htm#Crs
  p1 <- pointsToMatrix(p1)
  p2 <- pointsToMatrix(p2)
  lon1 <- p1[,1]
  lat1 <- p1[,2]
  lon2 <- p2[,1]
  lat2 <- p2[,2]
  toRad <- 180 / pi
  lat1 <- lat1 * toRad
  lat2 <- lat2 * toRad
  dLon <- (lon2-lon1) * toRad
  y <- sin(dLon) * cos(lat2)
  x <- cos(lat1)*sin(lat2) - sin(lat1)*cos(lat2)*cos(dLon)
  b <- atan2(y, x)
  b <- (b+360) %% 360
  return(b)
}



midPoint <- function(p1, p2) {
#* calculate midpoint of great circle line between p1 & p2.
#*   see http:#//mathforum.org/library/drmath/view/51822.html for derivation
  p1 <- pointsToMatrix(p1)
  p2 <- pointsToMatrix(p2)
  lon1 <- p1[,1]
  lat1 <- p1[,2]
  lon2 <- p2[,1]
  lat2 <- p2[,2]

  toRad <- 180 / pi
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
  p <- pointsToMatrix(p)
  lon <- p[,1]
  lat <- p[,2]

  toRad <- 180 / pi
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


finalBrng <- function(p, brng, d, R=6378137) {
#* calculate final bearing arriving at destination point given start point, initial bearing and distance
  p <- pointsToMatrix(p)
  lon <- p[,1]
  lat <- p[,2]

  pdest <- destPoint(p, brng, d=d, R=R)
  #// get reverse bearing point 2 to point 1
  reverse <- bearing(pdest, p)
  #// & reverse it by adding 180°
  brng <- (reverse + 180) %% 360
  return(brng)
}


distRhumb <- function(p1, p2, R=6378137) {
#* calculate distance, bearing, destination point on rhumb line
#*   see http:#//williams.best.vwh.net/avform.htm#Rhumb
  p1 <- pointsToMatrix(p1)
  p2 <- pointsToMatrix(p2)
  lon1 <- p1[,1]
  lat1 <- p1[,2]
  lon2 <- p2[,1]
  lat2 <- p2[,2]

  toRad <- 180 / pi
  dLat <- (lat2-lat1) * toRad
  dLon <- abs(lon2-lon1) * toRad
  dPhi <- log(tan(lat2 * toRad/2+pi/4)/tan(lat1 * toRad/2+pi/4))
  q <- if(abs(dLat) > 1e-10) { dLat/dPhi } else { cos(lat1 * toRad) }
  #// if dLon over 180° take shorter rhumb across 180° meridian:
  if (dLon > pi) { dLon <- 2*pi - dLon  }
  d <- sqrt(dLat*dLat + q*q*dLon*dLon) 
  return(d * R)
}


brngRhumb <- function(p1, p2) {
  p1 <- pointsToMatrix(p1)
  p2 <- pointsToMatrix(p2)
  lon1 <- p1[,1]
  lat1 <- p1[,2]
  lon2 <- p2[,1]
  lat2 <- p2[,2]

  toRad <- 180 / pi
  dLon <- (lon2-lon1) * toRad
  dPhi <- log(tan(lat2 * toRad/2+pi/4)/tan(lat1 * toRad/2+pi/4))
  if (abs(dLon) > pi) {
	if (dLon>0) {
		dLon <- -(2*pi-dLon)
	} else {
		dLon <- (2*pi+dLon)
	}
  }
  b <- atan2(dLon, dPhi)
  b <- (b+360) %% 360
  return(b)
}


destPointRhumb <- function(p, brng, dist, R=6378137) {
  p <- pointsToMatrix(p)
  lon <- p[,1]
  lat <- p[,2]

  toRad <- 180 / pi
  toDeg <- 1 / toRad

  d <- dist/R  #// d <- angular distance covered on earth's surface
  lat1 <- lat * toRad
  lon1 <- lon * toRad
  brng <- brng * toRad

  lat2 <- lat1 + d*cos(brng)
  dLat <- lat2-lat1
  dPhi <- log(tan(lat2/2+pi/4)/tan(lat1/2+pi/4))
  if(abs(dLat) > 1e-10) { q <- dLat/dPhi } else { q <- cos(lat1) }
  dLon <- d*sin(brng)/q
  #// check for some daft bugger going past the pole
  if (abs(lat2) > pi/2) {
	if (lat2 >0) {
		lat2 <- pi-lat2
	} else {
		lat2 <- -(pi-lat2)
	}
  }
  
  lon2 <- (lon1+dLon+pi)%%(2*pi - pi)
 
  if (is.nan(lat2) || is.nan(lon2)) return(NULL)
  res <- cbind(lon2, lat2) * toDeg
  colnames(res) <- c('lon', 'lat')
  return(res)
}

