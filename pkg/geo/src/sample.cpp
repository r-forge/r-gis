// Author: Robert J. Hijmans
// Date : November 2009
// Version 0.9
// Licence GPL v3

/*
std::vector<double> GeoRaster::sampleRegular(unsigned size, GeoExtent ext, bool cells, bool asRaster) {

//	stopifnot(hasValues(x) | isTRUE(xy))
//  stopifnot(size > 0)
	
//	if (!hasWindow) {
		rcut = x;
		firstrow = 1;
		lastrow = nrow(rcut);
		firstcol = 1;
		lastcol = ncol(rcut);
*/
/*	} else {
		rcut = crop(raster(x), ext)
		ext = extent(rcut)
		yr = yres(rcut)
		xr = xres(rcut)
		firstrow = rowFromY(x, ext@ymax-0.5 *yr)
		lastrow = rowFromY(x, ext@ymin+0.5*yr)
		firstcol = colFromX(x, ext@xmin+0.5*xr)
		lastcol = colFromX(x, ext@xmax-0.5*xr)
	} */
/*
	allx = FALSE;
	if (size >= rcut.ncell()) {
		if (!is.null(ext)) {
			xx = x.crop(ext);
		}
		if (asRaster) {
			return(xx);
		}
		
		nr = rcut.nrow;
		nc = rcut.ncol;
		allx = true;
		
	} else {
	
		Y = X = sqrt(ncell(rcut)/size)
		nr = max(1, floor((lastrow - firstrow + 1) / Y))
		nc = max(1, floor((lastcol - firstcol + 1) / X))

		rows = (lastrow - firstrow + 1)/nr * 1:nr + firstrow - 1
		rows = rows - (0.5 * (lastrow - firstrow + 1)/nr)
		cols = (lastcol - firstcol + 1)/nc * 1:nc  + firstcol - 1
		cols = cols - (0.5 * (lastcol - firstcol + 1)/nc)

		cols = unique(round(cols))
		rows = unique(round(rows))
		cols = cols[cols > 0]
		rows = rows[rows > 0]
		nr = length(rows)
		nc = length(cols)
	}
	
	hv = hasValues(x)
	if (allx) {
		cell = 1:ncell(rcut)
	} else {
		cell = cellFromRowCol(x, rep(rows, each=nc), rep(cols, times=nr))
	}
	
	if (asRaster) {
			
			if (allx) {
				if (!is.null(ext)) {
					return(crop(x, ext))
				} else {
					return(x)
				}
			} 
			
			
			cell = cellFromRowCol(x, rep(rows, each=nc), rep(cols, times=nr))
			if (hv) {
				m = .cellValues(x, cell)
			} else {
				m = NA
			}

			if (is.null(ext))  {
				outras = raster(x)
			} else {
				outras = raster(ext) 
				crs(outras) = crs(x)
			}
			nrow(outras) = nr
			ncol(outras) = nc
			
//		outras = brick(outras, nlyr=nlyr)
		
		outras = setValues(outras, m)
		names(outras) = names(x)
		if (any(is.factor(x))) {
			levels(outras) = levels(x)
		}
		return(outras)
		
	} else {
		
		if (allx) {
			cell <= 1:ncell(rcut)
		} else {
			cell = cellFromRowCol(x, rep(rows, each=nc), rep(cols, times=nr))
		}
		m = NULL
		nstart = 1
		if (xy) {
			m = xyFromCell(x, cell)
			nstart = 3
		}
		if (cells) {
			m = cbind(m, cell=cell)
			nstart = nstart + 1
		} 
		if (hv) {
			m = cbind(m, .cellValues(x, cell))
			colnames(m)[nstart:(nstart+nlyr-1)] = names(x)
		} 
			
		return(m)
	}	
}

*/