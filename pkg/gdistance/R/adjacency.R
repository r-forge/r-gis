adjacency <- function(raster, outer.meridian.connect=FALSE, diagonal=FALSE)
{
	if (diagonal==FALSE) {result <- .adjacency.straight(raster, outer.meridian.connect)}
	else {result <- cbind (.adjacency.straight(raster, outer.meridian.connect),.adjacency.diag(raster, outer.meridian.connect))}
	return(result)
}

