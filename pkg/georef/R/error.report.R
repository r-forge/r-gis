
error.report <- function(xyxy,threshold) 
{	
	distn <- matrix(ncol=16,nrow=length(xyxy[,1]))
	for(i in 1: length(xyxy[,1]))
	{
		distn[i,] <- error.dist(xyxy[i,],threshold)
	}
	errorNames <- c("Imprecision","Lonlat swap","Sign latitude","Sign longitude","Sign latitude and longitude","Lonlat swap and sign latitude","Lonlat swap and sign longitude","Lonlat swap and both signs","Wrong longitude","Wrong latitude","Lonlat swap and wrong longitude","Lonlat swap and wrong latitude","Sign latitude and wrong longitude","Sign longitude and wrong latitude","Sign latitude, lonlat swap and wrong longitude","Sign longitude, lonlat swap and wrong latitude")
	classify <- function(x)
	{
		if (any(is.na(x))){out <- NA}
		else {out <- errorNames[min(which(x==min(x)))]}
		return(out)
	}
	errorCategory <- apply(distn,1,classify)
	
	classify2 <- function(x)
	{
		if (any(is.na(x))){out <- NA}
		else {out <- min(which(x==min(x)))}
		return(out)
	}
	index <- apply(distn,1,classify2)
	index <- cbind(c(1:length(xyxy[,1])),index)
	
	dist2 <- matrix(ncol=16,nrow=length(xyxy[,1]))
	for(i in 1: length(xyxy[,1]))
	{
		dist2[i,] <- error.dist(xyxy[i,],0)
	}
	
	errorDistance <- dist2[index]/1000
	result <- cbind(errorCategory,errorDistance)
	return(result)
}

error.dist <- function(pp,a){
		x1 <- pp[1]
		y1 <- pp[2]
		x2 <- pp[3]
		y2 <- pp[4]

		if(any(is.na(c(x1, y1, x2, y2)))){
			out <- NA
		} else {	
			difference <- distanceGreatcircle(c(x1, y1), c(x2, y2)) 
			xy.exchange <- distanceGreatcircle(c(y1, x1), c(x2, y2)) 
			signch.lat <- distanceGreatcircle(c(x1, -y1), c(x2, y2)) 
			signch.lon <- distanceGreatcircle(c(-x1, y1), c(x2, y2))
			signch.latlon <- distanceGreatcircle(c(-y1, -x1), c(x2, y2))
			
			xy.signch.lat <- distanceGreatcircle(c(y1, -x1), c(x2, y2))
			xy.signch.lon <- distanceGreatcircle(c(-y1, x1), c(x2, y2))
			xy.signch.latlon <- distanceGreatcircle(c(-y1, -x1), c(x2, y2))
			
			wrong.lon <- distanceGreatcircle(c(0, y1), c(a, y2))
			wrong.lat <- distanceGreatcircle(c(x1, 0), c(x2, a))
			
			xy.wrong.lon <- distanceGreatcircle(c(y1, 0), c(x2, a))
			xy.wrong.lat <- distanceGreatcircle(c(0, x1), c(a, y2))
			signch.lat.wrong.lon <- distanceGreatcircle(c(0, -y1), c(a, y2))
			signch.lon.wrong.lat <- distanceGreatcircle(c(-x1, 0), c(x2, a))
			
			signch.lat.xy.wrong.lon <- distanceGreatcircle(c(-y1, 0), c(x2, a))
			signch.lon.xy.wrong.lat <- distanceGreatcircle(c(0, -x1), c(a, y2))
			out <- c(difference, xy.exchange, signch.lat, signch.lon, signch.latlon, xy.signch.lat, xy.signch.lon, xy.signch.latlon, wrong.lon, wrong.lat, xy.wrong.lon, xy.wrong.lat, signch.lat.wrong.lon, signch.lon.wrong.lat, signch.lat.xy.wrong.lon, signch.lon.xy.wrong.lat)
			return(out)
		}
}

errorGenerate <- function(pp){
		x1 <- pp[1]
		y1 <- pp[2]

		if(any(is.na(c(x1, y1)))){
			out <- NA
		} else {	
			no.change <- c(x1, y1)
			xy.exchange <- c(y1, x1)
			signch.lat <- c(x1, -y1)
			signch.lon <- c(-x1, y1)
			signch.latlon <- c(-x1, -y1)
			
			xy.signch.lat <- c(y1, -x1)
			xy.signch.lon <- c(-y1, x1)
			xy.signch.latlon <- c(-y1, -x1)
			
			out <- rbind(no.change, xy.exchange, signch.lat, signch.lon, signch.latlon, xy.signch.lat, xy.signch.lon, xy.signch.latlon)
			rownames(out) <- c("no.change", "xy.exchange", "signch.lat", "signch.lon", "signch.latlon", "xy.signch.lat", "xy.signch.lon", "xy.signch.latlon")
			return(out)
		}
}

	
		