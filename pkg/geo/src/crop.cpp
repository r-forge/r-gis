using namespace std;

#include "geo.h"
#include "util.h"
#include <set>



GeoRaster GeoRaster::crop(GeoExtent e, std::string filename, std::string snap, bool overwrite) {

	GeoRaster out = *this;
	out.values.resize(0);
	
	e.intersect(out.getExtent());
	
	if ( !e.valid() ) {
//		return NULL;
//		stop("extents do not overlap")
	}
	
	out.setExtent(e, true, snap);
	
	if (!hasValues ) {
		return(out);
	}

	std::vector<double> res = out.resolution();
	double xr = xres();
	double yr = yres();
	
	unsigned col1 = colFromX(out.extent.xmin + 0.5 * xr);
	unsigned col2 = colFromX(out.extent.xmax - 0.5 * xr);
	unsigned row1 = rowFromY(out.extent.ymax - 0.5 * yr);
	unsigned row2 = rowFromY(out.extent.ymin + 0.5 * yr);
	if ((row1==1) && (row2==nrow) && (col1==1) && (col2==ncol)) {
		// return deep copy of input 
	}

	unsigned ncols = out.ncol;

 	out.writeStart(filename, overwrite);
	readStart();
	
	std::vector<double> v;
	for (size_t i = 0; i < bs.n; i++) {
		v = readValues(row1+bs.row[i], bs.nrows[i], col1, ncols);	
		out.writeValues(v, bs.row[i]);
	} 
	out.writeStop();
	readStop();
	
	return(out);
}


