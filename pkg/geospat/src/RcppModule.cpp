#include <Rcpp.h>
#include "geo.h"

using namespace Rcpp;


NumericMatrix getValuesM(GeoRaster* r) {
	NumericMatrix x(r->ncell(), r->nlyr);
	std::vector<double> v;
	v = r->getValues();
	std::copy(v.begin(), v.end(), x.begin());
	return(x);
}

List getBlockSizeR(GeoRaster* r) {              //+1 for R
	List L = List::create(Named("row") = r->bs.row, Named("nrows") = r->bs.nrows, Named("n") = r->bs.n);
	return(L);
}


RCPP_EXPOSED_CLASS(GeoExtent)
RCPP_EXPOSED_CLASS(GeoRaster)
RCPP_EXPOSED_CLASS(RasterSource)


	
RCPP_MODULE(geo){
    using namespace Rcpp;


    class_<GeoExtent>("GeoExtent")
		.constructor()
		.constructor<double, double, double, double>()
		.property("vector", &GeoExtent::asVector)		
		.property("valid", &GeoExtent::valid)		
	;	

    class_<RasterSource>("RasterSource")
	
		.field_readonly("memory", &RasterSource::memory)
		.field_readonly("filename", &RasterSource::filename)
		.field_readonly("driver", &RasterSource::driver)
		.field_readonly("nlayers", &RasterSource::nlayers)
		.field_readonly("datatype", &RasterSource::datatype)
		.field_readonly("NAflag", &RasterSource::NAflag)
		//std::vector<std::vector<int> > layers;		
	;	

    class_<GeoRaster>("GeoRaster")
		.constructor()
	    .constructor<std::string>()
		.constructor<std::vector<unsigned>, std::vector<double>, std::string>()

		.field_readonly("source", &GeoRaster::source )
		
		.method("cellFromXY", ( std::vector<double> (GeoRaster::*)(std::vector<double>,std::vector<double>) )( &GeoRaster::cellFromXY ))
		.method("cellFromRowCol", ( std::vector<double> (GeoRaster::*)(std::vector<unsigned>,std::vector<unsigned>) )( &GeoRaster::cellFromRowCol ))
		.method("yFromRow", ( std::vector<double> (GeoRaster::*)(std::vector<unsigned>) )( &GeoRaster::yFromRow ))
		.method("xFromCol", ( std::vector<double> (GeoRaster::*)(std::vector<unsigned>) )( &GeoRaster::xFromCol ))
		.method("colFromX", ( std::vector<double> (GeoRaster::*)(std::vector<double>) )( &GeoRaster::colFromX ))
		.method("rowFromY", ( std::vector<double> (GeoRaster::*)(std::vector<double>) )( &GeoRaster::rowFromY ))
		.method("xyFromCell", ( std::vector< std::vector<double> > (GeoRaster::*)(std::vector<double>) )( &GeoRaster::xyFromCell ))
		.method("rowColFromCell", ( std::vector< std::vector<double> > (GeoRaster::*)(std::vector<double>) )( &GeoRaster::rowColFromCell ))

		.method("readStart", &GeoRaster::readStart, "readStart") 
		.method("readStop", &GeoRaster::readStop, "readStop") 
		.method("readValues", &GeoRaster::readValues, "readValues")	
		.method("getValues", &GeoRaster::getValues)
		.method("getBlockSize", &getBlockSizeR)
//		.property("values", &GeoRaster::getValues, &GeoRaster::setValues )	
		.method("setValues", &GeoRaster::setValues)

		.method("setRange", &GeoRaster::setRange, "setRange")
		.method("writeStart", &GeoRaster::writeStart, "writeStart") 
		.method("writeStop", &GeoRaster::writeStop, "writeStop") 
		.method("writeValues", &GeoRaster::writeValues, "writeValues") 

		.method("writeRaster", &GeoRaster::writeRaster, "writeRaster")
		
		.property("crs", &GeoRaster::getCRS, &GeoRaster::setCRS )
		.property("extent", &GeoRaster::getExtent, &GeoRaster::setExtent )
		.property("names", &GeoRaster::getNames, &GeoRaster::setNames )
		.property("res", &GeoRaster::resolution)
		.property("origin", &GeoRaster::origin)
		//.property("layers", &GeoRaster::getnlayers)


		.property("inMemory", &GeoRaster::inMemory )
//		.property("filenames", &GeoRaster::filenames )
		
		.field_readonly("nrow", &GeoRaster::nrow )
		.field_readonly("ncol", &GeoRaster::ncol )
		.field_readonly("nlyr", &GeoRaster::nlyr )
	
		.field_readonly("hasValues", &GeoRaster::hasValues )
		.field_readonly("hasRange", &GeoRaster::hasRange )
		.field_readonly("range_min", &GeoRaster::range_min )
		.field_readonly("range_max", &GeoRaster::range_max )

		.method("test", &GeoRaster::test, "test")
		
		
		.method("crop", &GeoRaster::crop, "crop")
		.method("focal", &GeoRaster::focal, "focal")
		.method("focalValues", &GeoRaster::focal_values, "focalValues")
		.method("trim", &GeoRaster::trim, "trim")
		.method("mask", &GeoRaster::mask, "mask")
		.method("aggregate", &GeoRaster::aggregate, "aggregate")
		.method("get_aggregates", &GeoRaster::get_aggregates, "get_aggregates")
		.method("get_aggregate_dims", &GeoRaster::get_aggregate_dims, "get_aggregate_dims")
			
	;	
		
}
