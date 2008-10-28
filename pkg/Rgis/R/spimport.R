


create.spPointsDF <- function(dataframe, x='LON', y='LAT', projection="+proj=longlat +datum=WGS84") {
	coords <- cbind(dataframe[x], dataframe[y])
	row.names(coords) <- 1:nrow(coords)
	proj4 <- create.CRS(projection)
	spatpoints <- SpatialPointsDataFrame(coords=coords, data=dataframe, proj4string=proj4)
	return(spatpoints)
}
