using namespace std;
#include "extent.h"
/*
class SpatDataFrame {
	public:
		std::vector<string> names;
		std::vector<unsigned> itype;
		std::vector<unsigned> iplace;
		std::vector< std::vector<double>> dv;
		std::vector< std::vector<long>> iv;
		std::vector< std::vector<string>> sv;
		string NAS = "____NA_+";
		
	SpatDataFrame subsetrows(std::vector<unsigned> range);
	SpatDataFrame subsetcols(std::vector<unsigned> range);
	void addRow();
};
*/

class SpatGeomRing {
	public:
		std::vector<double> x, y; 
		std::vector< std::vector<double>> xHole, yHole; 

		SpatExtent extent;

		bool hasHoles() { return xHole.size() > 0;}
		unsigned nHoles() { return xHole.size();}
		bool set(std::vector<double> X, std::vector<double> Y) { 
			x = X; y = Y;  
			extent.xmin = *std::min_element(X.begin(), X.end());
			extent.xmax = *std::max_element(X.begin(), X.end());
			extent.ymin = *std::min_element(Y.begin(), Y.end());
			extent.ymax = *std::max_element(Y.begin(), Y.end());
			return true;
		}
		bool setHole(std::vector<double> X, std::vector<double> Y) { 
			// check if inside pol?
			xHole.push_back(X);
			yHole.push_back(Y);
			return true;
		}
		std::vector<double> getHoleX(unsigned i) { return( xHole[i] ) ; }
		std::vector<double> getHoleY(unsigned i) { return( yHole[i] ) ; }	
};


class SpatGeomRings {
	public:
		std::vector<SpatGeomRing> geoms; 
		SpatExtent extent;

		unsigned size() { return geoms.size(); };
		SpatGeomRing getGeom(unsigned i) { return geoms[i]; }
		bool addGeom(SpatGeomRing p) { 
			geoms.push_back(p); 
			if (geoms.size() > 1) {
				extent.unite(p.extent);
			} else {
				extent = p.extent;
			}
			return true; 
		}
		bool setGeom(SpatGeomRing p, unsigned i) {
			geoms[i] = p;
			// now re-compute extent
			return true;
		}
		
};


class SpatPolygons {
	private:
		std::vector<SpatGeomRings> geometries; 

	public:
	//	SpatDataFrame df;
		SpatExtent extent;		
		std::string crs;

		unsigned size() { return geometries.size(); };
		SpatGeomRings getGeometry(unsigned i) { return geometries[i]; };
		bool addGeometry(SpatGeomRings p) { 
			geometries.push_back(p); 
			if (geometries.size() > 1) {
				extent.unite(p.extent);
			} else {
				extent = p.extent;
			}
			//df.addRow();
			return true; 
		}
		//double getAtt(unsigned i) {	return attr[i]; };
		//bool setAtt(unsigned i, double a) { attr[i] = a; return true; };
		
		SpatPolygons subset(std::vector<unsigned> range) { 
			SpatPolygons out;
			for (size_t i=0; i < range.size(); i++) {
				out.addGeometry( geometries[range[i]] ); 
				//out.attr.push_back(attr[i]);
			}
			out.crs = crs;
			return out;	
		};
		
};



class SpatGeomSegment {
	public:
		std::vector<double> x, y; 
		SpatExtent extent;
		bool set(std::vector<double> X, std::vector<double> Y) { 
			x = X; y = Y;  
			extent.xmin = *std::min_element(X.begin(), X.end());
			extent.xmax = *std::max_element(X.begin(), X.end());
			extent.ymin = *std::min_element(Y.begin(), Y.end());
			extent.ymax = *std::max_element(Y.begin(), Y.end());
			return true;
		}
};

class SpatGeomSegments {
	public:
		std::vector<SpatGeomSegment> geoms; 
		SpatExtent extent;

		unsigned size() { return geoms.size(); };
		SpatGeomSegment getPart(unsigned i) { return geoms[i]; }
		bool addGeom(SpatGeomSegment p) { 
			geoms.push_back(p); 
			if (geoms.size() > 1) {
				extent.unite(extent);
			} else {
				extent = p.extent;
			}
			return true; 
		}
};


class SpatLines {
	private:
		std::vector<SpatGeomSegments> geometries; 

	public:
	//	SpatDataFrame df;
		SpatExtent extent;		
		std::string crs;

		unsigned size() { return geometries.size(); };
		SpatGeomSegments getGeometry(unsigned i) { return geometries[i]; };
		bool addGeometry(SpatGeomSegments p) { 
			geometries.push_back(p); 
			if (geometries.size() > 1) {
				extent.unite(p.extent);
			} else {
				extent = p.extent;
			}
		//	df.addRow();
			return true; 
		}
		//double getAtt(unsigned i) {	return attr[i]; };
		//bool setAtt(unsigned i, double a) { attr[i] = a; return true; };
		
		SpatLines subset(std::vector<unsigned> range) { 
			SpatLines out;
			for (size_t i=0; i < range.size(); i++) {
				out.addGeometry( geometries[range[i]] ); 
			//	out.attr.push_back(attr[i]);
			}
			out.crs = crs;
			return out;	
		};
		
};




class SpatPoints {
	public:
		std::vector<double> x, y; 
	//	SpatDataFrame df;
		SpatExtent extent;
		bool set(std::vector<double> X, std::vector<double> Y) { 
			x = X; y = Y;  
			extent.xmin = *std::min_element(X.begin(), X.end());
			extent.xmax = *std::max_element(X.begin(), X.end());
			extent.ymin = *std::min_element(Y.begin(), Y.end());
			extent.ymax = *std::max_element(Y.begin(), Y.end());
			return true;
		}
};


class SpatVector {
	public:
		SpatPoints pts;
		SpatLines lns;
		SpatPolygons pos;

		bool error = false;
		bool warning = false;
		string error_message;
		std::vector<string> warning_message;
		
	bool read(std::string fname);
	bool write(std::string filename, bool overwrite);
	
};

