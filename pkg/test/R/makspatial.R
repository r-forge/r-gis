
# make a Spatial*DataFrame object from a matrix (or data.frame) with x and y coordinates and a grouping vector with ids to group the coordinates. 

makeSpatial <- function(xy, id, data, type='polygon') {
	require(sp)
	if (! type %in% c('point', 'line', 'polygon') ) {stop('type should be "point", "line", or "polygon"') }
	if (type=='point' & missing(id)) id = data.frame(1:nrow(xy))
	if (length(id) != nrow(xy)) {stop('length(id) != nrow(xy)')}
	if (!missing(data)) {
		if (nrow(data) != length(unique(id))) stop('nrow(data) != length(id)')
	}
	xy = xy[,1:2]
	if (type == 'point') {
		xy = data.frame(xy)
		colnames(xy) = c('x', 'y')
		coordinates(xy) = ~x+y
		if (missing(data)) {
			return(SpatialPointsDataFrame(xy, data.frame(id=id)))
		} else {
			return(SpatialPointsDataFrame(xy, data.frame(data)))		
		}
	} else if (type == 'polygon') {
		crds = list()
		ids = unique(id)
		for (i in 1:length(ids)) {	
			crd = xy[id==ids[i], ]
			if (nrow(crd) < 3) {stop('invalid polygon, less than 3 nodes:', ids[i] )}
			if (! all(crd[nrow(crd),] == crd[1,]) ) {
				crd = rbind(crd, crd[1,])
			}
			crds[[i]] = crd
		}
		p = lapply(crds, Polygon)	
		pp = list()
		for (i in 1:length(p)) pp[i] = Polygons(p[i], i)
		if (missing(data)) {
			return ( SpatialPolygonsDataFrame(SpatialPolygons(pp), data.frame(id=ids)) )
		} else {
			return ( SpatialPolygonsDataFrame(SpatialPolygons(pp), data.frame(data)) )
		}
	} else if (type == 'line') {
		crds = list()
		ids = unique(id)
		for (i in 1:length(ids)) {	
			crd = xy[id==ids[i], ]
			if (nrow(crd) < 2) {stop('invalid line, less than 2 nodes:', ids[i] )}
			crds[[i]] = crd 
		}
		p = lapply(crds, Line)	
		pp = list()
		for (i in 1:length(p)) pp[i] = Lines(p[i], as.character(i))
		if (missing(data)) {
			return ( SpatialLinesDataFrame(SpatialLines(pp), data.frame(id=ids)) )
		} else {
			return ( SpatialLinesDataFrame(SpatialLines(pp), data.frame(data)) )		
		}
	}
}


# getting some points, reusing 
# an example I posted earlier today
#cbind(0, seq(-80, 80, by=20))
#dist = 1000000  # 1000 km
#angles = seq(0,360, by=10)
#library(geosphere)
#xy = NULL
#for (i in 1:nrow(p)) {  xy = rbind(xy, destPoint(p[i,], angles, dist)) }
#id = rep(1:nrow(p), each=length(angles))


#now use the above function
#poly = makeSpatial(xy, id)
#line = makeSpatial(xy, id, type='line')
#point = makeSpatial(xy, id, type='point')


#library(maptools)
#data(wrld_simpl)
#plot(wrld_simpl)
#plot(poly, add=TRUE, col='red')
#plot(line, add=TRUE, col='green', lwd=3)
#plot(point, add=TRUE, pch=1, col='blue')

#line@data
#data = data.frame(letter=letters[1:length(unique(id))])
#line = makeSpatial(xy, id, data=data,  type='line')
#line@data
