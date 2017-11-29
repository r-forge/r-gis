using namespace std;
#include "geo.h"
#include "util.h"

bool canProcessInMemory() {
	return true;
}

BlockSize GeoRaster::getBlockSize(std::string filename) {
	BlockSize bs;
	lrtrim(filename);
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
	//if (_values.size() == size()) {
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
	double vmin, vmax;
	int imin, imax;
	// for each layer {
		vector_minmax(values, vmin, imin, vmax, imax); 
		range_min.push_back(vmin);
		range_max.push_back(vmax);
		hasRange.push_back(true);
	//}
}



/*
bool GeoRaster::writeHDR() { 

	CSimpleIniA ini;	
	ini.SetValue("section", "key", "newvalue");
		
	ini.SetValue("version", NULL, NULL);
	ini.SetValue("version", version, "2");
	
	ini.SetValue("georeference", NULL, NULL);
	ini.SetValue("georeference", "xmin", xmin);
	ini.SetValue("georeference", "xmax", xmax);
	ini.SetValue("georeference", "ymin", ymin);
	ini.SetValue("georeference", "ymax", ymax);
	ini.SetValue("georeference", "projection", crs);

	ini.SetValue("dimensions", "nrows", nrow);
	ini.SetValue("dimensions", "ncols", ncol);
	ini.SetValue("dimensions", "nlyrs", nlyr);
	ini.SetValue("dimensions", "lyrnms", names);		

	ini.SetValue("data", NULL, NULL);
	ini.SetValue("data", "datatype", datatype);
	ini.SetValue("data", "nodata", NAvalue);

	std::vector<double> smin = double2str(vmin);
	std::vector<double> smax = double2str(vmax);
	smin = concatenate(smin, ":|:");
	smax = concatenate(smax, ":|:");
	ini.SetValue("data", "minvalue", smin);
	ini.SetValue("data", "maxvalue", smax);
}
*/