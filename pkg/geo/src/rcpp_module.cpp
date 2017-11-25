#include <Rcpp.h>
#include "geo.h"

using namespace Rcpp;

RCPP_EXPOSED_CLASS(GeoRaster)
RCPP_EXPOSED_CLASS(GeoExtent)

RCPP_MODULE(GeoRaster){
    using namespace Rcpp ;

    class_<GeoRaster>("GeoRaster")
		.constructor()
	    .constructor<std::string>()

		.method("cellFromXY", ( std::vector<double> (GeoRaster::*)(std::vector<double>,std::vector<double>) )( &GeoRaster::cellFromXY ))
		.method("cellFromRowCol", ( std::vector<double> (GeoRaster::*)(std::vector<unsigned>,std::vector<unsigned>) )( &GeoRaster::cellFromRowCol ))
		.method("yFromRow", ( std::vector<double> (GeoRaster::*)(std::vector<unsigned>) )( &GeoRaster::yFromRow ))
		.method("xFromCol", ( std::vector<double> (GeoRaster::*)(std::vector<unsigned>) )( &GeoRaster::xFromCol ))
		.method("colFromX", ( std::vector<unsigned> (GeoRaster::*)(std::vector<double>) )( &GeoRaster::colFromX ))
		.method("rowFromY", ( std::vector<unsigned> (GeoRaster::*)(std::vector<double>) )( &GeoRaster::rowFromY ))
		.method("xyFromCell", ( std::vector< std::vector<double> > (GeoRaster::*)(std::vector<double>) )( &GeoRaster::xyFromCell ))
		.method("rowColFromCell", ( std::vector< std::vector<unsigned> > (GeoRaster::*)(std::vector<double>) )( &GeoRaster::rowColFromCell ))
		
	
		.property("values", &GeoRaster::getValues, &GeoRaster::setValues )
		.property("crs", &GeoRaster::getCRS, &GeoRaster::setCRS )
		.property("extent", &GeoRaster::getExtent, &GeoRaster::setExtent )
		.property("names", &GeoRaster::getNames, &GeoRaster::setNames )
		.property("res", &GeoRaster::resolution)

		.property("inMemory", &GeoRaster::inMemory )
		.property("nlyr", &GeoRaster::nlyr )
		.property("filenames", &GeoRaster::filenames )
		
		.field_readonly( "nrow", &GeoRaster::nrow )
		.field_readonly( "ncol", &GeoRaster::ncol )
	
		.field_readonly( "hasValues", &GeoRaster::hasValues )
		.field_readonly( "hasRange", &GeoRaster::hasRange )
		.field_readonly( "range", &GeoRaster::range )
		
		.method("sqrt1", &GeoRaster::SQRT, "sqrt")

//		.method("sqrt2", &SQRTfree, "sqrt")
	;
	
}