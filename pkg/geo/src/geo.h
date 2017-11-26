using namespace std;

#include <string>
#include <vector>
#include <algorithm>


class GeoExtent {
	public:
		double xmin, xmax, ymin, ymax;
		GeoExtent() {
			xmin = -180;
			xmax = 180;
			ymin = -90;
			ymax = 90;
		}
};

class RasterSource {
	public:
		std::vector<bool> memory;
		std::vector<string> filename;
		std::vector<string> driver;
		std::vector<int> nlayers;		
		std::vector<std::vector<int> > layers;		
		std::vector<string> datatype;
		std::vector<double> NAflag;
		
};

class GeoRaster {
	
	private:
		std::string msg;
		
	protected:
		GeoExtent extent;
		string crs ="+proj=longlat +datum=WGS84";
		RasterSource source;
		
	public:
		//double NA = std::numeric_limits<double>::quiet_NaN();

		unsigned nrow, ncol;
		// values
		bool hasValues;
		std::vector<double> values;
		std::vector<bool> hasRange;
		std::vector< std::vector<double> > range;
		std::vector<string> names;
		std::vector<bool> inMemory() { return source.memory; }
		
		GeoRaster(std::string fname) {
			range.resize(2);
			createFromFile(fname);
		}
		
		GeoRaster() {
			nrow=10; ncol=10; 
			hasValues = false; 
			hasRange.push_back(false);
			source.memory.push_back(true);
			source.filename.push_back("");
			source.driver.push_back("");
			source.nlayers.push_back(1);
			source.layers.resize(1, vector<int>(1));
			source.layers[0][1] = 1;
			source.datatype.push_back("");
			range.resize(2);
			names.push_back("lyr.1");
		}
		
//		GeoRaster(unsigned _nrow=10, unsigned _ncol=10, unsigned nlayers=1, double xmin=-180, double xmax=180, double ymin=-90, double ymax=90, std::string _crs="+proj=longlat +datum=WGS84") {
		GeoRaster(std::vector<unsigned> rcl, std::vector<double> ext, std::string _crs) {
			nrow=rcl[0]; ncol=rcl[1];
			extent.xmin = ext[0];
			extent.xmax = ext[1];
			extent.ymin = ext[2];
			extent.ymax = ext[3];
			hasValues = false; 
			hasRange.push_back(false);
			source.memory.push_back(true);
			source.filename.push_back("");
			source.driver.push_back("");
			source.nlayers.push_back(rcl[2]);
			source.layers.resize(1, vector<int>(1));
			source.layers[0][1] = 1;
			source.datatype.push_back("");
			range.resize(2);
			crs=_crs;
			for (unsigned i=0; i<rcl[2]; i++) {	names.push_back("lyr." + std::to_string(i)) ; }
		}
		
		
		double ncell() { return nrow * ncol; }
		std::vector<double> getExtent() { 
			std::vector<double> e(4);
			e[0] = extent.xmin; e[1] = extent.xmax; e[2] = extent.ymin; e[3] = extent.ymax; 
			return(e);
		}
		void setExtent(std::vector<double> e) {
			extent.xmin = e[0]; extent.xmax = e[1]; extent.ymin = e[2]; extent.ymax = e[3]; 
		}
//		void setExtent(double xmin, double xmax, double ymin, double ymax) {
//			extent[0] = xmin; extent[1] = xmax; extent[2] = ymin; extent[3] = ymax;
//		}

	
		string getCRS()	{ return(crs); }
		void setCRS(string _crs) { crs = _crs; }
		std::vector<string> getNames()	{ return(names); }
		void setNames(std::vector<string> _names) { names = _names; }
				
		std::vector<double> resolution() {
			std::vector<double> out(2);
			out[0] = (extent.xmax - extent.xmin) / ncol;
			out[1] = (extent.ymax - extent.ymin) / nrow;
			return out;
		}

		int nlyr() { 
			int lyrs = std::accumulate(source.nlayers.begin(), source.nlayers.end(), 0); 
			return(lyrs);
		}
		std::vector<string> filenames() { return source.filename; }
		
		std::vector<double> getValues() { return values; }
	
		
		bool compare(unsigned nrows, unsigned ncols, GeoExtent e ) {
			double limit = 0.0001;
			double xrange = extent.xmax - extent.xmin;
			double yrange = extent.ymax - extent.ymin;
			double e1 = fabs(e.xmax - extent.xmax) / xrange;
			double e2 = fabs(e.xmin - extent.xmin) / xrange;
			double e3 = fabs(e.ymax - extent.ymax) / yrange;
			double e4 = fabs(e.ymin - extent.ymin) / yrange;
			bool eOK = ((e1 < limit) && (e2 < limit) && (e3 < limit) && (e4 > limit));
			return ((nrow == nrows) && (ncol == ncols) && eOK);
		}
	
		void setValues(std::vector<double> _values) {
			//bool result = false;
			if (_values.size() == (ncol * nrow * nlyr())) {
				values = _values;
				std::vector<bool> mem {true};
				source.memory = mem;
				// todo clear source...
				setRange();
				hasValues = true;
				std::vector<string> n {"layer"};
				names = n;
				
				//result = true;
			} 
			//return (result);
		}

		bool createFromFile(std::string fname);

		std::vector<double> cellFromXY (std::vector<double> x, std::vector<double> y);
		double cellFromXY(double x, double y);
		std::vector<double> cellFromRowCol(std::vector<unsigned> rownr, std::vector<unsigned> colnr);
		double cellFromRowCol(unsigned rownr, unsigned colnr);
		std::vector<double> yFromRow(std::vector<unsigned> rownr);
		double yFromRow(unsigned rownr);
		std::vector<double> xFromCol(std::vector<unsigned> colnr);
		double xFromCol(unsigned colnr);
		std::vector<unsigned> colFromX(std::vector<double> x);
		unsigned colFromX(double x);
		std::vector<unsigned> rowFromY(std::vector<double> y);
		unsigned rowFromY(double y);
		std::vector< std::vector<double> > xyFromCell( std::vector<double> cell );
		std::vector< std::vector<double> > xyFromCell( double cell );
		std::vector< std::vector<unsigned> > rowColFromCell(std::vector<double> cell);
		
		
		double valuesCell(double);
		double valuesCell(int, int);
		std::vector<double> valuesCell(std::vector<double>);	
		std::vector<double> valuesRow(int);	
		std::vector<std::vector<double>> valuesAll();	

			
		bool writeValues(string filename, std::vector<double>  values);
		

		GeoRaster SQRT() {
			GeoRaster r = *this;
			std::transform(r.values.begin(), r.values.end(), r.values.begin(), (double(*)(double)) sqrt);
			return r;
		}
		
		void setRange() {
			auto result = std::minmax_element (values.begin(), values.end());
			std::vector< std::vector<double> > v(2, vector<double>(1));
			v[0][0] = *result.first;
			v[1][0] = *result.second;
			range = v;
			std::vector<bool> b {true};
			hasRange = b;
		}
		
		
};



/*GeoRaster SQRTfree(GeoRaster* g) {
	GeoRaster r = *g;
	std::transform(r.values.begin(), r.values.end(), r.values.begin(), (double(*)(double)) sqrt);
	return r;
}*/


