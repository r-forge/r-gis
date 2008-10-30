error.report <- function(xyxy,threshold) 
{	
	error.dist <- function(x,a){
		if(any(is.na(c(x[1], x[2], x[3], x[4])))){out <- NA}
		else{
			difference <- distance.greatcircle.xy(x[1], x[2], x[3], x[4]) 
			xy.exchange <- distance.greatcircle.xy(x[2], x[1], x[3], x[4]) 
			signch.lat <- distance.greatcircle.xy(x[1], -x[2], x[3], x[4]) 
			signch.lon <- distance.greatcircle.xy(-x[1], x[2], x[3], x[4]) 
			signch.latlon <- distance.greatcircle.xy(-x[2], -x[1], x[3], x[4])
			
			xy.signch.lat <- distance.greatcircle.xy(x[2], -x[1], x[3], x[4])
			xy.signch.lon <- distance.greatcircle.xy(-x[2], x[1], x[3], x[4])
			xy.signch.latlon <- distance.greatcircle.xy(-x[2], -x[1], x[3], x[4])
			
			wrong.lon <- distance.greatcircle.xy(0, x[2], a, x[4])
			wrong.lat <- distance.greatcircle.xy(x[1], 0, x[3], a)
			
			xy.wrong.lon <- distance.greatcircle.xy(x[2], 0, x[3], a)
			xy.wrong.lat <- distance.greatcircle.xy(0, x[1], a, x[4])
			signch.lat.wrong.lon <- distance.greatcircle.xy(0, -x[2], a, x[4])
			signch.lon.wrong.lat <- distance.greatcircle.xy(-x[1], 0, x[3], a)
			
			signch.lat.xy.wrong.lon <- distance.greatcircle.xy(-x[2], 0, x[3], a)
			signch.lon.xy.wrong.lat <- distance.greatcircle.xy(0, -x[1], a, x[4])
			out <- c(difference,xy.exchange,signch.lat,signch.lon,signch.latlon,xy.signch.lat,xy.signch.lon,xy.signch.latlon,wrong.lon,wrong.lat,xy.wrong.lon,xy.wrong.lat,signch.lat.wrong.lon,signch.lon.wrong.lat,signch.lat.xy.wrong.lon,signch.lon.xy.wrong.lat)
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