using namespace std;
#include <vector>
#include <iostream>
#include "geo.h"
#include "util.h"


GeoRaster GeoRaster::test(string filename) {

	//GeoRaster out = *this;

	std::vector<double> in = getValues();
	std::vector<float> v(in.size());
	
	for (size_t i = 0; i < v.size(); i++) {
		in[i] = in[i] - 1000;
		v[i] = in[i];
	}
	
//	out.source.driver = {"native"} ;
	string fname = setFileExt(filename, ".gri");
//	out.writeStart(fname, true);

	ofstream f;
	f.open(fname, ios::out | ios::binary);
	size_t size = v.size();
	f.write(reinterpret_cast<const char*>(&v[0]), size*sizeof(float));
	f.close();
	
//	out.writeStop(); */	
	// for now for minmax

	GeoRaster out(nrow, ncol, nlyr, extent, crs);
	out.setValues(in);
	out.source.filename = {filename};
    out.writeHDR();
	return out;
	//return GeoRaster(filename);
}

