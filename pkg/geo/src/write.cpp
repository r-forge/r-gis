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


GeoRaster GeoRaster::writeRaster(std::string filename) {
//	if ((filename == "") { stop}
//	if ((!hasValues) {stop }
	
	writeStart(filename);
	writeValues(getValues(), 1);
	writeStop();
	return GeoRaster(filename);
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

void GeoRaster::writeValues(std::vector<double> vals, unsigned row){
	if (source.filename[0] != "") {
		// write
	} else {
		setValues(vals);
	}
}


void GeoRaster::setValues(std::vector<double> _values) {
	//bool result = false;
	//if (_values.size() == (ncol * nrow * nlyr())) {
		values = _values;
		
		std::vector<bool> mem {true};
		source.memory = mem;
		// todo clear source...
		setRange();
		hasValues = true;
		std::vector<string> n {"layer"};
		names = n;
				
		//result = true;
	//} 
	//return (result);
}


void vector_minmax(std::vector<double> v, double &min, int &imin, double &max, int &imax) {
    std::vector<double>::size_type p=0;
    imax = -1; imin=-1;
    min = std::numeric_limits<double>::max();
    max = std::numeric_limits<double>::lowest();
    for (auto &val : v) {
		if (!std::isnan(val)) {
			if (val>max) {
				imax = p;
				max = val;
			}
			if (val<min) {
				imin = p;
				min = val;
			}
		}
        p++;
    }
}


void GeoRaster::setRange() {
// this does not work when the first element is NAN
	double vmin, vmax;
	int imin, imax;
	vector_minmax(values, vmin, imin, vmax, imax); 

	std::vector< std::vector<double> > v(2, vector<double>(1));
	v[0][0] = vmin;
	v[1][0] = vmax;
	
/*	auto result = std::minmax_element (values.begin(), values.end());
	v[0][0] = *result.first;
	v[1][0] = *result.second;
*/	

	range = v;
	hasRange = std::vector<bool> {true};
}
