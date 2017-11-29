using namespace std;
#include "geo.h"
#include "rst_read.h"


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
	
	if (is_R) {
		row = row-1;
		col = col-1;
	}

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
		for (size_t i = (row-1); i < (row+nrows-1); i++) {
			for (size_t j = (col-1); j < (col+ncols-1); j++) {
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

		return readValues(1, nrow, 1, ncol);
	}
}

