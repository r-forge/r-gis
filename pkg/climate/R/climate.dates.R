doy.from.date <- function(date) {
# adate is string like "2007-7-10"
	as.numeric(format(as.Date(date), "%j"))
}

is.leapyear <- function(year) {
	year <- round(year)
    if(((year %% 100 !=0) & (year %%4 ==0)) | (year %% 400==0) )
    { return(TRUE) 
	} else { return(FALSE) }
}

days.in.year <- function(year) {
	year <- round(year)
	if (is.leapyear(year)) { return(366)
	} else { return(365) }
}

date.from.doy <- function(doy, year) {
	year <- round(year)
	doy <- round(doy)
	if (doy < 1) { 
		year <- year-1
		doy <- days.in.year(year) + doy
	}
	else if (doy > days.in.year(year)) { 
		doy <- doy - days.in.year(year)
		year <- year+1
	}
	if (doy < 1) { stop('cannot understand value for doy') }
	if (doy > days.in.year(year)) { stop('cannot understand value for doy') }
	
	as.Date(doy, origin=paste(year, "-01-01", sep=''))
}
