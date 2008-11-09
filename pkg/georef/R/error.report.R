
error.report <- function(xyxy,threshold) 
{	
	error.dist <- function(pp,a){
		x1 <- pp[1]
		y1 <- pp[2]
		x2 <- pp[3]
		y2 <- pp[4]

		if(any(is.na(c(x1, y1, x2, y2)))){
			out <- NA
		} else {	
			difference <- distance.greatcircle(c(x1, y1), c(x2, y2)) 
			xy.exchange <- distance.greatcircle(c(y1, x1), c(x2, y2)) 
			signch.lat <- distance.greatcircle(c(x1, -y1), c(x2, y2)) 
			signch.lon <- distance.greatcircle(c(-x1, y1), c(x2, y2))
			signch.latlon <- distance.greatcircle(c(-y1), c(-x1, x2, y2))
			
			xy.signch.lat <- distance.greatcircle(c(y1, -x1), c(x2, y2))
			xy.signch.lon <- distance.greatcircle(c(-y1, x1), c(x2, y2))
			xy.signch.latlon <- distance.greatcircle(c(-y1, -x1), c(x2, y2))
			
			wrong.lon <- distance.greatcircle(c(0, y1), c(a, y2))
			wrong.lat <- distance.greatcircle(c(x1, 0), c(x2, a))
			
			xy.wrong.lon <- distance.greatcircle(c(y1, 0), c(x2, a))
			xy.wrong.lat <- distance.greatcircle(c(0, x1), c(a, y2))
			signch.lat.wrong.lon <- distance.greatcircle(c(0, -y1), c(a, y2))
			signch.lon.wrong.lat <- distance.greatcircle(c(-x1, 0), c(x2, a))
			
			signch.lat.xy.wrong.lon <- distance.greatcircle(c(-y1, 0), c(x2, a))
			signch.lon.xy.wrong.lat <- distance.greatcircle(c(0, -x1), c(a, y2))
			out <- c(difference, xy.exchange, signch.lat, signch.lon, signch.latlon, xy.signch.lat, xy.signch.lon, xy.signch.latlon, wrong.lon, wrong.lat, xy.wrong.lon, xy.wrong.lat, signch.lat.wrong.lon, signch.lon.wrong.lat, signch.lat.xy.wrong.lon, signch.lon.xy.wrong.lat)
			return(out)
		}
	}
	dist <- matrix(ncol=16,nrow=length(xyxy[,1]))
	for(i in 1: length(xyxy[,1]))
	{
		dist[i,] <- error.dist(xyxy[i,],threshold)
	}
	errorNames <- c("Imprecision","Lonlat swap","Sign latitude","Sign longitude","Sign latitude and longitude","Lonlat swap and sign latitude","Lonlat swap and sign longitude","Lonlat swap and both signs","Wrong longitude","Wrong latitude","Lonlat swap and wrong longitude","Lonlat swap and wrong latitude","Sign latitude and wrong longitude","Sign longitude and wrong latitude","Sign latitude, lonlat swap and wrong longitude","Sign longitude, lonlat swap and wrong latitude")
	classify <- function(x)
	{
		if (any(is.na(x))){out <- NA}
		else {out <- errorNames[min(which(x==min(x)))]}
		return(out)
	}
	errorCategory <- apply(dist,1,classify)
	
	classify2 <- function(x)
	{
		if (any(is.na(x))){out <- NA}
		else {out <- min(which(x==min(x)))}
		return(out)
	}
	index <- apply(dist,1,classify2)
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