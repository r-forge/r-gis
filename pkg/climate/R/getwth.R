

getWthXY <- function(x, y, syear, sdoy, eyear, edoy, database='NASAclim') {
	g <- newRaster()
	cell <- cellFromXY(g, c(x, y))
	return(getWthCell(cell, syear, sdoy, eyear, edoy,database))
}	

getWthCell <- function(cell, syear, sdoy, eyear, edoy, database='NASAclim') {
#    years <- c(1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005) 
	db <- odbcConnect(database)
	sdate <- date.from.doy(sdoy, syear)
	edate <- date.from.doy(edoy, eyear)
	query <- paste("SELECT * FROM nasa.daily WHERE cell = ", cell, " AND ndate > '", sdate, "' AND ndate < '", edate, "'", sep="")
	data <- sqlQuery(db, query)
	odbcClose(db)
	return(data)
}	
