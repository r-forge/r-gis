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
	unsigned nr = std::min(nrows, nrow-row);
	unsigned nc = std::min(ncols, ncol-col);
	if ((nr != nrows) || (nc != ncols)) {
		// message
		nrows = nr;
		ncols = nc;
	}
	
	std::vector<double> out(nrows*ncols);
	if (source.memory[0]) {
		size_t k = 0;
		size_t ij;
		for (size_t i = row; i < (row+nrows); i++) {
			for (size_t j = col; j < (col+ncols); j++) {
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

