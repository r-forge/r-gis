
as.raster <- function(spgrid, getdata=TRUE, dataindex=1) {
	raster <- raster.new()
	raster@bbox <- spgrid@bbox
	raster@proj4string <- spgrid@proj4string
	raster@ncols <- spgrid@grid@cells.dim[1]
	raster@nrows <- spgrid@grid@cells.dim[2]
	if (getdata) {
		if (class(spgrid)=='SpatialPixels') {
			# do noting, there is no data
			# we could store the indices, but then we would have a sparse raster with no data (or with NAs). That goes against our definition of sparse (all NAs have been removed)
		} else if (class(spgrid)=='SpatialPixelsDataFrame') {
			cells <- spgrid@grid.index
			if (length(cells)==0) {
				cells <- raster.get.cell.from.xy(raster, spgrid@coords)
			}
			vals <- spgrid@data[dataindex]
			raster <- raster.set.data.sparse(raster, cells, vals)
		} else if ( class(spgrid)=='SpatialGrid' ) {
			# do nothing, there is no data
		} else if (class(spgrid)=='SpatialGridDataFrame' ) {
			raster <- raster.set.data(raster, spgrid@data[dataindex])
		}
	}
	return(raster)
}

as.spgrid <- function(raster, type='grid')  {
	bb <- raster.boundingbox(raster)
	cs <- raster.resolution(raster)
	cc <- bb[,1] + (cs/2)
	cd <- ceiling(diff(t(bb))/cs)
	grd <- GridTopology(cellcentre.offset=cc, cellsize=cs, cells.dim=cd)
	
	if (type=='pixel') {
		raster <- raster.make.sparse(raster)
		pts <- SpatialPoints(raster.get.xy.from.cell(raster, raster.indices(raster)))
		sp <- SpatialPixelsDataFrame(points=pts, data=raster.values(raster), proj4string=raster.projection(raster)) 	
		
	} else if (type=='grid') {
		if (raster.content(raster) == 'all') {
			sp <- SpatialGridDataFrame(grd, proj4string=raster.projection(raster), data=raster.values(raster))
		} else { 
			sp  <- SpatialGrid(grd, proj4string=raster.projection(raster))
		}	
	}
	return(sp)
}

