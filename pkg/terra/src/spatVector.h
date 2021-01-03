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

//#include "spatBase.h"
#include "spatDataframe.h"
//#include "spatMessages.h"

#ifdef useGDAL
#include "gdal_priv.h"
#endif


enum SpatGeomType { points, multipoints, lines, polygons, unknown };


class SpatHole {
	public:
		std::vector<double> x, y;
		SpatExtent extent;
		//constructors
		SpatHole();
		SpatHole(std::vector<double> X, std::vector<double> Y);
		//methods
		size_t size() { return x.size(); }	
};

class SpatPart {
	public:
		std::vector<double> x, y; //, z;
		std::vector< SpatHole > holes; // polygons only
		SpatExtent extent;

		//constructors
		SpatPart();
		SpatPart(std::vector<double> X, std::vector<double> Y);
		SpatPart(double X, double Y);

		//methods
		size_t size() { return x.size(); }
		//holes, polygons only
		bool addHole(std::vector<double> X, std::vector<double> Y);
		bool addHole(SpatHole h);
		SpatHole getHole(unsigned i) { return( holes[i] ) ; }
		bool hasHoles() { return holes.size() > 0;}
		unsigned nHoles() { return holes.size();}
};


class SpatGeom {
	public:
		SpatGeomType gtype = unknown;
		std::vector<SpatPart> parts;
		SpatExtent extent;
		//constructors
		SpatGeom();
		SpatGeom(SpatGeomType g);
		SpatGeom(SpatPart p);
		//methods
		bool unite(SpatGeom g);
		bool addPart(SpatPart p);
		bool addHole(SpatHole h);
		bool setPart(SpatPart p, unsigned i);
		SpatPart getPart(unsigned i);
		double area_plane();
		double area_lonlat(double a, double f);
		double length_plane();
		double length_lonlat(double a, double f);
		unsigned size() { return parts.size(); };
};


class SpatVectorCollection;

class SpatVector {

	public:
		std::vector<SpatGeom> geoms;
		SpatExtent extent;
		SpatDataFrame df;
		//std::vector<std::string> crs;
		SpatSRS srs;

		SpatVector();
		//SpatVector(const SpatVector &x);
		SpatVector(SpatGeom g);
		SpatVector(SpatExtent e, std::string crs);
		SpatVector(std::vector<double> x, std::vector<double> y, SpatGeomType g, std::string crs);
		SpatVector(std::vector<std::string> wkt);

		SpatGeom window; // for point patterns, must be polygon

		std::vector<std::string> get_names();
		void set_names(std::vector<std::string> s);
		unsigned nrow();
		unsigned ncol();
		unsigned nxy();

		SpatVector deepCopy() {return *this;}

		SpatExtent getExtent();
		bool is_geographic();
		bool is_lonlat();
		bool could_be_lonlat();
		std::string type();
		SpatGeomType getGType(std::string &type);

		//std::vector<std::string> getCRS();
		//void setCRS(std::vector<std::string> _crs);

		bool setSRS(std::string _srs) {
			std::string msg;
			if (!srs.set(_srs, msg)){
				addWarning("Cannot set SRS to vector: "+ msg);
				return false;
			}
			return true;	
		}

		std::string getSRS(std::string x) {
			return srs.get(x);
		}

		SpatGeom getGeom(unsigned i);
		bool addGeom(SpatGeom p);
		bool setGeom(SpatGeom p);
		std::vector<std::vector<double>> getGeometry();
		SpatDataFrame getGeometryDF();
		std::vector<std::string> getGeometryWKT();

		std::vector<std::vector<double>> coordinates();

		SpatVector project(std::string crs);

		SpatVector subset_cols(int i);
		SpatVector subset_cols(std::vector<int> range);
		SpatVector subset_rows(int i);
		SpatVector subset_rows(std::vector<int> range);

		void setGeometry(std::string type, std::vector<unsigned> gid, std::vector<unsigned> part, std::vector<double> x, std::vector<double> y, std::vector<unsigned> hole);

		std::vector<double> area();
		std::vector<double> length();
		std::vector<double> distance(SpatVector x, bool pairwise);
		std::vector<double> distance(bool sequential);

		std::vector<std::vector<size_t>> knearest(size_t k);

		size_t size();
		SpatVector as_lines();
		SpatVector as_points(bool multi);
		SpatVector remove_holes();
		SpatVector get_holes();
		SpatVector set_holes(SpatVector x, size_t i);

		bool read(std::string fname);
		
		bool write(std::string filename, std::string lyrname, std::string driver, bool overwrite);
		
#ifdef useGDAL
		GDALDataset* write_ogr(std::string filename, std::string lyrname, std::string driver, bool overwrite);
		GDALDataset* GDAL_ds();
		bool read_ogr(GDALDataset *poDS);
		SpatVector fromDS(GDALDataset *poDS);
#endif

// attributes
		std::vector<double> getDv(unsigned i);
		std::vector<long> getIv(unsigned i);
		std::vector<std::string> getSv(unsigned i);
		std::vector<unsigned> getItype();
		std::vector<unsigned> getIplace();

		void add_column(unsigned dtype, std::string name) {
			df.add_column(dtype, name);
		};
		template <typename T>
		bool add_column(std::vector<T> x, std::string name) {
			return df.add_column(x, name);
		}

		void remove_df() {
			SpatDataFrame empty;
			df = empty;
		};

		bool remove_column(std::string field) {
			return df.remove_column(field);
		};
		bool remove_column(int i) {
			return df.remove_column(i);
		};
		std::vector<std::string> get_datatypes() {
			return df.get_datatypes();
		}

		SpatMessages msg;
		void setError(std::string s) { msg.setError(s); }
		void addWarning(std::string s) { msg.addWarning(s); }
		bool hasError() { return msg.has_error; }
		bool hasWarning() { return msg.has_warning; }
		std::string getWarnings() { return msg.getWarnings();}
		std::string getError() { return msg.getError();}

		SpatVector point_buffer(double d, unsigned quadsegs);
        SpatVector buffer(double d, unsigned segments, unsigned capstyle);

		SpatVector append(SpatVector x, bool ignorecrs);
		SpatVector disaggregate();
		SpatVector shift(double x, double y);
		SpatVector rescale(double f, double x0, double y0);
		SpatVector transpose();
		SpatVector flip(bool vertical);	
		SpatVector rotate(double angle, double x0, double y0);

//ogr 
		std::vector<bool> is_valid();
		SpatVector make_valid();
//geos
		std::vector<bool> geos_isvalid();
		std::vector<std::string> geos_isvalid_msg();

		SpatVector allerretour();
		SpatVectorCollection bienvenue();
		SpatVector aggregate(bool dissolve);
		SpatVector aggregate(std::string field, bool dissolve);
        SpatVector buffer2(double d, unsigned segments, unsigned capstyle);
		SpatVector centroid();
		SpatVector crop(SpatExtent e);
		SpatVector crop(SpatVector e);
		SpatVector voronoi(SpatVector e, double tolerance, int onlyEdges);		
		SpatVector delauny(double tolerance, int onlyEdges);		
		SpatVector convexhull();
		SpatVector intersect(SpatVector v);
		SpatVector unite(SpatVector v);
		SpatVector erase(SpatVector v);
		SpatVector cover(SpatVector v, bool identity);
		SpatVector symdif(SpatVector v);
		std::vector<int> relate(SpatVector v, std::string relation);
		std::vector<int> relate(std::string relation, bool symmetrical);
		std::vector<int> relateFirst(SpatVector v, std::string relation);
		std::vector<double> geos_distance(SpatVector v, bool parallel);
		std::vector<double> geos_distance(bool sequential);

		SpatVector nearest_point(SpatVector v, bool parallel);
		SpatVector nearest_point();
		SpatVector sample(unsigned n, std::string method, bool by_geom, std::string strata, unsigned seed);

		SpatVector unaryunion();

};



class SpatVectorCollection {

	private:
		std::vector<SpatVector> v;

	public:
		SpatMessages msg;
		void setError(std::string s) { msg.setError(s); }
		void addWarning(std::string s) { msg.addWarning(s); }
		bool hasError() { return msg.has_error; }
		bool hasWarning() { return msg.has_warning; }
		std::string getWarnings() { return msg.getWarnings();}
		std::string getError() { return msg.getError();}

		size_t size() { return v.size(); }
		void push_back(SpatVector x) { v.push_back(x); };
		bool replace(SpatVector x, size_t i) { 
			if (i < size()) {
				v[i] = x; 
				return true;
			} else {
				return false;
			}
		}
		SpatVectorCollection subset(std::vector<size_t> i) { 
			SpatVectorCollection out;
			for (size_t j=0; j<size(); j++) {
				if (i[j] < size()) {
					out.push_back(v[i[j]]); 
				} 
			}
			return out;
		}

		SpatVector get(size_t i) { 
			SpatVector out;
			out.msg = msg;
			if (i < size()) {
				out = v[i];
			} else {
				out.setError("invalid index");
			}
			return out;
		}
		
};

