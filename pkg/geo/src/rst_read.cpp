/*
  C++ for reading gridfiles
  Robert Hijmans
  January 2008
  r.hijmans@gmail.com
*/


using namespace std;

#include "geo.h"
#include <vector>
#include <fstream>
#include <iostream>



short getshortcell(ifstream &thefile, double cell) {
  short value[1];
  const int dsize = 2;
  thefile.seekg ( cell * dsize, ios::beg);
  thefile.read ((char*)value, sizeof(value)); 
  return (int)value[0];
}

long getlongcell(ifstream &thefile, double cell) {
  long value[1];
  const int dsize = 4;
  thefile.seekg ( cell * dsize, ios::beg);
  thefile.read ((char*)value, sizeof(value)); 
  return (long)value[0];
}

 
std::vector<double> readFLT4(string file, unsigned long cell, unsigned n) {
	const int dsize = 4;
	std::vector<float> v(n);
	float* value = &v[0];

	ifstream f (file, ios::in | ios::binary);
	f.seekg ( cell * dsize, ios::beg);
	f.read ((char*)value, dsize*n); 
	f.close();

	std::vector<double> vv(v.begin(), v.end());
	return vv;
}

std::vector<double> readFLT8(string file, unsigned long cell, unsigned n) {
	const int dsize = 8;
	std::vector<double> v(n);
	double* value = &v[0];

	ifstream f (file, ios::in | ios::binary);
	f.seekg ( cell * dsize, ios::beg);
	f.read ((char*)value, dsize*n); 
	f.close();

	return v;
}

