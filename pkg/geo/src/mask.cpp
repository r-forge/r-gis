using namespace std;
#include <vector>
#include <iostream>
#include "geo.h"


GeoRaster GeoRaster::mask(GeoRaster mask, string filename) {

// check for size; need for recycling 
	GeoRaster out = *this;
	out.values.resize(0);
	BlockSize bs = out.getBlockSize(filename);
 	out.writeStart(filename);
	readStart();
	mask.readStart();
	
	std::vector<double> v, m;
	for (size_t i = 0; i < bs.n; i++) {
		v = readValues(bs.row[i], bs.nrows[i], 0, ncol);
		m = mask.readValues(bs.row[i], bs.nrows[i], 0, ncol);
		for (size_t i=0; i < v.size(); i++) {
			if (std::isnan(m[i])) {
				v[i] = NAN;
			} 
		}
		out.writeValues(v, bs.row[i]);
	}
	out.writeStop();
	readStop();	
	mask.readStop();	
	
	return(out);
}


/*

std::vector<std::vector<double> > matrix(int nrow, int ncol) {
	std::vector<std::vector<double> > m (nrow, std::vector<double>(ncol));
	return(m);
}


int main() {
	std::vector<vector<double> > d = matrix(10, 2);
	std::vector<double> m (10);
	m[1] = 1;
	m[5] = 1;
	d = mask(d, m, 1, 9, false);
	for (int i=0; i < d.size(); i++) {
		for (int j=0; j < d[0].size(); j++) {
			std::cout << ' ' << d[i][j];
		}
		std::cout << '\n';
	}
	std::cout << '\n';
}
*/