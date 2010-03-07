# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3



# adapted from code by Carson Farmer
# http://www.carsonfarmer.com/?p=455
voronoi <- function(xy, sp=TRUE, dataframe=FALSE){
	if (!require(deldir)) { stop('you need to first install the deldir libary') }
	z <- deldir(xy[,1], xy[,2])
	w <- tile.list(z)
	polys <- vector(mode='list', length=length(w))
	if (sp) {
		for (i in seq(along=polys)) {
			pcrds <- cbind(w[[i]]$x, w[[i]]$y)
			pcrds <- rbind(pcrds, pcrds[1,])
			polys[[i]] <- Polygons(list(Polygon(pcrds)), as.character(i))
		}
		polys <- SpatialPolygons(polys)
		if (dataframe) {
			polys <- SpatialPolygonsDataFrame(polys, data=data.frame(xy))
		}
	} else {
		for (i in seq(along=polys)) {
			pcrds <- cbind(i, w[[i]]$x, w[[i]]$y)
			polys[[i]] <- rbind(pcrds, pcrds[1,])
		}
		polys <- geoPolygons(polys)
	}
	return(polys)
}

# v = voronoiPolygons(cbind(x,y), sp=F)
# m = matrix(ncol=3)
#for (i in 1:length(v)) m = rbind(m, v[[i]], cbind(NA, NA, NA))
#polygon(m)