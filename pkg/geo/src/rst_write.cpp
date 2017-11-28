using namespace std;

#include <vector>
#include <fstream>
#include <iostream>
#include "geo.h"


bool rst_writeValues(string filename, std::vector<double>  values) {
	

	std::ofstream file(filename, ios::out | ios::binary);
//	const char* pointer = reinterpret_cast<const char*>(&values[0]);
//	file.write(pointer, values.size() * sizeof(double));
	file.write((char*)&values[0], values.size() * sizeof(double));
	file.close();

	// write hdr

	return(true);
}

