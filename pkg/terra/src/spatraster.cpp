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
#include "string_utils.h"
#include "file_utils.h"
#include "time.h"
#include "recycle.h"

#include <set>

#ifdef useGDAL
#include "crs.h"
#endif


SpatRaster::SpatRaster(std::string fname, std::vector<int> subds, std::vector<std::string> subdsname) {
#ifdef useGDAL
	constructFromFile(fname, subds, subdsname);
#endif
}


SpatRaster::SpatRaster(std::vector<std::string> fname, std::vector<int> subds, std::vector<std::string> subdsname, std::string x) {
// argument "x" is ignored. It is only there to have four arguments such that the Rcpp module
// can distinguish this constructor from another with three arguments. 
#ifdef useGDAL
	constructFromFile(fname[0], subds, subdsname);
	for (size_t i=1; i<fname.size(); i++) {
		SpatRaster r;
		bool ok = r.constructFromFile(fname[i], subds, subdsname);
		if (ok) {
			addSource(r);
			if (r.msg.has_error) {
				setError(r.msg.error);
				return;
			}
		} else {
			if (r.msg.has_error) {
				setError(r.msg.error);
			}
			return;
		}
	}
#endif
}


void SpatRaster::setSources(std::vector<SpatRasterSource> s) {
	source = s;
//	extent = s[0].extent;
//	srs = s[0].srs;
}


void SpatRaster::setSource(SpatRasterSource s) {
	s.resize(s.nlyr);
	std::vector<SpatRasterSource> vs = {s};
	setSources(vs);
}


SpatRaster::SpatRaster(SpatRasterSource s) {
	std::vector<SpatRasterSource> vs = {s};
	setSources(vs);
}


SpatRaster::SpatRaster() {

	SpatRasterSource s;
	s.nrow = 10;
	s.ncol = 10;
	s.extent = SpatExtent();
	s.memory = true;
	s.filename = "";
	//s.driver = "";
	s.nlyr = 1; // or 0?
	s.resize(1);

	s.hasRange = { false };
	s.hasValues = false;
	s.layers.resize(1, 0);
	s.datatype = "";
	s.names = {"lyr.1"};
	s.srs.proj4 = "+proj=longlat +datum=WGS84";
	s.srs.wkt = "GEOGCS[\"WGS 84\", DATUM[\"WGS_1984\", SPHEROID[\"WGS 84\",6378137,298.257223563]], PRIMEM[\"Greenwich\",0], UNIT[\"degree\",0.0174532925199433]]";
	setSource(s);
}



SpatRaster::SpatRaster(std::vector<unsigned> rcl, std::vector<double> ext, std::string crs) {

	SpatRasterSource s;
	s.nrow=rcl[0];
	s.ncol=rcl[1];
	s.extent.xmin = ext[0];
	s.extent.xmax = ext[1];
	s.extent.ymin = ext[2];
	s.extent.ymax = ext[3];
	s.hasValues = false;
	s.hasRange = {false};

	s.memory = true;
	s.filename = "";
	//s.driver = "";
	s.nlyr = rcl[2];
	s.layers.resize(1, 0);
	//s.layers.resize(1, s.nlyr);
	//std::iota(s.layers.begin(), s.layers.end(), 0);

	s.datatype = "";

#ifdef useGDAL
	std::string msg;
	if (!s.srs.set( crs, msg )) {
		setError(msg);
		return;
	}
#else
	s.srs.proj4 = lrtrim_copy(crs);
#endif

	for (unsigned i=0; i < rcl[2]; i++) {
		s.names.push_back("lyr." + std::to_string(i+1)) ;
	}

	setSource(s);
}



SpatRaster::SpatRaster(unsigned nr, unsigned nc, unsigned nl, SpatExtent ext, std::string crs) {

	SpatRasterSource s;
	s.nrow = nr;
	s.ncol = nc;
	s.extent = ext;
	s.hasValues = false;
	s.memory = true;
	s.filename = "";
	//s.driver = "";
	s.nlyr = nl;
	s.hasRange = { false };
	s.layers.resize(1, 0);
	//s.layers.resize(1, _nlyr);
	//std::iota(s.layers.begin(), s.layers.end(), 0);
	s.datatype = "";
#ifdef useGDAL
	std::string msg;
	if (!s.srs.set(crs, msg )) {
		setError(msg);
		return;
	}
#else
	s.srs.proj4 = lrtrim_copy(crs);
#endif
	for (unsigned i=0; i < nl; i++) {
		s.names.push_back("lyr." + std::to_string(i+1)) ;
	}
	setSource(s);
}


/*
SpatRaster::SpatRaster(const SpatRaster &r) {
	source.nrow = r.nrow;
	source.ncol = r.ncol;
	source.extent = r.extent;
	source.crs = r.crs;
	source.memory = true;
	nlyrs = (nlyrs < 1) ? nlyr(): nlyrs;
	source.resize(nlyrs);
	source.values.resize(0);

	std::vector<std::string> nms(s.nlyr);
	for (size_t i=0; i < s.nlyr; i++) { nms[i] = "lyr" + std::to_string(i+1); }
	source.names = nms;
	// would still need "setSource" to set
}
*/



SpatRaster SpatRaster::geometry(long nlyrs, bool properties) {
	SpatRasterSource s;
	//s.values.resize(0);
	s.nrow = nrow();
	s.ncol = ncol();
	s.extent = getExtent();
	s.srs = source[0].srs;
	//s.prj = prj;
	s.memory = true;
	s.hasValues = false;
	long nl = nlyr();
	bool keepnlyr = ((nlyrs == nl) | (nlyrs < 1));
	nlyrs = (keepnlyr) ? nlyr(): nlyrs;
	if (properties) {
		s.hasColors = hasColors();
		s.cols = getColors();
		s.hasCategories = hasCategories();
		s.cats = getCategories();
	}
	s.resize(nlyrs);
	std::vector<std::string> nms;
	if (keepnlyr) {
		nms = getNames();
		if (hasTime()) {
			s.time = getTime();
		}
	} else {
		for (size_t i=0; i < s.nlyr; i++) {
			nms.push_back("lyr" + std::to_string(i+1));
		}
	}
	s.names = nms;
	SpatRaster out(s);
	return out;
}


SpatRaster SpatRaster::deepCopy() {
	SpatRaster out = *this;
	return out;
}



std::vector<double> SpatRaster::resolution() {
	SpatExtent extent = getExtent();
	return std::vector<double> { (extent.xmax - extent.xmin) / ncol(), (extent.ymax - extent.ymin) / nrow() };
}


SpatRaster SpatRaster::setResolution(double xres, double yres) {
	SpatRaster out;

	if ((xres <= 0) | (yres <= 0)) {
		out.setError("resolution must be larger than 0");
		return(out);
	}
	SpatExtent e = getExtent();
	unsigned nc = ceil((e.xmax-e.xmin) / xres);
	unsigned nr = ceil((e.ymax-e.ymin) / yres);
	double xmax = e.xmin + nc * xres;
	double ymax = e.ymin + nr * yres;
	unsigned nl = nlyr();
	std::vector<unsigned> rcl = {nr, nc, nl};
	std::vector<double> ext = {e.xmin, xmax, e.ymin, ymax};

	out = SpatRaster(rcl, ext, {""});
	out.source[0].srs = source[0].srs;
	return out;
}


size_t SpatRaster::ncol() {
	if (source.size() > 0) {
		return source[0].ncol;
	} else {
		return 0;
	}
}

size_t SpatRaster::nrow() {
	if (source.size() > 0) {
		return source[0].nrow;
	} else {
		return 0;
	}
}


unsigned SpatRaster::nlyr() {
	unsigned x = 0;
	for (size_t i=0; i<source.size(); i++) {
		x += source[i].nlyr;
	}
	return(x);
}

std::vector<std::string> SpatRaster::filenames() {
	std::vector<std::string> x(source.size());
	for (size_t i=0; i<x.size(); i++) { x[i] = source[i].filename; }
	return(x);
}

std::vector<bool> SpatRaster::inMemory() {
	std::vector<bool> m(source.size());
	for (size_t i=0; i<m.size(); i++) { m[i] = source[i].memory; }
	return(m);
}

std::vector<bool> SpatRaster::hasRange() {
	std::vector<bool> x;
	for (size_t i=0; i<source.size(); i++) {
		x.insert(x.end(), source[i].hasRange.begin(), source[i].hasRange.end());
	}
	return(x);
}

std::vector<double> SpatRaster::range_min() {
	std::vector<double> x;
	for (size_t i=0; i<source.size(); i++) {
		x.insert(x.end(), source[i].range_min.begin(), source[i].range_min.end());
	}
	return(x);
}

std::vector<double> SpatRaster::range_max() {
	std::vector<double> x;
	for (size_t i=0; i<source.size(); i++) {
		x.insert(x.end(), source[i].range_max.begin(), source[i].range_max.end());
	}
	return(x);
}

bool SpatRaster::is_lonlat() {
	return source[0].srs.is_lonlat();
}


bool SpatRaster::is_geographic() {
	return source[0].srs.is_geographic();
}

bool SpatRaster::could_be_lonlat() {
	if (is_geographic()) return true;
	SpatExtent e = getExtent();
	return source[0].srs.could_be_lonlat(e);
}


bool SpatRaster::is_global_lonlat() {
	SpatExtent e = getExtent();
	return source[0].srs.is_global_lonlat(e);
}


bool SpatRaster::sources_from_file() {
	for (size_t i=0; i<source.size(); i++) {
		if (!source[i].memory) {
			return true;
		}
	}
	return false;
}


SpatRaster SpatRaster::sources_to_disk(std::vector<std::string> &tmpfs, bool unique, SpatOptions &opt) {
// if a tool needs to read from disk, perhaps from unique filenames
// use writeRaster to write to a single file.
	SpatRaster out;
	size_t nsrc = source.size();
	std::set<std::string> ufs;
	size_t ufsize = ufs.size();

	std::string tmpbasename = tempFile(opt.get_tempdir(), "_temp_");


	for (size_t i=0; i<nsrc; i++) {
		bool write = false;
		if (!source[i].in_order() || source[i].memory) {
			write = true;
		} else if (unique) {
			ufs.insert(source[i].filename);
			if (ufs.size() == ufsize) {
				write = true;
			} else {
				ufsize++;
			}
		}
		SpatRaster rs(source[i]);
		if (write) {
			std::string fname = tmpbasename + std::to_string(i) + ".tif";
			opt.set_filenames({fname});
			tmpfs.push_back(fname);
			rs = rs.writeRaster(opt);
		}
		if (i == 0) {
			out.setSource(rs.source[0]);
		} else {
			out.addSource(rs);
		}
	}
	return out;
}

bool SpatRaster::setSRS(std::string crs) {
	std::string msg;
	SpatSRS srs;
	if (!srs.set(crs, msg )) {
		addWarning("Cannot set raster SRS: "+ msg);
		return false;
	}
	for (size_t i = 0; i < nsrc(); i++) { 
		source[i].srs = srs; 
		if (!source[i].memory) {
			source[i].parameters_changed = true;
		}
	}
	return true;
}


/*
#ifdef useGDAL
bool SpatRaster::setSRS(OGRSpatialReference *poSRS, std::string &msg) {
	if (!srs.set(poSRS, msg)){
		addWarning("Cannot set raster SRS: "+ msg);
		return false;
	}
	for (size_t i = 0; i < nsrc(); i++) { 
		source[i].srs = srs; 
	}
	return true;			
}
#endif	
*/

std::string  SpatRaster::getSRS(std::string x) {
	return source[0].srs.get(x);
}



std::vector<std::string> SpatRaster::getNames() {
	std::vector<std::string> x;
	for (size_t i=0; i<source.size(); i++) {
		x.insert(x.end(), source[i].names.begin(), source[i].names.end());
	}
	return(x);
}


bool SpatRaster::setNames(std::vector<std::string> names, bool make_valid) {
	if (names.size() == 1) {
		recycle(names, nlyr());
	}

	if (names.size() != nlyr()) {
		return false;
	} else {
		if (make_valid) {
			make_valid_names(names);
			make_unique_names(names);
        }
		size_t begin=0;
        size_t end;
        for (size_t i=0; i<source.size(); i++)	{
            end = begin + source[i].nlyr;
            source[i].names = std::vector<std::string> (names.begin() + begin, names.begin() + end);
            begin = end;
        }
        return true;
	}
}


std::vector<std::string> SpatRaster::getLongSourceNames() {
	std::vector<std::string> x;
	x.reserve(source.size());
	for (size_t i=0; i<source.size(); i++) {
		x.push_back(source[i].source_name_long);
	}
	return(x);
}


bool SpatRaster::setLongSourceNames(std::vector<std::string> names) {
	if (names.size() == 1) {
		for (size_t i=0; i<source.size(); i++)	{
			source[i].source_name_long = names[0];
		}
	} else if (names.size() == nsrc()) {
		for (size_t i=0; i<source.size(); i++)	{
			source[i].source_name_long = names[i];
		}	
	} else {
		return false;
	}
	return true;
}



std::vector<std::string> SpatRaster::getSourceNames() {
	std::vector<std::string> x;
	x.reserve(source.size());
	for (size_t i=0; i<source.size(); i++) {
		x.push_back(source[i].source_name);
	}
	return(x);
}


bool SpatRaster::setSourceNames(std::vector<std::string> names) {
	if (names.size() == 1) {
		for (size_t i=0; i<source.size(); i++)	{
			source[i].source_name = names[0];
		}
	} else if (names.size() == nsrc()) {
		for (size_t i=0; i<source.size(); i++)	{
			source[i].source_name = names[i];
		}	
	} else {
		return false;
	}
	return true;
}


bool SpatRaster::setNAflag(std::vector<double> flag) {
	size_t sz = source.size();
	if (flag.size() == 1) recycle(flag, sz); 
	if (flag.size() != sz) {
		return false;
	}
	double na = NAN;
	for (size_t i=0; i<sz; i++)	{
		if (std::isnan(flag[i])) {
			source[i].hasNAflag = false;
			source[i].NAflag = NAN;
		} else {
		
			if (source[i].memory) {
				source[i].hasNAflag = false;
				std::replace(source[i].values.begin(), source[i].values.end(), flag[i], na);
				source[i].setRange();
			} else {
				source[i].hasNAflag = true;
				source[i].NAflag = flag[i];
			}
		}
	}
	return true;
};


std::vector<double> SpatRaster::getNAflag() {
	std::vector<double> out(source.size(), NAN);
	for (size_t i=0; i<source.size(); i++)	{
		if (source[i].hasNAflag) {
			out[i] = source[i].NAflag;
		}
	}
	return out;
}


bool SpatRaster::hasTime() {
	bool test = true;
	for (size_t i=0; i<source.size(); i++) {
		test = test & source[i].hasTime; 
	}
	return(test);
}

/*
std::vector<double> SpatRaster::getTimeDbl() {
	std::vector<int_64> t64 = getTime();
	std::vector<double> out(t64.size());
	for (size_t i=0; i < out.size(); i++) {
		out[i] = t64[i];
	}
	return out;
}
*/

std::vector<std::string> SpatRaster::getTimeStr() {
	std::vector<std::string> out;
	if (source[0].timestep == "seconds") {
		std::vector<int_64> time = getTime();
		out.reserve(time.size());
		for (size_t i=0; i < out.size(); i++) {
			std::vector<int> x = get_date(time[i]);
			if (x.size() > 2) {
				out.push_back( std::to_string(x[0]) + "-" 
						  + std::to_string(x[1]) + "-"
						  + std::to_string(x[2]) );
						  
			} else {
				out.push_back("");
			}
		}
	} 
	return out;
}


std::vector<int_64> SpatRaster::getTime() {
	std::vector<int_64> x;
	for (size_t i=0; i<source.size(); i++) {
		if (source[i].time.size() != source[i].nlyr) {
			std::vector<double> nas(source[i].nlyr, 0);
			x.insert(x.end(), nas.begin(), nas.end());		
		} else {
			x.insert(x.end(), source[i].time.begin(), source[i].time.end());
		}
	}
	return(x);
}

std::string SpatRaster::getTimeStep() {
	return source[0].timestep;
}

bool SpatRaster::setTime(std::vector<int_64> time, std::string step) {
	if (time.size() != nlyr()) {
		return false;
	} 
	if (!(step == "seconds") || (step == "raw")) {  // "days", "months", "years"
		return false;
	} 
	size_t begin=0;
	for (size_t i=0; i<source.size(); i++)	{
		size_t end = begin + source[i].nlyr;
        source[i].time = std::vector<int_64> (time.begin() + begin, time.begin() + end);
		source[i].timestep = step;
		source[i].hasTime = true;
        begin = end;
    }

    return true;
}


std::vector<double> SpatRaster::getDepth() {
	std::vector<double> x;
	for (size_t i=0; i<source.size(); i++) {
		if (source[i].depth.size() != source[i].nlyr) {
			std::vector<double> nas(source[i].nlyr, NAN);
			x.insert(x.end(), nas.begin(), nas.end());		
		} else {
			x.insert(x.end(), source[i].depth.begin(), source[i].depth.end());
		}
	}
	return(x);
}



bool SpatRaster::setDepth(std::vector<double> depths) {
	if (depths.size() == 1) {
        for (size_t i=0; i<source.size(); i++)	{
            source[i].depth = std::vector<double> (source[i].nlyr, depths[0]);
        }
        return true;
	} else if (depths.size() != nlyr()) {
		return false;
	} else {
        size_t begin=0;
        for (size_t i=0; i<source.size(); i++)	{
            size_t end = begin + source[i].nlyr;
            source[i].depth = std::vector<double> (depths.begin() + begin, depths.begin() + end);
            begin = end;
        }
        return true;
	}
}



bool SpatRaster::setUnit(std::vector<std::string> units) {
	if (units.size() == 1) {
        for (size_t i=0; i<source.size(); i++)	{
            source[i].unit = std::vector<std::string> (source[i].nlyr, units[0]);
        }
        return true;
	} else if (units.size() != nlyr()) {
		return false;
	} else {
        size_t begin=0;
        for (size_t i=0; i<source.size(); i++)	{
            size_t end = begin + source[i].nlyr;
            source[i].unit = std::vector<std::string> (units.begin() + begin, units.begin() + end);
            begin = end;
        }
        return true;
	}
}


std::vector<std::string> SpatRaster::getUnit() {
	std::vector<std::string> x;
	for (size_t i=0; i<source.size(); i++) {
		if (source[i].unit.size() != source[i].nlyr) {
			std::vector<std::string> nas(source[i].nlyr, "");
			x.insert(x.end(), nas.begin(), nas.end());		
		} else {
			x.insert(x.end(), source[i].unit.begin(), source[i].unit.end());
		}
	}
	return(x);
}




double SpatRaster::xres() {
	SpatExtent extent = getExtent();
	return (extent.xmax - extent.xmin) / ncol() ;
}

double SpatRaster::yres() { 
	SpatExtent extent = getExtent();
	return (extent.ymax - extent.ymin) / nrow() ;
}


bool SpatRaster::valid_sources(bool files, bool rotated) {
	std::vector<std::string> ff;
	for (size_t i=0; i<source.size(); i++) { 
		std::string f = source[i].filename; 
		if (f == "") continue;
		if (files) {
			std::size_t found = f.find(":"); // perhaps http: or PG:xxx
			if ((found == 1) || (found == std::string::npos)) {
				if (!file_exists(f)) {
					setError("missing source: " + f);
					return false;
				}
			}
		}
		if (rotated) {
			if (source[i].rotated) {
				setError(f + " is rotated");
				return false;
			}
		}
	}
	return true;
}

std::vector<bool> SpatRaster::hasWindow() {
	std::vector<bool> out;
	out.reserve(nlyr());
	for (size_t i=0; i<nsrc(); i++) {
		for (size_t j=0; j<source[i].nlyr; j++) {
			out.push_back(source[i].hasWindow);
		}
	}
	return out;
}


bool SpatRaster::removeWindow() {
	for (size_t i=0; i<nsrc(); i++) {
		if (source[i].hasWindow) {
			SpatExtent e = source[0].window.full_extent;
			setExtent(e, true, "");
			for (size_t i=0; i<source.size(); i++) {
				source[i].hasWindow = false;
				source[i].nrow = source[0].window.full_nrow;
				source[i].ncol = source[0].window.full_ncol;
			}
		}
	}
	return true;
}


bool SpatRaster::setWindow(SpatExtent x) {

	if ( !x.valid() ) {
		setError("invalid extent");
		return false;
	} 

	removeWindow();
	x = align(x, "near");
	SpatExtent e = getExtent();
	if (x.compare(e, "==", 0.1 * xres())) {
		return true;
	}

	e.intersect(x);
	if ( !e.valid() ) {
		setError("extents do not overlap");
		return false;
	} 

// get read-window
	double xr = xres();
	double yr = yres();

	bool expand = false;
	std::vector<size_t> rc(2);
	std::vector<size_t> exp(4, 0);

	int_64 r = rowFromY(x.ymax - 0.5 * yr);
	if (r < 0) {
		rc[0] = 0;
		expand = true;
		exp[0] = trunc(abs(e.ymax - x.ymax) / yr);
	} else {
		rc[0] = r;
	}
	r = rowFromY(x.ymin + 0.5 * yr);
	if (r < 0) {
		expand = true;
		exp[1] = trunc((e.ymax - x.ymin) / yr);
	}

	r = colFromX(x.xmin + 0.5 * xr);
	if (r < 0) {
		rc[1] = 0;
		expand = true;
		exp[2] = trunc((x.xmin - e.xmin) / xres());
	} else {
		rc[1] = r;
	}
	r = colFromX(x.xmax - 0.5 * xr);
	if (r < 0) {
		expand = true;
		exp[3] = trunc(abs(x.xmin - e.xmin) / xres());
	} 

	if (expand) {
		setError("expansion is not yet allowed");
		return false;
	}

	for (size_t i=0; i<source.size(); i++) {
		source[i].window.off_row = rc[0];
		source[i].window.off_col = rc[1];
		source[i].window.expand = exp;
		source[i].window.expanded  = expand;
		source[i].window.full_extent = getExtent();
		source[i].window.full_nrow   = source[i].nrow;
		source[i].window.full_ncol   = source[i].ncol;
		source[i].hasWindow     = true;
	}
	setExtent(x, true, "");	

	return true;
}

SpatRaster SpatRaster::replace(SpatRaster x, unsigned layer, SpatOptions &opt) {

	SpatRaster out = geometry();
	if (!out.compare_geom(x, false, true)) {
		return(out);
	}
	SpatOptions fopt(opt);

	size_t n = nlyr();
	if (n == 1) {
		return x;
	}
	std::vector<unsigned> lyrs;
	if (layer == 0) {
		out = x;
		lyrs.resize(n-1);
		std::iota(lyrs.begin(), lyrs.end(), 1);
		SpatRaster r = subset(lyrs, fopt);
		out.addSource(r);
	} else if (layer == n-1) {
		lyrs.resize(n-1);
		std::iota(lyrs.begin(), lyrs.end(), 0);
		out = subset(lyrs, fopt);
		out.addSource(x);
	} else {
		lyrs.resize(layer);
		std::iota(lyrs.begin(), lyrs.end(), 0);
		out = subset(lyrs, fopt);
		out.addSource(x);
		lyrs.resize(n-layer-1);
		std::iota(lyrs.begin(), lyrs.end(), layer+1);
		SpatRaster r = subset(lyrs, fopt);
		out.addSource(r);
	}
	return out;
}


SpatRaster SpatRaster::makeCategorical(unsigned layer, SpatOptions opt) {

	if (!hasValues()) {
		SpatRaster out;
		out.setError("cannot make categries if the raster has no values");
		return out;
	}

	std::vector<unsigned> lyrs = {layer};
	SpatOptions fopt(opt);
	SpatRaster r = subset(lyrs, fopt);

	r.math2("round", 0, fopt);

	std::vector<std::vector<double>> u = r.unique(false, fopt);

	std::vector<double> id(u[0].size());
	std::iota(id.begin(), id.end(), 0);
	std::vector<std::vector<double>> rcl(2);
	rcl[0] = u[0];
	rcl[1] = id;
	r = r.reclassify(rcl, true, true, true, fopt);

	std::vector<std::string> s(id.size());
	for (size_t i=0; i<s.size(); i++) {
		s[i] = std::to_string((int)u[0][i]);
	}
	r.setCategories(0, id, s);

	if (nlyr() == 1) {
		return r;
	} else {
		return replace(r, layer, opt);
	}
}



bool SpatRaster::createCategories(unsigned layer) {
	if (layer > (nlyr()-1)) { 
		setError("invalid layer number");
		return(false);
	}
	SpatOptions opt;
	std::vector<unsigned> lyrs(1, layer);
	SpatRaster r = subset(lyrs, opt);
	std::vector<std::vector<double>> u = r.unique(false, opt);
    std::vector<unsigned> sl = findLyr(layer);

	std::vector<std::string> s(u[0].size());
	for (size_t i=0; i<s.size(); i++) {
		s[i] = std::to_string(i+1);
	}

	//std::transform(u[0].begin(), u[0].end(), s.begin(), [](const double& d) {
	//	return std::to_string(d);
	//});
	source[sl[0]].cats[sl[1]].levels = u[0];
	source[sl[0]].cats[sl[1]].labels = s;
	source[sl[0]].hasCategories[sl[1]] = true;
	return true;
}


std::vector<bool> SpatRaster::hasCategories() {
	std::vector<bool> b(nlyr());
	std::vector<unsigned> ns = nlyrBySource();
	unsigned k = 0;
	for (size_t i=0; i<source.size(); i++) {
		for (size_t j=0; j<ns[i]; j++) {
			b[k] = source[i].hasCategories[j];
			k++;
		}
	}
	return b;
}



bool SpatRaster::setCategories(unsigned layer, std::vector<double> levels, std::vector<std::string> labels) {

	if (layer > (nlyr()-1)) { 
		setError("invalid layer number");
		return(false);
	}

    std::vector<unsigned> sl = findLyr(layer);
	//if (!source[sl[0]].hasCategories[sl[1]]) {
	//	SpatOptions opt;
	//	SpatRaster out = makeCategorical(layer, opt);
	//	source = out.source;
	//}

	if (levels.size() == 0) {
		if (labels.size() == source[sl[0]].cats[sl[1]].levels.size()) {
			source[sl[0]].cats[sl[1]].labels = labels;
		} else {
			setError("length of labels does not match number of categories");
		} 
	} else {
		if (source[sl[0]].cats.size() < sl[1]) {
			source[sl[0]].cats.resize(sl[1]);
		}
		SpatCategories s;
		s.labels = labels;
		recycle(labels, levels.size());
		s.levels = levels;
		source[sl[0]].cats[sl[1]] = s;
		source[sl[0]].hasCategories[sl[1]] = true;
	}
	return true;
}


bool SpatRaster::removeCategories(unsigned layer) {
	if (layer > (nlyr()-1)) { 
		setError("invalid layer number");
		return(false);
	}
    std::vector<unsigned> sl = findLyr(layer);
	SpatCategories s;
	source[sl[0]].cats[sl[1]] = s;
	source[sl[0]].hasCategories[sl[1]] = false;
	return true;
}

SpatCategories SpatRaster::getLayerCategories(unsigned layer) {
    std::vector<unsigned> sl = findLyr(layer);
	SpatCategories cat = source[sl[0]].cats[sl[1]];
	return cat;
}

std::vector<SpatCategories> SpatRaster::getCategories() {
	std::vector<SpatCategories> cats;
	for (size_t i=0; i<source.size(); i++) {
		cats.insert(cats.end(), source[i].cats.begin(), source[i].cats.end());
	}
	return cats;
}




void SpatRaster::createAttributes(unsigned layer) {
	// subset to layer
	SpatOptions opt;
	std::vector<unsigned> lyrs(1, layer);
	SpatRaster r = subset(lyrs, opt);
	std::vector<std::vector<double>> u = r.unique(false, opt);
    std::vector<unsigned> sl = findLyr(layer);
	SpatDataFrame df;
	std::string name = "ID";
	df.add_column(u[0], name);			

	source[sl[0]].atts[sl[1]] = df;
	source[sl[0]].hasAttributes[sl[1]] = true;
}


std::vector<bool> SpatRaster::hasAttributes() {
	std::vector<bool> b(nlyr());
	std::vector<unsigned> ns = nlyrBySource();
	unsigned k = 0;
	for (size_t i=0; i<source.size(); i++) {
		for (size_t j=0; j<ns[i]; j++) {
			b[k] = source[i].hasAttributes[j];
			k++;
		}
	}
	return b;
}



void SpatRaster::setAttributes(unsigned layer, SpatDataFrame df) {
    std::vector<unsigned> sl = findLyr(layer);
	if (source[sl[0]].atts.size() < (sl[1]+1)) {
		source[sl[0]].atts.resize(sl[1]+1);
	}
	if (source[sl[0]].hasAttributes.size() < (sl[1]+1)) {
		source[sl[0]].hasAttributes.resize(sl[1]+1);
	}
	source[sl[0]].atts[sl[1]] = df;
	source[sl[0]].hasAttributes[sl[1]] = true;
}


SpatDataFrame SpatRaster::getLayerAttributes(unsigned layer) {
    std::vector<unsigned> sl = findLyr(layer);
	SpatDataFrame att = source[sl[0]].atts[sl[1]];
	return att;
}

std::vector<SpatDataFrame> SpatRaster::getAttributes() {
	std::vector<SpatDataFrame> atts;
	for (size_t i=0; i<source.size(); i++) {
		atts.insert(atts.end(), source[i].atts.begin(), source[i].atts.end());
	}
	return atts;
}


std::vector<SpatDataFrame> SpatRaster::getColors() {
	std::vector<SpatDataFrame> cols;
	for (size_t i=0; i<source.size(); i++) {
		cols.insert(cols.end(), source[i].cols.begin(), source[i].cols.end());
	}
	return cols;
}



bool SpatRaster::setColors(size_t layer, SpatDataFrame cols) {
	if (cols.ncol() < 3 || cols.ncol() > 4) {
		return false;
	}
	if (cols.nrow() != 256) {
		return false;
	}
	if (layer >= nlyr()) {
		return false;
	}
	if (cols.ncol() == 3) {
		std::vector<long> a(cols.nrow(), 255);
		cols.add_column(a, "alpha");
	}

    std::vector<unsigned> sl = findLyr(layer);
	if (source[sl[0]].cols.size() < (sl[1]+1)) {
		source[sl[0]].cols.resize(sl[1]+1);
	}
	if (source[sl[0]].hasColors.size() < (sl[1]+1)) {
		source[sl[0]].hasColors.resize(sl[1]+1);
	}

	source[sl[0]].cols[sl[1]] = cols;
	source[sl[0]].hasColors[sl[1]] = (cols.nrow() > 1);
	return true;
}



std::vector<bool> SpatRaster::hasColors() {
	std::vector<bool> b(nlyr());
	std::vector<unsigned> ns = nlyrBySource();
	unsigned k = 0;
	for (size_t i=0; i<source.size(); i++) {
		for (size_t j=0; j<ns[i]; j++) {
			b[k] = source[i].hasColors[j];
			k++;
		}
	}
	return b;
}


std::vector<double> SpatRaster::cellFromXY (std::vector<double> x, std::vector<double> y) {
// size of x and y should be the same

	size_t size = x.size();
	std::vector<double> cells(size);

	SpatExtent extent = getExtent();
	double yr_inv = nrow() / (extent.ymax - extent.ymin);
	double xr_inv = ncol() / (extent.xmax - extent.xmin);

	for (size_t i = 0; i < size; i++) {
		// cannot use trunc here because trunc(-0.1) == 0
		long row = std::floor((extent.ymax - y[i]) * yr_inv);
		// points in between rows go to the row below
		// except for the last row, when they must go up
		if (y[i] == extent.ymin) {
			row = nrow()-1 ;
		}

		long col = std::floor((x[i] - extent.xmin) * xr_inv);
		// as for rows above. Go right, except for last column
		if (x[i] == extent.xmax) {
			col = ncol() - 1 ;
		}
		long nr = nrow();
		long nc = ncol();
		if (row < 0 || row >= nr || col < 0 || col >= nc) {
			cells[i] = NAN;
		} else {
			cells[i] = row * ncol() + col;
		}
	}

	return cells;
}


double SpatRaster::cellFromXY (double x, double y) {
	std::vector<double> X = {x};
	std::vector<double> Y = {y};
	std::vector<double> cell = cellFromXY(X, Y);
	return  cell[0];
}


std::vector<double> SpatRaster::cellFromRowCol(std::vector<int_64> row, std::vector<int_64> col) {
	recycle(row, col);
	size_t n = row.size();
	std::vector<double> result(n);
	int_64 nr = nrow();
	int_64 nc = ncol();
	for (size_t i=0; i<n; i++) {
		result[i] = (row[i]<0 || row[i] >= nr || col[i]<0 || col[i] >= nc) ? NAN : row[i] * nc + col[i];
	}
	return result;
}


double SpatRaster::cellFromRowCol (int_64 row, int_64 col) {
	std::vector<int_64> rows = {row};
	std::vector<int_64> cols = {col};
	std::vector<double> cell = cellFromRowCol(rows, cols);
	return  cell[0];
}

std::vector<double> SpatRaster::cellFromRowColCombine(std::vector<int_64> row, std::vector<int_64> col) {
	recycle(row, col);
	size_t n = row.size();
	int_64 nc = ncol();
	int_64 nr = nrow();

	std::vector<double> x(n * n);
	for (size_t i=0; i<n; i++) {
		for (size_t j=0; j<n; j++) {
			x[i*n+j] = (row[i]<0 || row[i] >= nr || col[j]<0 || col[j] >= nc) ? NAN : row[i] * nc + col[j];
		}
	}
	// duplicates occur if recycling occurs
	// could be avoided by smarter combination
	x.erase(std::remove_if(x.begin(), x.end(),
            [](const double& value) { return std::isnan(value); }), x.end());

	std::sort(x.begin(), x.end());
	x.erase(std::unique(x.begin(), x.end()), x.end());
	return x;
}


double SpatRaster::cellFromRowColCombine(int_64 row, int_64 col) {
	return cellFromRowCol(row, col);
}


std::vector<double> SpatRaster::yFromRow(std::vector<int_64> &row) {
	size_t size = row.size();
	std::vector<double> result( size );
	SpatExtent extent = getExtent();
	double ymax = extent.ymax;
	double yr = yres();
	int_64 nr = nrow();

	for (size_t i = 0; i < size; i++) {
		result[i] = (row[i] < 0 || row[i] >= nr ) ? NAN : ymax - ((row[i]+0.5) * yr);
	}
	return result;
}

double SpatRaster::yFromRow (int_64 row) {
	std::vector<int_64> rows = {row};
	std::vector<double> y = yFromRow(rows);
	return y[0];
}



std::vector<double> SpatRaster::xFromCol(std::vector<int_64> &col) {
	size_t size = col.size();
	std::vector<double> result( size );
	SpatExtent extent = getExtent();
	double xmin = extent.xmin;
	double xr = xres();
	int_64 nc = ncol();
	for (size_t i = 0; i < size; i++) {
		result[i] = (col[i] < 0 || col[i] >= nc ) ? NAN : xmin + ((col[i]+0.5) * xr);
	}
	return result;
}

double SpatRaster::xFromCol(int_64 col) {
	std::vector<int_64> cols = {col};
	std::vector<double> x = xFromCol(cols);
	return x[0];
}

std::vector<int_64> SpatRaster::colFromX(std::vector<double> &x) {

	SpatExtent extent = getExtent();

	double xmin = extent.xmin;
	double xmax = extent.xmax;
	double xr = xres();
	size_t xs = x.size();
	std::vector<int_64> result(xs, -1);

	for (size_t i = 0; i < xs; i++) {
		if (x[i] >= xmin && x[i] < xmax ) {
			result[i] =  trunc((x[i] - xmin) / xr);
		} else if (x[i] == xmax) {
			result[i] = ncol()-1;
		}
	}
	return result;
}


int_64 SpatRaster::colFromX(double x) {
	std::vector<double> xv = {x};
	return colFromX(xv)[0];
}


std::vector<int_64> SpatRaster::rowFromY(std::vector<double> &y) {

	SpatExtent extent = getExtent();
	double ymin = extent.ymin;
	double ymax = extent.ymax;
	double yr = yres();
	size_t ys = y.size();
	std::vector<int_64> result(ys, -1);

	for (size_t i = 0; i < ys; i++) {
		if (y[i] > ymin && y[i] <= ymax) {
			result[i] = trunc((ymax - y[i]) / yr);
		} else if (y[i] == ymin) {
			result[i] = nrow() - 1;
		}	
	}
	return result;
}


int_64 SpatRaster::rowFromY(double y) {
	std::vector<double> Y = {y};
	return rowFromY(Y)[0];
}


std::vector<std::vector<double>> SpatRaster::xyFromCell( std::vector<double> &cell) {
	size_t n = cell.size();
	SpatExtent extent = getExtent();

	double xmin = extent.xmin;
	double ymax = extent.ymax;
	double yr = yres();
	double xr = xres();
    double ncells = ncell();
    size_t nc = ncol();
	std::vector< std::vector<double> > out(2, std::vector<double> (n, NAN) );
	for (size_t i = 0; i<n; i++) {
		if (std::isnan(cell[i]) || (cell[i] < 0) || (cell[i] >= ncells)) continue;
        size_t row = cell[i] / nc;
        size_t col = cell[i] - (row * nc);
        out[0][i] = xmin + (col + 0.5) * xr;
        out[1][i] = ymax - (row + 0.5) * yr;
	}
	return out;
}


std::vector< std::vector<double>> SpatRaster::xyFromCell( double cell) {
	std::vector<double> vcell = {cell};
	return xyFromCell(vcell);
}


std::vector<std::vector<int_64>> SpatRaster::rowColFromCell(std::vector<double> &cell) {
	size_t cs = cell.size();
	std::vector<std::vector<int_64>> result(2, std::vector<int_64> (cs, -1) );
	double nc = ncell();
	for (size_t i = 0; i < cs; i++) {
		if ((cell[i] >= 0) && (cell[i] < nc )) {
			result[0][i] = trunc(cell[i]/ ncol());
			result[1][i] = (cell[i] - ((result[0][i]) * ncol()));
		}
	}
	return result;
}


std::vector<std::vector<int_64>>  SpatRaster::rowColFromExtent(SpatExtent e) {
	std::vector<std::vector<double>> xy = e.asPoints();
	std::vector<int_64> col = colFromX(xy[0]); 
	std::vector<int_64> row = rowFromY(xy[1]); 
	std::vector<std::vector<int_64>> out = { row, col };
	return out;
}



std::vector<std::vector<double>> SpatRaster::adjacent(std::vector<double> cells, std::string directions, bool include) {

	unsigned n = cells.size();
	std::vector<std::vector<double>> out(n);

	std::vector<std::string> f {"rook", "queen", "bishop", "16"};
	if (std::find(f.begin(), f.end(), directions) == f.end()) {
        setError("argument directions is not valid");
        return(out);
	}

	std::vector<std::vector<int_64>> rc = rowColFromCell(cells);
	std::vector<int_64> r = rc[0];
	std::vector<int_64> c = rc[1];
	bool globlatlon = is_global_lonlat();
    int_64 nc = ncol();
    int_64 lc = nc-1;
    std::vector<int_64> cols, rows;
	if (directions == "rook") {
		for (size_t i=0; i<n; i++) {
			rows = {r[i]-1, r[i]   , r[i]  , r[i]+1};
            cols = {c[i]  , c[i]-1 , c[i]+1, c[i]};
            if (globlatlon) {
                if (c[i]==0) {
                    cols[1] = lc;
                } else if (c[i]==lc) {
                    cols[2] = 0;
                }
            }
            if (include) {
                rows.push_back(r[i]);
                cols.push_back(c[i]);
            }
			out[i] = cellFromRowCol(rows, cols);
			//std::sort(out[i].begin(), out[i].end());
		}
	} else if (directions == "queen") {
		for (size_t i=0; i<n; i++) {
            rows = {r[i]-1, r[i]-1, r[i]-1, r[i], r[i], r[i]+1, r[i]+1, r[i]+1};
            cols = {c[i]-1, c[i], c[i]+1, c[i]-1, c[i]+1, c[i]-1, c[i], c[i]+1};
            if (globlatlon) {
                if (c[i]==0) {
                    cols = {lc, c[i], c[i]+1, lc, c[i]+1, lc, c[i], c[i]+1};
                } else if (c[i]==lc) {
                    cols = {c[i]-1, c[i], 0, c[i]-1, 0, c[i]-1, c[i], 0};
                }
            }
            if (include) {
                rows.push_back(r[i]);
                cols.push_back(c[i]);
            }
			out[i] = cellFromRowCol(rows, cols);
			//std::sort(out[i].begin(), out[i].end());
		}
	} else if (directions == "bishop") {
		for (size_t i=0; i<n; i++) {
            rows = {r[i]-1, r[i]-1, r[i]+1, r[i]+1};
            cols = {c[i]-1, c[i]+1, c[i]-1, c[i]+1};
            if (globlatlon) {
                if (c[i]==0) {
                    cols = {lc, c[i]+1, lc, c[i]+1};
                } else if (c[i]==lc) {
                    cols = {c[i]-1, 0, c[i]-1, 0};
                }
            }
            if (include) {
                rows.push_back(r[i]);
                cols.push_back(c[i]);
            }
			out[i] = cellFromRowCol(rows, cols);
			//std::sort(out[i].begin(), out[i].end());
		}
	} else if (directions == "16") {
		for (size_t i=0; i<n; i++) {
            rows = {r[i]-2, r[i]-2, r[i]-1, r[i]-1, r[i]-1, r[i]-1, r[i]-1, r[i]  , r[i]  , r[i]+1, r[i]+1, r[i]+1, r[i]+1, r[i]+1, r[i]+2, r[i]+2};
            cols = {c[i]-1, c[i]+1, c[i]-2, c[i]-1, c[i],   c[i]+1, c[i]+2, c[i]-1, c[i]+1, c[i]-2, c[i]-1, c[i]  , c[i]+1, c[i]+2, c[i]-1, c[i]+1};
            if (globlatlon) {
                if ((c[i]==0) | (c[i]==1)) {
                    for (size_t j=0; j<16; j++) {
                        cols[j] = (cols[j] < 0) ? nc-cols[j] : cols[j];
                    }
                } else if (c[i]==nc) {
                    for (size_t j=0; j<16; j++) {
                        cols[j] = (cols[j] > lc) ? cols[j]-nc : cols[j];
                    }
                }
            }
            if (include) {
                rows.push_back(r[i]);
                cols.push_back(c[i]);
            }
			out[i] = cellFromRowCol(rows, cols);
			//std::sort(out[i].begin(), out[i].end());
		}
	}
	return(out);
}


SpatVector SpatRaster::as_points(bool values, bool narm, SpatOptions &opt) {

	BlockSize bs = getBlockSize(opt);
	std::vector<double> v, vout;
	vout.reserve(v.size());
	SpatVector pv;
	SpatGeom g;
	g.gtype = points;

    std::vector<std::vector<double>> xy;
	if ((!values) && (!narm)) {
        double nc = ncell();
        for (size_t i=0; i<nc; i++) {
            xy = xyFromCell(i);
			SpatPart p(xy[0], xy[1]);
			g.addPart(p);
			pv.addGeom(g);
			g.parts.resize(0);
        }
		return pv;
	}

	if (values) {
        std::vector<std::string> nms = getNames();
        for (size_t i=0; i<nlyr(); i++) {
            pv.df.add_column(0, nms[i]);
        }
	}
	if (!readStart()) {
		pv.setError(getError());
		return(pv);
	}

	size_t nc = ncol();
	unsigned nl = nlyr();
	for (size_t i = 0; i < bs.n; i++) {
		v = readValues(bs.row[i], bs.nrows[i], 0, nc);
        size_t off1 = (bs.row[i] * nc);
 		size_t vnc = bs.nrows[i] * nc;
		if (narm) {
			for (size_t j=0; j<vnc; j++) {
				bool foundna = false;
				for (size_t lyr=0; lyr<nl; lyr++) {
                    size_t off2 = lyr*nc;
                    if (std::isnan(v[off2+j])) {
                        foundna = true;
                        continue;
                    }
                }
                if (foundna) continue;
                xy = xyFromCell( off1+j );
                SpatPart p(xy[0], xy[1]);
                g.addPart(p);
                pv.addGeom(g);
                g.parts.resize(0);
                if (values) {
                    for (size_t lyr=0; lyr<nl; lyr++) {
                        unsigned off2 = lyr*nc;
                        pv.df.dv[lyr].push_back(v[off2+j]);
                    }
                }
			}
		} else { // if (values) {
			for (size_t j=0; j<vnc; j++) {
                xy = xyFromCell(off1+j);
                SpatPart p(xy[0], xy[1]);
                g.addPart(p);
                pv.addGeom(g);
                g.parts.resize(0);
                for (size_t lyr=0; lyr<nl; lyr++) {
                    unsigned off2 = lyr*nc;
                    pv.df.dv[lyr].push_back(v[off2+j]);
                }
			}
		}
	}
	readStop();
	pv.srs = source[0].srs;
	return(pv);
}





void getCorners(std::vector<double> &x,  std::vector<double> &y, const double &X, const double &Y, const double &xr, const double &yr) {
	x[0] = X - xr;
	y[0] = Y - yr;
	x[1] = X - xr;
	y[1] = Y + yr;
	x[2] = X + xr;
	y[2] = Y + yr;
	x[3] = X + xr;
	y[3] = Y - yr;
	x[4] = x[0];
	y[4] = y[0];
}

/*
SpatVector SpatRaster::as_polygons(bool values, bool narm) {
	if (!values) narm=false;
	SpatVector v;
	SpatGeom g;
	g.gtype = polygons;
	double xr = xres()/2;
	double yr = yres()/2;
	std::vector<double> x(5);
	std::vector<double> y(5);
	if (!values) {
		std::vector<double> cells(ncell()) ;
		std::iota (std::begin(cells), std::end(cells), 0);
		std::vector< std::vector<double> > xy = xyFromCell(cells);
		for (size_t i=0; i<ncell(); i++) {
			getCorners(x, y, xy[0][i], xy[1][i], xr, yr);
			SpatPart p(x, y);
			g.addPart(p);
			v.addGeom(g);
			g.parts.resize(0);
		}
	} else {
		SpatRaster out = geometry();
		unsigned nl = nlyr();
		std::vector<std::vector<double> > att(ncell(), std::vector<double> (nl));

		BlockSize bs = getBlockSize(4);
		std::vector< std::vector<double> > xy;
		std::vector<double> atts(nl);
		for (size_t i=0; i<out.bs.n; i++) {
			std::vector<double> vals = readBlock(out.bs, i);
			unsigned nc=out.bs.nrows[i] * ncol();
			for (size_t j=0; j<nc; j++) {
				for (size_t k=0; k<nl; k++) {
					size_t kk = j + k * nl;
					att[nc+j][k] = vals[kk];
				}
				xy = xyFromCell(nc+j);
				getCorners(x, y, xy[0][0], xy[1][0], xr, yr);
				SpatPart p(x, y);
				g.addPart(p);
				v.addGeom(g);
				g.parts.resize(0);

			}
		}
		SpatDataFrame df;
		std::vector<std::string> nms = getNames();
		for (size_t i=0; i<att.size(); i++) {
			df.add_column(att[i], nms[i]);
		}
	}
	v.setCRS(getCRS());
	return(v);
}

*/

SpatVector SpatRaster::as_polygons(bool trunc, bool dissolve, bool values, bool narm, SpatOptions &opt) {

	if (!hasValues()) {
		values = false;
		narm = false;
		dissolve=false;
	}

	if (dissolve) {
		return polygonize(trunc, opt);
	}

	SpatVector vect;
	opt.ncopies = 12;
	if (!canProcessInMemory(opt)) {
		if (ncell() > 1000000) { // for testing with canPIM=false
			vect.setError("the raster is too large");
			return vect;
		}
	}

	bool remove_values = false;
	if (narm) {
		if (!values) remove_values = true;
		values=true;
	}

	unsigned nl = nlyr();
	unsigned nc = ncell();
	if (values) {
		std::vector<double> v = getValues();
		std::vector<std::string> nms = getNames();
		for (size_t i=0; i<nl; i++) {
			size_t offset = i * nc;
			std::vector<double> vv(v.begin()+offset, v.begin()+offset+nc);
			vect.add_column(vv, nms[i]);
		}
	}


	SpatGeom g;
	g.gtype = polygons;
	double xr = xres()/2;
	double yr = yres()/2;
	std::vector<double> x(5);
	std::vector<double> y(5);

	std::vector<double> cells(ncell()) ;
	std::iota (std::begin(cells), std::end(cells), 0);
	std::vector< std::vector<double> > xy = xyFromCell(cells);
	for (int i=nc-1; i>=0; i--) {
		if (narm) {
			bool erase = false;
			for (size_t j=0; j<nl; j++) {
				if (std::isnan(vect.df.dv[j][i])) {
					erase=true;
					break;
				}
			}
			if (erase) {
				for (size_t j=0; j<nl; j++) {
					vect.df.dv[j].erase (vect.df.dv[j].begin()+i);
				}
				continue; // skip the geom
			}
		}
		getCorners(x, y, xy[0][i], xy[1][i], xr, yr);
		SpatPart p(x, y);
		g.addPart(p);
		vect.addGeom(g);
		g.parts.resize(0);
	}

	std::reverse(std::begin(vect.geoms), std::end(vect.geoms));		

	if (remove_values) {
		vect.df = SpatDataFrame();	
	}
	vect.srs = source[0].srs;
	return(vect);
}



