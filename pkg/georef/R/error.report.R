error.report <- function(xyxy,a) 
{	
	error.dist <- function(x){
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
		
			zero.lon <- distance.greatcircle.xy(0, x[2], a, x[4])
			zero.lat <- distance.greatcircle.xy(x[1], 0, x[3], a)
		
			xy.zero.lon <- distance.greatcircle.xy(x[2], 0, x[3], a)
			xy.zero.lat <- distance.greatcircle.xy(0, x[1], a, x[4])
			signch.lat.zero.lon <- distance.greatcircle.xy(0, -x[2], a, x[4])
			signch.lon.zero.lat <- distance.greatcircle.xy(-x[1], 0, x[3], a)
		
			signch.lat.xy.zero.lon <- distance.greatcircle.xy(-x[2], 0, x[3], a)
			signch.lon.xy.zero.lat <- distance.greatcircle.xy(0, -x[1], a, x[4])
			out <- c(difference,xy.exchange,signch.lat,signch.lon,signch.latlon,xy.signch.lat,xy.signch.lon,xy.signch.latlon,zero.lon,zero.lat,xy.zero.lon,xy.zero.lat,signch.lat.zero.lon,signch.lon.zero.lat,signch.lat.xy.zero.lon,signch.lon.xy.zero.lat)
			return(out)
		}
	}
	dist <- matrix(ncol=16,nrow=length(xyxy[,1]))
	for(i in 1: length(xyxy[,1]))
	{
		dist[i,] <- error.dist(xyxy[i,])
	}
	errorNames <- c("difference","xy.exchange","signch.lat","signch.lon","signch.latlon","xy.signch.lat","xy.signch.lon","xy.signch.latlon","zero.lon","zero.lat","xy.zero.lon","xy.zero.lat","signch.lat.zero.lon","signch.lon.zero.lat","signch.lat.xy.zero.lon","signch.lon.xy.zero.lat")
	classify <- function(x)
	{
		if (any(is.na(x))){out <- NA}
		else {out <- errorNames[min(which(x==min(x)))]}
		return(out)
	}
	errorCategory <- apply(dist,1,classify)
	errorDistance <- apply(dist,1,function(x)min(x)/1000)
	result <- cbind(errorCategory,errorDistance)
}