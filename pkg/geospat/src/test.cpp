using namespace std;
#include <vector>
#include <iostream>
#include "geo.h"


GeoRaster GeoRaster::test(string filename) {

	GeoRaster out = *this;
	std::vector<double> v = getValues();
	for (size_t i = 0; i < v.size(); i++) {
		v[i] = v[i] - 1000;
	}
	out.setValues(v);
	
	/*
	source.driver.resize(1);
	source.driver[0] = "native";
  	out.writeStart(filename, true);
	ofstream f;
	f.open(filename, ios::out | ios::binary);
	out.writeValues(v, 0);
	f.close();
	out.writeStop(); */
	return(out);
}

