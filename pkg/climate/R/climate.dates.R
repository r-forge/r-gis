
yearFromDate <- function(date) {
	as.numeric(format(as.Date(date), "%Y"))
}

isLeapYear <- function(year) {
	year <- round(year)
    if(((year %% 100 !=0) & (year %%4 ==0)) | (year %% 400==0) )
    { return(TRUE) 
	} else { return(FALSE) }
}

daysInYear <- function(year) {
	year <- round(year)
	if (isLeapYear(year)) { return(366)
	} else { return(365) }
}

daysOfYear <- function(year) {
	firstday <- as.Date(paste(year, "-1-1", sep=""))
	lastday <- as.Date(paste(year, "-12-31", sep=""))
	d <- seq(firstday, to=lastday, by=1)
	return(d)
}	


doyFromDate <- function(date) {
# adate is string like "2007-7-10"
	as.numeric(format(as.Date(date), "%j"))
}


dateFromDoy <- function(doy, year) {
	year <- round(year)
	doy <- round(doy)
	diy <- daysInYear(year)
	if (doy < 1) { 
		year <- year-1
		doy <- diy + doy
	}
	else if (doy > diy) { 
		doy <- doy - diy
		year <- year+1
	}
	if (doy < 1) { stop('cannot understand value for doy') }
	if (doy > diy) { stop('cannot understand value for doy') }
	
	as.Date(doy, origin=paste(year, "-01-01", sep=''))
}
