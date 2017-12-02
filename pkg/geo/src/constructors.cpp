using namespace std;
#include "geo.h"

GeoRaster::GeoRaster(std::string fname) {
	constructFromFile(fname);
}
		
GeoRaster::GeoRaster() {
	nrow=10; ncol=10; 
	extent = GeoExtent();
	hasValues = false; 
	hasRange.push_back(false);
	source.memory.push_back(true);
	source.filename.push_back("");
	source.driver.push_back("");
	source.nlayers.push_back(1);
	source.layers.resize(1, vector<int>(1));
	source.layers[0][1] = 1;
	source.datatype.push_back("");
	names.push_back("lyr.1");
	setnlyr();
}


GeoRaster::GeoRaster(std::vector<unsigned> rcl, std::vector<double> ext, std::string _crs) {
	nrow=rcl[0]; ncol=rcl[1];
	extent.xmin = ext[0];
	extent.xmax = ext[1];
	extent.ymin = ext[2];
	extent.ymax = ext[3];
	hasValues = false; 
	hasRange.push_back(false);
	source.memory.push_back(true);
	source.filename.push_back("");
	source.driver.push_back("");
	source.nlayers.push_back(rcl[2]);
	source.layers.resize(1, vector<int>(1));
	source.layers[0][1] = 1;
	source.datatype.push_back("");
	crs=_crs;
	for (unsigned i=0; i<rcl[2]; i++) {	names.push_back("lyr." + std::to_string(i)) ; }
	setnlyr();	
}

GeoRaster::GeoRaster(unsigned _nrow, unsigned _ncol, unsigned _nlyr, GeoExtent ext, std::string _crs) {
	nrow=_nrow; ncol=_ncol;
	extent = ext;
	hasValues = false; 
	hasRange.push_back(false);
	source.memory.push_back(true);
	source.filename.push_back("");
	source.driver.push_back("");
	source.nlayers.push_back(_nlyr);
	source.layers.resize(1, vector<int>(1));
	source.layers[0][1] = 1;
	source.datatype.push_back("");
	crs=_crs;
	for (unsigned i=0; i < _nlyr; i++) {	names.push_back("lyr." + std::to_string(i)) ; }
	setnlyr();	
}


