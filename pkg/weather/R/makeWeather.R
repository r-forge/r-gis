

makeWeather <- function(id, lon, lat, elev, time, d, att=NULL) {
	stopifnot(length(id) == length(lon))
	stopifnot(length(lat) == length(lon))
	stopifnot(length(elev) == length(lon))
	stopifnot(length(time) == nrow(d) / length(lon))
	if (!is.null(att)) {
		stopifnot(length(lon) == nrow(att))
	}
	
	timeIsInterval(time) = TRUE
	pts <- SpatialPoints(cbind(lon, lat), proj4string=CRS("+proj=longlat +datum=WGS84"))
	pts <- SpatialPointsDataFrame(pts, data.frame(id, longitude=lon, latitude=lat, elevation=elev))
	if (!is.null(att)) pts <- cbind(pts, att)
	row.names(pts) <- as.character(id)
	x <- STFDF(pts, time, d)
	as(x, 'WeatherStations')
}

