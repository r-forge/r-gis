using namespace std;

#include "geo.h"
#include "util.h"
#include <set>



GeoRaster GeoRaster::crop(GeoExtent e, std::string filename, std::string snap) {

	GeoRaster out = *this;
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
	double xres = res[0];
	double yres = res[1];
	
	unsigned col1 = colFromX(out.extent.xmin + 0.5 * xres);
	unsigned col2 = colFromX(out.extent.xmax - 0.5 * xres);
	unsigned row1 = rowFromY(out.extent.ymax - 0.5 * yres);
	unsigned row2 = rowFromY(out.extent.ymin + 0.5 * yres);
	if ((row1==1) && (row2==nrow) && (col1==1) && (col2==ncol)) {
		// return deep copy of input 
	}

	unsigned nc = out.ncol;
	unsigned nr = row2 - row1 + 1;

	BlockSize bs = getBlockSize();
	
 
//	out.writeStart(out, filename=filename, ... )
	// only actually write if trim(filename) != ""
	// if multiple steps in iter then create filename 
	// R session should always send a temp folder to static var when pkg is loaded?

//	readStart();
	for (size_t i = 0; i < bs.n; i++) {
//		vv = getValuesBlock(row=itr.row[i]+row1-1, nrows=itr.nrows[i], col1, nc);
		
//      writeValues is setValues if no filename
//		out.writeValues(vv, itr.row[i]);
	} 
//	out = writeStop(out);
//	readStop();

	
	return(out);
}


