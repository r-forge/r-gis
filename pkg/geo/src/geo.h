using namespace std;

#include <string>
#include <vector>
#include <algorithm>


class GeoExtent {
	public:
		double xmin, xmax, ymin, ymax;
		GeoExtent() {xmin = -180; xmax = 180; ymin = -90; ymax = 90;}
		GeoExtent(double _xmin, double _xmax, double _ymin, double _ymax) {xmin = _xmin; xmax = _xmax; ymin = _ymin; ymax = _ymax;}
		
		void intersect(GeoExtent e) { 
			xmin = std::max(xmin, e.xmin);
			xmax = std::min(xmax, e.xmax);
			ymin = std::max(ymin, e.ymin);
			ymax = std::min(ymax, e.ymax);
		}

		std::vector<double> asVector() { 
			std::vector<double> e(4);
			e[0] = xmin; e[1] = xmax; e[2] = ymin; e[3] = ymax; 
			return(e);
		}
			
		bool valid() {
			return ((xmax > xmin) && (ymax > ymin));
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


class BlockSize {
	public:
		std::vector<unsigned> row;
		std::vector<unsigned> nrows;
		unsigned n;
		std::string filename;
};


class GeoRaster {
	
	private:
		std::string msg;
		
	protected:
		GeoExtent extent;
		std::string crs ="+proj=longlat +datum=WGS84";
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

		// consructors
		GeoRaster(std::string fname);
		GeoRaster();
		GeoRaster(std::vector<unsigned> rcl, std::vector<double> ext, std::string _crs);
		
		double ncell() { return nrow * ncol; }

/*	void setExtent(std::vector<double> e) {
			extent.xmin = e[0]; extent.xmax = e[1]; extent.ymin = e[2]; extent.ymax = e[3]; 
		}
*/
		GeoExtent getExtent() { return extent; }
		void setExtent(GeoExtent e) { extent = e ; }

		void setExtent(GeoExtent ext, bool keepRes=false, std::string snap="");

		
		std::string getCRS()	{ return(crs); }
		void setCRS(std::string _crs) { crs = _crs; }
		std::vector<string> getNames()	{ return(names); }
		void setNames(std::vector<string> _names) { names = _names; }
				
		std::vector<double> resolution() {
			return std::vector<double> { (extent.xmax - extent.xmin) / ncol, (extent.ymax - extent.ymin) / nrow };
		}

		std::vector<double> origin();	
		
		int nlyr() { 
			int lyrs = std::accumulate(source.nlayers.begin(), source.nlayers.end(), 0); 
			return(lyrs);
		}
		std::vector<string> filenames() { return source.filename; }

		
		bool compare(unsigned nrows, unsigned ncols, GeoExtent e );
	
		std::vector<double> getValues() { return values; }
		void setValues(std::vector<double> _values);


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

		void setRange();
		
		GeoExtent align(GeoExtent e, string snap="near");
		GeoRaster crop(GeoExtent e, string filename="", string snap="near");
		
		BlockSize getBlockSize(std::string filename="");
		
		void readStart();
		std::vector<double> readValues(unsigned row, unsigned nrows, unsigned col, unsigned ncols);
		void readStop();

		void writeStart(std::string filename);
		void writeValues(std::vector<double> vals, unsigned row);
		void writeStop();
		GeoRaster writeRaster(std::string filename);
		
};


/*
GeoRaster SQRT() {
	GeoRaster r = *this;
	std::transform(r.values.begin(), r.values.end(), r.values.begin(), (double(*)(double)) sqrt);
	return r;
}
		
GeoRaster SQRTfree(GeoRaster* g) {
	GeoRaster r = *g;
	std::transform(r.values.begin(), r.values.end(), r.values.begin(), (double(*)(double)) sqrt);
	return r;
}
*/


