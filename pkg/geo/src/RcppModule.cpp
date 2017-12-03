#include <Rcpp.h>
#include "geo.h"

using namespace Rcpp;


NumericMatrix getValuesM(GeoRaster* r) {
	NumericMatrix x(r->ncell(), r->nlyr);
	std::copy(r->values.begin(), r->values.end(), x.begin());
	return(x);
}

RCPP_EXPOSED_CLASS(BlockSize)
RCPP_EXPOSED_CLASS(GeoExtent)
RCPP_EXPOSED_CLASS(GeoRaster)
	
RCPP_MODULE(GeoRaster){
    using namespace Rcpp;


    class_<BlockSize>("BlockSize")
		.constructor()
		.field("row", &BlockSize::row)
		.field("nrows", &BlockSize::nrows)
		.field("n", &BlockSize::n)
		.field("filename", &BlockSize::filename)
	;	
	
	
    class_<GeoExtent>("GeoExtent")
		.constructor()
		.constructor<double, double, double, double>()
		.property("vector", &GeoExtent::asVector)		
		.property("valid", &GeoExtent::valid)		
	;	

    class_<GeoRaster>("GeoRaster")
		.constructor()
	    .constructor<std::string>()
		.constructor<std::vector<unsigned>, std::vector<double>, std::string>()
	
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
		.method("getValues", &getValuesM)
		.property("values", &GeoRaster::getValues, &GeoRaster::setValues )	

		.method("setRange", &GeoRaster::setRange, "setRange")
		.method("writeStart", &GeoRaster::writeStart, "writeStart") 
		.method("writeStop", &GeoRaster::writeStop, "writeStop") 
		.method("writeValues", &GeoRaster::writeValues, "writeValues") 
		.field_readonly("blockSize", &GeoRaster::bs )

		.method("writeRaster", &GeoRaster::writeRaster, "writeRaster")
		
		.property("crs", &GeoRaster::getCRS, &GeoRaster::setCRS )
		.property("extent", &GeoRaster::getExtent, &GeoRaster::setExtent )
		.property("names", &GeoRaster::getNames, &GeoRaster::setNames )
		.property("res", &GeoRaster::resolution)
		.property("origin", &GeoRaster::origin)


		.property("inMemory", &GeoRaster::inMemory )
		.property("filenames", &GeoRaster::filenames )
		
		.field_readonly("nrow", &GeoRaster::nrow )
		.field_readonly("ncol", &GeoRaster::ncol )
		.field_readonly("nlyr", &GeoRaster::nlyr )
	
		.field_readonly("hasValues", &GeoRaster::hasValues )
		.field_readonly("hasRange", &GeoRaster::hasRange )
		.field_readonly("range_min", &GeoRaster::range_min )
		.field_readonly("range_max", &GeoRaster::range_max )

		.method("crop", &GeoRaster::crop, "crop")
		.method("trim", &GeoRaster::trim, "trim")
		.method("mask", &GeoRaster::mask, "mask")
		.method("aggregate", &GeoRaster::aggregate, "aggregate")
		.method("get_aggregates", &GeoRaster::get_aggregates, "get_aggregates")
		.method("get_aggregate_dims", &GeoRaster::get_aggregate_dims, "get_aggregate_dims")
			
	;	
		
}
