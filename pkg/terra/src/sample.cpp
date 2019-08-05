// Copyright (c) 2018-2019  Robert J. Hijmans
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
#include "spatRaster.h"


void getSampleRowCol(std::vector<unsigned> &oldrow, std::vector<unsigned> &oldcol, unsigned nrows, unsigned ncols, unsigned snrow, unsigned sncol) {
	double rf = nrows / (double)(snrow);
	double cf = ncols / (double)(sncol);
	double rstart = floor(0.5 * rf);
	double cstart = floor(0.5 * cf);
	oldcol.reserve(sncol);
	for (size_t i =0; i<sncol; i++) {
        oldcol.push_back(i * cf + cstart);
	}
	oldrow.reserve(snrow);
	for (size_t i =0; i<snrow; i++) {
        oldrow.push_back(i * rf + rstart);
	}
}


std::vector<double> SpatRaster::readSample(unsigned src, unsigned srows, unsigned scols) {
	unsigned oldnc = ncell();
	unsigned nl = source[src].nlyr;
	std::vector<unsigned> oldcol, oldrow;
	getSampleRowCol(oldrow, oldcol, nrow(), ncol(), srows, scols);
	std::vector<double>	out; 
	out.reserve(srows*scols);
    for (size_t lyr=0; lyr<nl; lyr++) {
        unsigned old_offset = lyr * oldnc;
        for (size_t r=0; r<srows; r++) {
 			unsigned oldc = old_offset + oldrow[r] * ncol();
            for (size_t c=0; c<scols; c++) {
				unsigned oldcell = oldc + oldcol[c];
                out.push_back(source[src].values[oldcell]);
            }
        }
	}
	return out;
}


SpatRaster SpatRaster::sampleRegular(unsigned size) {

	if (size >= ncell()) return( *this );

	double f = sqrt(size / ncell());
	unsigned nr = ceil(nrow() * f);
	unsigned nc = ceil(ncol() * f);
	if ((nc == ncol()) && (nr == nrow())) return( deepCopy() );

	SpatRaster out = geometry(nlyr());
	out.source[0].nrow=nr;
	out.source[0].ncol=nc;

	if (!source[0].hasValues) return (out);

	std::vector<double> v;
	for (size_t src=0; src<nsrc(); src++) {
		if (source[src].memory) {
			v = readSample(src, nr, nc);
		} else if (source[src].driver == "raster") {
			v = readSampleBinary(src, nr, nc);
		} else {
		    #ifdef useGDAL
			v = readGDALsample(src, nr, nc);
			#endif
		}
		out.source[0].values.insert(out.source[0].values.end(), v.begin(), v.end());
	}
	out.source[0].driver = "memory";
	out.source[0].hasValues = true;
	out.source[0].setRange();

	return out;
}


/*
SpatDataFrame sampleCells(unsigned size, std::string type, bool replace) {

	SpatDataFrame out;
	if (size >= ncell() & !replace) {
		out.setError("size >= ncell() & !replace");
		return out;
	}
	if (!source[0].hasValues) {
		out.setError("Raster has no values");
		return (out);
	}
	if (type == "Random") {
		
	} else if (type == "Regular") {
		
	} else { //type == "Stratified" 
	
	} // else "Cluster"
	return out;
}
*/

