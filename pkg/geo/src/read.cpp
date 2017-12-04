using namespace std;
#include "geo.h"
#include "rst_read.h"


bool GeoRaster::readStart() {
// for now assuming a single source
// will have to become a loop over sources
	if (!source.memory[0]) {
		// open filestream
	}
	return true;
}

bool GeoRaster::readStop() {
	if (!source.memory[0]) {
		// close filestream
	}
	return true;
}


std::vector<double> GeoRaster::readValues(unsigned row, unsigned nrows, unsigned col, unsigned ncols){
	
//	unsigned nlayers = nlyr();
	unsigned  r = std::min(std::max(unsigned(0), row), nrow-1);
	unsigned  c = std::min(std::max(unsigned(0), col), ncol-1);
	unsigned nr = std::max(unsigned(1), std::min(nrows, nrow-r));
	unsigned nc = std::max(unsigned(1), std::min(ncols, ncol-c));
	if ((r != row) || (c != col) || (nr != nrows) || (nc != ncols)) {
		// message
		row = r;
		col = c;
		nrows = nr;
		ncols = nc;
	}
	unsigned endrow = row + nrows;
	unsigned endcol = col + ncols;
	
	std::vector<double> out(nrows*ncols);
	if (source.memory[0]) {
		size_t k = 0;
		size_t ij;
		for (size_t i = row; i < endrow; i++) {
			for (size_t j = col; j < endcol; j++) {
				ij = i * ncol + j;
				out[k] = values[ij];
				k++;
			}
		}
	} else {
		// read from file
		string file = source.filename[0];
		out = readFLT4(file, 0, ncell());
	}
	return(out);	
}



std::vector<double>  GeoRaster::getValues() { 
	if (source.memory[0]) {
		return values; 
	} else {
		return readValues(0, nrow, 0, ncol);
	}
}

