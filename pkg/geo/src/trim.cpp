using namespace std;
#include "geo.h"

GeoRaster GeoRaster::trim(unsigned padding, double val, std::string filename) {

	unsigned nr = nrow;
	unsigned nc = ncol;
	unsigned nl = nlyr();
	unsigned nrl = nr * nl;
	unsigned ncl = nc * nl;

	unsigned cnt = 0;
	std::vector<double> v;
	size_t r;
	for (r=0; r<nr; r++) {
		v = readValues(r, 1, 1, nc);
		if (std::count (v.begin(), v.end(), val) < ncl) {
			break;
		}
		cnt += 1;
	}
	
	if ( cnt == nr) { //stop('only NA values found')
	}
	
	unsigned firstrow = std::min(std::max(unsigned(r) - padding, unsigned(1)), nr);

	for (r=nr; r<firstrow; r--) {
		v = readValues(r, 1, 1, nc);
		if (std::count (v.begin(), v.end(), val) < ncl) {
			break;
		}
	}
	
	unsigned lastrow = max(min(unsigned(r)+padding, nr), unsigned(1));
	
	unsigned tmp;
	if (lastrow < firstrow) { 
		tmp = firstrow;
		firstrow = lastrow;
		lastrow = tmp;
	}
	size_t c;
	for (c=1; c<nc; c++) {
		v = readValues(1, nrow, c, 1);
		if (std::count (v.begin(), v.end(), val) < nrl) {
			break;
		}
	}
	unsigned firstcol = min(max(unsigned(c)-padding, unsigned(1)), nc);
	
	for (size_t c=nc; c>firstcol; c--) {
		v = readValues(1, nrow, c, 1);
		if (std::count (v.begin(), v.end(), val) < nrl) {
			break;
		}
	}
	unsigned lastcol = std::max(std::min(unsigned(c)+padding, nc), unsigned(1));
	
	if (lastcol < firstcol) { 
		tmp = firstcol;
		firstcol = lastcol;
		lastcol = tmp;
	}
	
	std::vector<double> res = resolution();
	double xr = res[0];
	double yr = res[1];
	
	GeoExtent e = GeoExtent(xFromCol(firstcol)-0.5*xr, xFromCol(lastcol)+0.5*xr, yFromRow(lastrow)-0.5*yr, yFromRow(firstrow)+0.5*yr);
	
	return( crop(e, filename=filename) ) ;
}

