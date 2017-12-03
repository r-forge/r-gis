using namespace std;
#include "geo.h"
#include "SimpleIni.h"
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
		bs.row = {0};
		bs.nrows = {nrow-1};
		bs.n = 1;
	} else {
	// to be improved, see raster::blockSize
		bs.row = {0, unsigned(floor(nrow/2))};
		bs.nrows = {bs.row[1], nrow-bs.row[1]};
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
		if (source.driver[0] == "native") {
			// open filestream
		} else {
			// open filestream		
		}
	} else {
		source.filename[0] = "";
	}
}


void GeoRaster::writeStop(){
	if (source.filename[0] != "") {
		// close filestream
		if (source.driver[0] == "native") {
			//bool ok = 
			GeoRaster::writeHDR();
		}
	}
}

void GeoRaster::writeValues(std::vector<double> vals, unsigned row){
	if (source.filename[0] != "") {
		if (source.driver[0] == "native") {
		
		} else {
			// write with gdal
		}
	} else {
		setValues(vals);
	}
}


void GeoRaster::setValues(std::vector<double> _values) {
	//bool result = false;
	//if (_values.size() == size()) {
		values = _values;
		hasValues = true;

		source.memory = std::vector<bool> {true};
		// todo clear source...
		setRange();

		//names = std::vector<string> {"layer"};
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
			if (val > max) {
				imax = p;
				max = val;
			}
			if (val < min) {
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
		range_min = std::vector<double> {vmin};
		range_max = std::vector<double> {vmax};
		hasRange = std::vector<bool> {true};
	//}
}



bool GeoRaster::writeHDR() { 

	CSimpleIniA ini;	
	ini.SetValue("section", "key", "newvalue");
		
	ini.SetValue("version", NULL, NULL);
	ini.SetValue("version", "version", "2");
	
	ini.SetValue("georeference", NULL, NULL);

	ini.SetValue("georeference", "xmin", to_string(extent.xmin).c_str());
	ini.SetValue("georeference", "xmax", to_string(extent.xmax).c_str());
	ini.SetValue("georeference", "ymin", to_string(extent.ymin).c_str());
	ini.SetValue("georeference", "ymax", to_string(extent.ymax).c_str());
	ini.SetValue("georeference", "projection", crs.c_str());

	ini.SetValue("dimensions", "nrow", to_string(nrow).c_str());
	ini.SetValue("dimensions", "ncol", to_string(ncol).c_str());
	ini.SetValue("dimensions", "nlyr", to_string(nlyr).c_str());
	ini.SetValue("dimensions", "names", concatenate(names, std::string(":|:")).c_str());		

	ini.SetValue("data", NULL, NULL);
	ini.SetValue("data", "datatype", "FLT4S"); // ojo
	ini.SetValue("data", "nodata", to_string(-1 * numeric_limits<double>::max()).c_str());

	ini.SetValue("data", "range_min", concatenate(dbl2str(range_min), std::string(":|:")).c_str());
	ini.SetValue("data", "range_max", concatenate(dbl2str(range_max), std::string(":|:")).c_str());

	SI_Error rc = ini.SaveFile(source.filename[0].c_str());
	if (rc < 0) {
		return false;
	} else {
		return true;
	}	
}

