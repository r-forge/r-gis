using namespace std;
#include "geo.h"
#include "util.h"

bool canProcessInMemory() {
	return true;
}

BlockSize GeoRaster::getBlockSize(std::string filename) {
	BlockSize bs;
	trim(filename);
	// check of can be processed in memory
	// if not generate fileanme 
	// R session should always send a temp folder to static var when pkg is loaded?

	if (!canProcessInMemory() && filename == "") {
		filename = "random_file_name.grd";
	}
	
	bs.filename = filename;
	if (filename == "") {
	// in memory
		bs.row = {1};
		bs.nrows = {nrow};
		bs.n = 1;	
	} else {
	// to be improved, see raster::blockSize
		bs.row = {1, unsigned(ceil(nrow/2))};
		bs.nrows = {bs.row[1] - 1, nrow-bs.row[1] + 1};
		bs.n = 2;
	}
	return bs;
}


void GeoRaster::writeStart(std::string filename){
	if (filename != "") {
		source.filename[0] = filename;
		// open filestream
		
	} else {
		source.filename[0] = "";
	}
}


void GeoRaster::writeStop(){
	if (source.filename[0] != "") {
		// close filestream
	}
}

void GeoRaster::writeValues(std::vector<double> values, unsigned row){
	if (source.filename[0] != "") {
		// write
	} else {
		setValues(values);
	}
}


void GeoRaster::setValues(std::vector<double> _values) {
			//bool result = false;
	if (_values.size() == (ncol * nrow * nlyr())) {
		values = _values;
		std::vector<bool> mem {true};
		source.memory = mem;
				// todo clear source...
		setRange();
		hasValues = true;
		std::vector<string> n {"layer"};
		names = n;
				
		//result = true;
	} 
	//return (result);
}



