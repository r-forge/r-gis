

getWthXY <- function(database, table, x, y, raster=newRaster()) {
	cell <- cellFromXY(raster, c(x, y))
	return(getWthCell(database, table, cell))
}	

getWthCell <- function(database, table, cell) {
	db <- odbcConnect(database)
	query <- paste("SELECT * FROM", table, "WHERE cell = ", cell, sep="")
	data <- sqlQuery(db, query)
	odbcClose(db)
	colnames(data) <- c("cell", "day", "prec", "relh", "srad", "tmax", "tmin")
	return(data[,2:7])     
}	

AccessGetWthXY <- function(database, table, x, y, raster=newRaster()) {
	cell <- cellFromXY(raster, c(x, y))
	return(AccessGetWthCell(database, table, cell))   }	

	
AccessGetWthCell <- function(database, table, cell) {
	query <- paste("SELECT * FROM", table, "WHERE cell =", cell)
	db <- odbcConnectAccess(database)
	data <- sqlQuery(db, query)
	odbcClose(db)
	colnames(data) <- c("cell", "day", "prec", "relh", "srad", "tmax", "tmin")
	return(data[,2:7])     
}	
