

getWthXY <- function(x, y, syear, sdoy, eyear, edoy, database='NASAclim') {
	g <- newRaster()
	cell <- cellFromXY(g, c(x, y))
	return(getWthCell(cell, syear, sdoy, eyear, edoy,database))
}	

getWthCell <- function(cell, syear, sdoy, eyear, edoy, database='NASAclim') {
#    years <- c(1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005) 
	db <- odbcConnect(database)
	sdate <- dateFromDoy(sdoy, syear)
	edate <- dateFromDoy(edoy, eyear)
	query <- paste("SELECT * FROM nasa.daily WHERE cell = ", cell, " AND ndate > '", sdate, "' AND ndate < '", edate, "'", sep="")
	data <- sqlQuery(db, query)
	odbcClose(db)
	return(data)
}	

###############################################
# functions, do not change.
AccessGetWthXY <- function(database, table, x, y) {
	g <- newRaster(xmn=42, xmx=51, ymn=-26, ymx=-11, ncols=36, nrows=60)
	cell <- cellFromXY(g, c(x, y))
	return(getWthCell(database, table, cell))   }	

AccessGetWthCell <- function(database, table, cell) {
	db <- odbcConnectAccess(database)
	query <- paste("SELECT * FROM", table, "WHERE cell =", cell)
	data <- sqlQuery(db, query)
	odbcClose(db)
	return(data)     }	
###############################################	
