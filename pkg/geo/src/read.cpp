using namespace std;
#include "geo.h"
//#include "boost/multi_array.hpp"


void GeoRaster::readStart(){
// for now assuming a single source
// will have to become a loop over sources
	if (!source.memory[0]) {
		// open filestream
	}
}

void GeoRaster::readStop(){
	if (!source.memory[0]) {
		// close filestream
	}
}


std::vector<double> GeoRaster::readValues(unsigned row, unsigned nrows, unsigned col, unsigned ncols){
	
	// probably should be using zero based indexing at the C level

	unsigned nr = std::min(nrows, nrow-row+1);
	unsigned nc = std::min(ncols, ncol-col+1);
	if ((nr != nrows) || (nc != ncols)) {
		// message
		nrows = nr;
		ncols = nc;
	}
	
	std::vector<double> out(nrows*ncols, NAN);
	
	if (source.memory[0]) {
		size_t k = 0;
		size_t ij;
		for (size_t i = (row-1); i < (row+nrows-1); i++) {
			for (size_t j = (col-1); j < (col+ncols-1); j++) {
				ij = i * ncol + j;
				out[k] = values[ij];
				k++;
			}
		}
	} else {
		// read from file
	}
	return(out);	
}


