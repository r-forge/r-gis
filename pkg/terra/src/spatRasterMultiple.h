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


// A class for any collection of SpatRasters 
class SpatRasterCollection {
	public:
		SpatMessages msg;
		void setError(std::string s) { msg.setError(s); }
		void addWarning(std::string s) { msg.addWarning(s); }
		bool hasError() { return msg.has_error; }
		bool hasWarning() { return msg.has_warning; }
	
		std::vector<SpatRaster> x;
		SpatRasterCollection() {};
		SpatRasterCollection(size_t n) { x.resize(n); };
		size_t size() { return x.size(); }
		void resize(size_t n) { x.resize(n); }
		void push_back(SpatRaster r) { x.push_back(r); };

		SpatRaster merge(SpatOptions &opt);
		SpatRaster moscaic(SpatOptions &opt);

};

// A class for "sub-datasets" 
class SpatRasterStack {
	public:
		SpatMessages msg;
		void setError(std::string s) { msg.setError(s); }
		void addWarning(std::string s) { msg.addWarning(s); }
		bool hasError() { return msg.has_error; }
		bool hasWarning() { return msg.has_warning; }

		std::vector<SpatRaster> ds;
		std::vector<std::string> names;
		bool oneRes = true;
		SpatRasterStack() {};
		SpatRasterStack(std::string fname);
		SpatRasterStack(SpatRaster r, std::string name) { push_back(r, name); };

		std::vector<std::string> getnames() {
			return names;
		};
		void setnames(std::vector<std::string> nms) {
			if (nms.size() == ds.size()) {
				// make_unique
				names = nms;
			}
		}
	
		unsigned nsds() {
			return ds.size();
		}
		unsigned nrow() {
			if (ds.size() > 0) {
				return ds[0].nrow();
			} else {
				return 0;
			}
		}
		unsigned ncol() {
			if (ds.size() > 0) {
				return ds[0].ncol();
			} else {
				return 0;
			}
		}
		std::string getSRS(std::string s) {
			if (ds.size() > 0) {
				return ds[0].getSRS(s);
			} else {
				return "";
			}
		}
		
		bool push_back(SpatRaster r, std::string name) { 
			if (ds.size() > 0) {
//				if (!ds[0].compare_geom(r, false, false, true, true, true, false)) {
				if (!ds[0].compare_geom(r, false, false, true, true, false, false)) {
					return false;
				}
				if (oneRes && ((ds[0].nrow() != r.nrow()) || (ds[0].ncol() != r.ncol()))) {
					oneRes = false;
				}
			}
			ds.push_back(r); 
			names.push_back(name); 
			return true;
		};
		void resize(size_t n) { 
			if (n < ds.size()) {
				ds.resize(n); 
			}
		}
		SpatRaster getsds(size_t i) {
			if (i < ds.size()) {
				return(ds[i]); 
			} else {
				SpatRaster out;
				out.setError("invalid index");
				return out;
			}
		}
		SpatRasterStack subset(std::vector<unsigned> x) {
			SpatRasterStack out;
			for (size_t i=0; i<x.size(); i++) {
				if (x[i] < ds.size()) {
					out.push_back(ds[x[i]], names[x[i]]);
				} 				
			} 
			if (!oneRes) {
				for (size_t i=1; i<out.ds.size(); i++) {
					if ((out.ds[0].nrow() != out.ds[i].nrow()) || (out.ds[0].ncol() != out.ds[i].ncol())) {
						oneRes = false;
						break;
					}
				}
			}
			return out;
		}
		
		void replace(unsigned i, SpatRaster x) {
			if (i > (ds.size()-1)) {
				setError("invalid index");
				return;				
			}
			if (ds.size() == 0) {
				setError("cannot replace on empty stack");
				return;
			}
			if (!ds[0].compare_geom(x, false, false, true, true, false, false)) {
				setError("extent does not match");
				return;
			}
			
			if (oneRes && ((ds[0].nrow() != x.nrow()) || (ds[0].ncol() != x.ncol()))) {
				oneRes = false;
				addWarning("resolution of new data is different from other sub-datasets");
			}

			ds[i] = x;
		}
		
		SpatRaster collapse() {
			SpatRaster out;

			if (!oneRes) {
				out.setError("cannot collapse sub-datasources with different resolutions");
			}
			if (ds.size() > 0) {
				out = ds[0];
				for (size_t i=1; i<ds.size(); i++) {
					for (size_t j=0; j<ds[i].source.size(); j++) {
						out.source.push_back(ds[i].source[j]);
					}
				}
				return out;
			} else {
				out.setError("nothing to collapse");
				return out;
			}
		}
};

