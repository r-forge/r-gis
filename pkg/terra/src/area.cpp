// Copyright (c) 2018  Robert J. Hijmans
//
// This file is part of the "spat" library.
//
// spat is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// spat is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with spat. If not, see <http://www.gnu.org/licenses/>.

#include <vector>
#include <math.h>
#include "geodesic.h"

double area_polygon_lonlat(std::vector<double> lon, std::vector<double> lat, double a, double f) {
	struct geod_geodesic g;
	struct geod_polygon p;
	geod_init(&g, a, f);
	geod_polygon_init(&p, 0);
	int n = lat.size();
	for (int i=0; i < n; i++) {
		geod_polygon_addpoint(&g, &p, lat[i], lon[i]);
	}
	double area, P;
	geod_polygon_compute(&g, &p, 0, 1, &area, &P);
	return(area < 0 ? -area : area);
}

std::vector<double> area_polygon_lonlat(std::vector<double> lon, std::vector<double> lat, std::vector<int> pols, std::vector<int> parts, std::vector<int> holes, double a, double f) {

	std::vector<double> out;
	struct geod_geodesic g;
	struct geod_polygon p;
	geod_init(&g, a, f);
	geod_polygon_init(&p, 0);
    
	double area, P, pa, tota;
	int pol = 1;
	int part = 1;
	int n = lon.size();
	tota = 0;
	for (int i=0; i < n; i++) {
		if (parts[i] != part || pols[i] != pol) {
			geod_polygon_compute(&g, &p, 0, 1, &area, &P);
			pa = fabs(area);
			tota += (holes[i-1] > 0 ? -pa : pa); // hole
			part = parts[i]; 
			if (pols[i] != pol) {
				out.push_back(tota);
				tota = 0;
				pol = pols[i];
			}
			geod_polygon_init(&p, 0);
		} 
		geod_polygon_addpoint(&g, &p, lat[i], lon[i]);		
	}
	geod_polygon_compute(&g, &p, 0, 1, &area, &P);
	pa = fabs(area);
	tota += (holes[n-1] > 0 ? -pa : pa); // hole
	out.push_back(tota);
	return(out);
}



double area_polygon_plane(std::vector<double> x, std::vector<double> y) {
// based on http://paulbourke.net/geometry/polygonmesh/source1.c
	int n = x.size();
	double area = x[n-1] * y[0];
	area -= y[n-1] * x[0];
	for (int i=0; i < (n-1); i++) {
		area += x[i] * y[i+1];
		area -= x[i+1] * y[i];
	}
	area /= 2;
	return(area < 0 ? -area : area);
}


std::vector<double> area_polygon_plane(std::vector<double> x, std::vector<double> y, std::vector<int> pols, std::vector<int> parts, std::vector<int> holes) {

	std::vector<double> out;
	int pol = 1;
	int part = 1;
	int n = x.size();
	double tota = 0;
	double pa;
	int ps = 0;
	for (int i=0; i < n; i++) {
		if (parts[i] != part || pols[i] != pol) {
			pa = area_polygon_plane(std::vector<double> (x.begin() + ps, x.begin() + i - 1), std::vector<double> (y.begin() + ps, y.begin() + i - 1));
			tota += (holes[i-1] > 0 ? -pa : pa);
			part = parts[i];
			ps = i;
			if (pols[i] != pol) {
				out.push_back(tota);
				tota = 0;
				pol = pols[i];
			}
		} 
	}
	pa = area_polygon_plane(std::vector<double> (x.begin() + ps, x.end()), std::vector<double> (y.begin() + ps, y.end()));
	tota += (holes[n-1] > 0 ? -pa : pa);
	out.push_back(tota);
	return(out);
}
