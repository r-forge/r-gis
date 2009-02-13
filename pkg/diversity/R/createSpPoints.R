

db2SpPoints <- function(database, table, xfield='lat', yfield='lon', includeNULL=FALSE, projection="+proj=longlat +datum=WGS84") {
	if  (tolower(fileExtension(database)) == '.mdb') {
		db <- odbcConnectAccess(database)
	} else { 
		db <- odbcConnect(database) 
	}
	
	if (includeNULL) {
		query <- paste("SELECT * FROM",table)
	} else {
		query <- paste("SELECT * FROM", table, "WHERE", xfield, "IS NOT NULL AND", yfield, "IS NOT NULL")
	}
	data <- sqlQuery(db, query)
	odbcClose(db)
	sp <- createSpPoints(data, xfield, yfield, projection=projection)
	return(sp)
}


createSpPoints <- function(dataframe, x='LON', y='LAT', projection="+proj=longlat +datum=WGS84") {
	coords <- cbind(dataframe[x], dataframe[y])
	row.names(coords) <- 1:nrow(coords)
	proj4 <- newCRS(projection)
	spatpoints <- SpatialPointsDataFrame(coords=coords, data=dataframe, proj4string=proj4)
	return(spatpoints)
}
