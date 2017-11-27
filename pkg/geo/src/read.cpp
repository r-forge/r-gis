using namespace std;
#include "geo.h"


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
	std::vector<double> v;
	if (source.memory[0]) {
		v = getValues();
	} else {
		// read
	}
	return(v);	
}


