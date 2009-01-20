
vector.read <- function(filename) {
	fn <- fileName(filename) 
	fn <- setFileExtension(fn, '')
	vec <- readOGR(filename, fn) 
	if (class(vec) == "SpatialPointsDataFrame") {
		xy <- coordinates(vec)
		colnames(xy)[1] <- "point_x"
		colnames(xy)[2] <- "point_y"
		result <- cbind(xy, vec@data)
	#	attdata <- as.matrix(vec[1:length(vec[1,])]
	} else if (class(vec) == "SpatialLinesDataFrame") { 
		result <- NA
	} else if (class(vec) == "SpatialPolygonsDataFrame") { 
		result <- NA
	} else { result <- NA }
	return(result  )
}

