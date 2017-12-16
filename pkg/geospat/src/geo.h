using namespace std;

#include <string>
#include <vector>
#include <algorithm>
#include <fstream>


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
		std::vector<unsigned> nlayers;		
		std::vector<std::vector<int> > layers;		
		std::vector<string> datatype;
		std::vector<double> NAflag;
};


class BlockSize {
	public:
		std::vector<unsigned> row;
		std::vector<unsigned> nrows;
		unsigned n;
};




class GeoRaster {
	
	private:
		std::string msg;
		fstream* fs;
		
	protected:
		GeoExtent extent;
		std::string crs ="+proj=longlat +datum=WGS84";
		void setnlyr() { 
			nlyr = std::accumulate(source.nlayers.begin(), source.nlayers.end(), 0); 
		}
		BlockSize getBlockSize();
		
	public:
		//double NA = std::numeric_limits<double>::quiet_NaN();
		RasterSource source;
	
	    std::vector<unsigned> getnlayers() {
			return source.nlayers;
		}		
		unsigned nrow, ncol, nlyr;
		unsigned size() { return ncol * nrow * nlyr ; }
		bool hasValues;
		
		BlockSize bs;
		
		std::vector<double> values;
		
		std::vector<bool> hasRange;
		std::vector<double> range_min;
		std::vector<double> range_max;
		std::vector<string> names;
		std::vector<bool> inMemory() { return source.memory; }

		// constructors
		GeoRaster(std::string fname);
		GeoRaster();
		GeoRaster(std::vector<unsigned> rcl, std::vector<double> ext, std::string _crs);
		GeoRaster(unsigned _nrow, unsigned _ncol, unsigned _nlyr, GeoExtent ext, std::string _crs);
		
		double ncell() { return nrow * ncol; }

//	void setExtent(std::vector<double> e) {	extent.xmin = e[0]; extent.xmax = e[1]; extent.ymin = e[2]; extent.ymax = e[3]; }
		GeoExtent getExtent() { return extent; }
		void setExtent(GeoExtent e) { extent = e ; }

		void setExtent(GeoExtent ext, bool keepRes=false, std::string snap="");

		
		std::string getCRS()	{ return(crs); }
		void setCRS(std::string _crs) { crs = _crs; }
		std::vector<string> getNames()	{ 
			if (names.size() < 1) {
				return std::vector<string> {"layer"}; // rep for each layer
			}
			return(names); 
		}
		void setNames(std::vector<string> _names) { names = _names; }
	
		std::vector<double> resolution() { return std::vector<double> { (extent.xmax - extent.xmin) / ncol, (extent.ymax - extent.ymin) / nrow };}
		double xres() { return (extent.xmax - extent.xmin) / ncol ;}
		double yres() { return (extent.ymax - extent.ymin) / nrow ;}

		std::vector<double> origin();	
		
		std::vector<string> filenames() { return source.filename; }

		
		bool compare(unsigned nrows, unsigned ncols, GeoExtent e );
	
		std::vector<double> getValues();
		void setValues(std::vector<double> _values);


		bool constructFromFile(std::string fname);

		std::vector<double> cellFromXY (std::vector<double> x, std::vector<double> y);
		double cellFromXY(double x, double y);
		std::vector<double> cellFromRowCol(std::vector<unsigned> rownr, std::vector<unsigned> colnr);
		double cellFromRowCol(unsigned rownr, unsigned colnr);
		std::vector<double> yFromRow(std::vector<unsigned> rownr);
		double yFromRow(unsigned rownr);
		std::vector<double> xFromCol(std::vector<unsigned> colnr);
		double xFromCol(unsigned colnr);
		std::vector<double> colFromX(std::vector<double> x);
		double colFromX(double x);
		std::vector<double> rowFromY(std::vector<double> y);
		double rowFromY(double y);
		std::vector< std::vector<double> > xyFromCell( std::vector<double> cell );
		std::vector< std::vector<double> > xyFromCell( double cell );
		std::vector< std::vector<double> > rowColFromCell(std::vector<double> cell);
		
		
		double valuesCell(double);
		double valuesCell(int, int);
		std::vector<double> valuesCell(std::vector<double>);	
		std::vector<double> valuesRow(int);	

		void setRange();
		
		
		bool readStart();
		bool readStop();
		std::vector<double> readValues(unsigned row, unsigned nrows, unsigned col, unsigned ncols);
		
		bool writeStart(std::string filename, bool overwrite);
		bool writeStartFs(std::string filename, bool overwrite, fstream& f);
		
		bool writeValues(std::vector<double> vals, unsigned row);
		bool writeStop();
		bool writeHDR();
		
		
		void openFS(string const &filename);

		
		GeoRaster writeRaster(std::string filename, bool overwrite);
		GeoExtent align(GeoExtent e, string snap="near");
		
		GeoRaster test(string filename);
		GeoRaster crop(GeoExtent e, string filename="", string snap="near", bool overwrite=false);
		GeoRaster trim(unsigned padding=0, std::string filename="", bool overwrite=false);
		GeoRaster mask(GeoRaster mask, string filename="", bool overwrite=false);

		GeoRaster aggregate(std::vector<unsigned> fact, string fun, bool narm, string filename="", bool overwrite=false);
		//std::vector<double> aggregate(std::vector<unsigned> fact, bool narm, string fun, string filename="");

		std::vector<unsigned> get_aggregate_dims( std::vector<unsigned> fact );
		std::vector<std::vector<double> > get_aggregates(std::vector<unsigned> dim);
		
		std::vector<double> sampleRegular(unsigned size, bool cells, bool asRaster);
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


