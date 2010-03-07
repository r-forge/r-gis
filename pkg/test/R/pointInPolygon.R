# Author: Robert J. Hijmans
# contact: r.hijmans@gmail.com
# Date : Febrary 2010
# Version 0.0
# Licence GPL v3


pointInPolygon <- function(points, polygons, fun=NULL) {
# based on similar function in sp (overlay) by Pebesma and Bivand
# and calling a C function from the SP package
	npoly = length(polygons)
	xy = points@xy
	xy[] = as.numeric(xy)
	res = vector(length=nrow(xy))
	result = matrix(nrow=length(res), ncol=length(polygons))
	for (i in 1:npoly) {
		poly <- part(polygons, i)
		e = extent(poly@xy)
		inbox <- xy[,1] >= e@xmin & xy[,2] <= e@xmax & xy[,2] >= e@ymin & xy[,2] <= e@ymax
		p = xy[inbox, ,drop=FALSE]
		if (nrow(p) > 0) {
			res2 = vector(length=nrow(p))
			res2[] = 0
			parts <- nparts(poly)
			for (j in 1:parts) {
				part = part(poly, 1, j)
				pol.x = part@xy[,1]
				pol.y = part@xy[,2]
				resj = .Call("R_point_in_polygon_sp", as.numeric(p[,1]), as.numeric(p[,2]), as.numeric(pol.x), as.numeric(pol.y), PACKAGE = "sp")
				resj = as.logical(resj)
				if (hole(part,1,1)) {
					resj[resj == 1] = NA
				}
				res2 <- pmax(res2, resj)
			}
			res[] = 0
			res[inbox] = pmax(res[inbox], res2)	
		}
		result[,i] = res
	}
	result[is.na(result)] = 0
	if (! is.null(fun)) {
		result = apply(result, 1, fun)
	}
	return(result)
}

# a =  pointInPolygon(xy, wrld_simpl)
# b = apply(a, 1, max)
# c = apply(a, 1, which.max)
# c[b==0] = NA

