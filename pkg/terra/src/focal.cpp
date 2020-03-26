// Copyright (c) 2018-2020  Robert J. Hijmans
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

#include "spatRaster.h"
#include "vecmathfun.h"


std::vector<double> rcValue(std::vector<double> &d, const int& nrow, const int& ncol, const unsigned& nlyr, const int& row, const int& col) {
  
  std::vector<double> out(nlyr, NAN);
  if ((row < 0) || (row > (nrow -1)) || (col < 0) || (col > (ncol-1))) {
    return out;
  } else {
    unsigned nc = nrow * ncol;
    unsigned cell = row * ncol + col;
    for (size_t i=0; i<nlyr; i++) {
      unsigned lcell = cell + i * nc;
      out[i] = d[lcell];
    }
  }
  return out;
}

// todo: three dimensional focal

std::vector<double> get_focal(std::vector<double> &d, int nrow, int ncol, int wrows, int wcols, int offset, double fill) {
	int wr = wrows / 2;
	int wc = wcols / 2;
	wr = std::min(wr, nrow);
	wc = std::min(wc, ncol);

	size_t n = (nrow-offset) * ncol * wrows * wcols;
	std::vector<double> val(n, fill);
	int f = 0;
	
	for (int r = offset; r < nrow; r++) {
		for (int c = 0; c < ncol; c++) {
			for (int i = -wr; i <= wr; i++) {
				int row = r+i;			
				if (row < 0 || row > (nrow-1)) {
					f = f + wcols;
				} else {
					unsigned bcell = row * ncol;
					for (int j = -wc; j <= wc; j++) {
						int col = c + j;	
						if ((col >= 0) && (col < ncol)) {
							val[f] = d[bcell+col];
						}
						f++;
					}
				}
			}	
		}
	}
	return(val);
}



std::vector<double> SpatRaster::focal_values(std::vector<unsigned> w, double fillvalue, int row, int nrows) {

	if ((w[0] % 2 == 0) || (w[1] % 2 == 0)) {
		setError("weights matrix must have uneven sides");
		std::vector<double> d;
		return(d);
	}

	int wr = w[0] / 2;
	int wc = w[1] / 2;
	int nr = nrow();
	int nc = ncol();
	wr = std::min(wr, nr);
	wc = std::min(wc, nc);

	int readstart = row-wr;
	readstart = readstart < 0 ? 0 : readstart;
	int offset = row-readstart;
	int readnrows = nrows+(2*wr);
	readnrows = readnrows > nr ? (nr-readstart) : readnrows;
	
	readStart();
	std::vector<double> d = readValues(readstart, readnrows, 0, nc);
	readStop();

	std::vector<double> f = get_focal(d, nrows, nc, w[0], w[1], offset, fillvalue);
	return(f);
}


SpatRaster SpatRaster::focal(std::vector<unsigned> w, std::vector<double> m, double fillvalue, bool narm, std::string fun, SpatOptions &opt) {

	SpatRaster out = geometry();
	if (!source[0].hasValues) { return(out); }

	bool wmat = false;
	if (m.size() > 1) {
		wmat = true;
		
	} else if (w.size() == 1) {
		w.push_back(w[0]);
	} 
	if (w.size() != 2) {
		out.setError("size of w is not 1 or 2");
		return out;
	}
	unsigned ww = w[0] * w[1];
	if (ww < 9) {
		out.setError("not a meanigful window");
		return out;
	}
	if (wmat && (ww != m.size())) {
		out.setError("weight matrix error");
		return out;
	}

 	if (!out.writeStart(opt)) { return out; }

	std::function<double(std::vector<double>&, bool)> fFun = getFun(fun);
	std::vector<double> v;
	
	for (size_t i = 0; i < out.bs.n; i++) {

		std::vector<double> fv = focal_values(w, fillvalue, out.bs.row[i], out.bs.nrows[i]);
		v.resize(out.bs.nrows[i] * ncol());
		if (wmat) {
			for (size_t j=0; j<v.size(); j++) {
				v[j] = 0;
				for (size_t k=0; k<ww; k++) {
					v[j] += fv[j*ww+k] * m[k];
				}
			}			
		} else {
			for (size_t j=0; j<v.size(); j++) {
				unsigned off = j*ww;
				std::vector<double> x(fv.begin()+off, fv.begin()+off+ww);
				v[j] = fFun(x, narm);
			}
		}
		if (!out.writeValues(v, out.bs.row[i], out.bs.nrows[i], 0, ncol())) return out;
	}
	out.writeStop();
	return(out);
}


/*	
		v.resize(out.bs.nrows[i] * ncol());
		for (size_t j = 0; j < v.size(); j++) {
			double z = 0;
			int n = 0;
			fv.resize(0);
			for (int k = 0; k < ww; k++) {
				int m = j * ww + k;
				if (std::isnan(f[m])) {
					if (!narm) {
						z = NAN;
						n = 0;
						break;
					}
				} else {
					if (wmat) {
						z = z + f[m] * w[n];
					} else {
						fv.push_back(f[m]);
					}
					n++;
				}
			}
			if (n > 0) {
				if (!wmat) {
					v[j] = z / n;
				} else {
					if (fv.size() == 0) {
						v[j] = NAN;
					} else if (fun == "mean") { //mean
						v[j] = std::accumulate(fv.begin(), fv.end(), 0.0) / fv.size();
					} else if (fun == "min") { //min
						v[j] = *std::min_element(fv.begin(), fv.end());
					} else if (fun == "max") { //max
						v[j] = *std::max_element(fv.begin(), fv.end());
					} else { // sum
						v[j] = std::accumulate(fv.begin(), fv.end(), 0.0);
					}
				}
			} else {
				v[j] = NAN;
			}
		}
		if (!out.writeValues(v, out.bs.row[i], out.bs.nrows[i], 0, ncol())) return out;

	}
	readStop();
	out.writeStop();
	return(out);
}

*/