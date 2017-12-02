/* Robert Hijmans, October 2014 */

using namespace std;
#include <vector>
#include <limits>
#include <cmath>
#include "geo.h"



std::vector<unsigned> GeoRaster::get_aggregate_dims( std::vector<unsigned> fact ) {
	// fact has aggregation factors in the three dimensions
	// int dy = dim[0], dx = dim[1], dz = dim[2];
	fact.resize(6);
	// new dimensions: rows, cols, lays
	fact[3] = std::ceil(nrow / fact[0]);
	fact[4] = std::ceil(ncol / fact[1]);
	fact[5] = std::ceil(nlyr / fact[2]);
	return fact;
}


std::vector<std::vector<double> > GeoRaster::get_aggregates(std::vector<unsigned> dim) {
	// blocks per row (=ncol), col (=nrow) 
	unsigned dy = dim[0], dx = dim[1], dz = dim[2];
	unsigned bpC = dim[3];
	unsigned bpR = dim[4];
	unsigned bpL = bpR * bpC;

	// new number of layers
	unsigned newNL = dim[5];

	// new number of rows, adjusted for additional (expansion) rows
	unsigned adjnr = bpC * dy;

	// number of aggregates
	unsigned nblocks = (bpR * bpC * newNL);
	// cells per aggregate
	unsigned blockcells = dx * dy * dz;
  
	// output: each row is a block 
	std::vector< std::vector<double> > a(nblocks, std::vector<double>(blockcells, std::numeric_limits<double>::quiet_NaN()));

	for (unsigned b = 0; b < nblocks; b++) {
		unsigned lstart = dz * (b / bpL);
		unsigned rstart = (dy * (b / bpR)) % adjnr;
		unsigned cstart = dx * (b % bpR);

		unsigned lmax   = std::min(nlyr, (lstart + dz));
		unsigned rmax   = std::min(nrow, (rstart + dy));
		unsigned cmax   = std::min(ncol, (cstart + dx));

		unsigned f = 0;
		unsigned nc = ncell();
		for (unsigned j = lstart; j < lmax; j++) {
			unsigned lj = j * nc;
			for (unsigned r = rstart; r < rmax; r++) {
				unsigned cell = lj + r * ncol;
				for (unsigned c = cstart; c < cmax; c++) {
					a[b][f] = values[cell + c];
					f++;
				}
			}
		}
	}
	return(a);
}


GeoRaster GeoRaster::aggregate(std::vector<unsigned> fact, bool narm, string fun, string filename) {

	fact = get_aggregate_dims(fact);
	
	unsigned f = 1, mean = 0; // sum
	if (fun == "mean") {
		f = 1;
		mean = 1;
	} else if (fun == "min") {
		f = 2;
	} else if (fun == "max") {
		f = 3;	
	}

	// output: each row is a new cell 
	double NA = std::numeric_limits<double>::quiet_NaN();
	
	std::vector< std::vector<double> > v(fact[3]*fact[4], std::vector<double>(fact[5], NA));
											 
	// get the aggregates	
	// get the aggregates	
	std::vector<std::vector< double > > a = get_aggregates(fact);

	int nblocks = a.size();
	int naggs = a[0].size();
 	
 
	for (int i = 0; i < nblocks; i++) {
		unsigned row = (i / ncol) % nrow; 
		unsigned col = i % ncol;
		unsigned cell = row * ncol + col;
		unsigned lyr = std::floor(i / (nrow * ncol));
	
		double x = 0;
		if (f==2) { // min
			x = std::numeric_limits<double>::infinity();
		} else if (f==3) { // max
			x = - std::numeric_limits<double>::infinity() ; 
		} 
		
		double cnt = 0;
		
		for (int j = 0; j < naggs; j++) {
			if (std::isnan(a[i][j])) {
				if (!narm) {
					x = NA;
					goto breakout;
				}
			} else {
				if (f==2) { // min
					x = std::min(x, a[i][j]);
				} else if (f==3) { // max
					x = std::max(x, a[i][j]);
				} else { // sum or mean	
					x += a[i][j];
				}
				cnt++;
			}
		}
		if (cnt > 0) {
			if (mean) {
				x = x / cnt;
			} 
		} else {
		  x = NA;
		}
		breakout:
		v[cell][lyr] = x;
	}
	
	double xmax = extent.xmin + fact[4] * yres();
	double ymin = extent.ymax - fact[5] * xres();
	GeoExtent e = GeoExtent(extent.xmin, xmax, ymin, extent.ymax);
	GeoRaster r = GeoRaster(fact[3], fact[4], fact[5], e, crs);
	
	// transform v to single dim vector first
	//r.values = v; 
	
	return(r);
}


