doy.from.date <- function(date) {
# adate is string like "2007-7-10"
	as.numeric(format(as.Date(date), "%j"))
}


date.from.doy <- function(doy, year) {
	as.Date(doy, origin=paste(year, "-01-01", sep=''))
}

