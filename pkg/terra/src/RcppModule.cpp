#include <Rcpp.h>
#include "spatRaster.h"
#include "RcppFunctions.h"

RCPP_EXPOSED_CLASS(SpatMessages)
RCPP_EXPOSED_CLASS(SpatOptions)
RCPP_EXPOSED_CLASS(SpatExtent)
//RCPP_EXPOSED_CLASS(RasterSource)
RCPP_EXPOSED_CLASS(SpatRaster)
RCPP_EXPOSED_CLASS(SpatVector)

RCPP_MODULE(spat){

    using namespace Rcpp;

    class_<SpatExtent>("SpatExtent")
		.constructor()
		.constructor<double, double, double, double>()
		.property("vector", &SpatExtent::asVector)		
		.property("valid", &SpatExtent::valid)		
	;	

    class_<SpatMessages>("SpatMessages")
		.constructor()
		.field("success", &SpatMessages::success)		
		.field("has_error", &SpatMessages::has_error)		
		.field("has_warning", &SpatMessages::has_warning)		
		.field("error", &SpatMessages::error)		
		.field("warnings", &SpatMessages::warnings)		
	;	

	
    class_<SpatOptions>("SpatOptions")
		.constructor()
		.method("copy", &SpatOptions::deepcopy)
		.property("tempdir", &SpatOptions::get_tempdir, &SpatOptions::set_tempdir )
		.property("memfrac", &SpatOptions::get_memfrac, &SpatOptions::set_memfrac )
		.property("filename", &SpatOptions::get_filename, &SpatOptions::set_filename )
		.property("filetype", &SpatOptions::get_filetype, &SpatOptions::set_filetype )
		.property("datatype", &SpatOptions::get_datatype, &SpatOptions::set_datatype )
		.property("overwrite", &SpatOptions::get_overwrite, &SpatOptions::set_overwrite )

		.property("def_filetype", &SpatOptions::get_def_filetype, &SpatOptions::set_def_filetype )
		.property("def_datatype", &SpatOptions::get_def_datatype, &SpatOptions::set_def_datatype )

		.property("todisk", &SpatOptions::get_todisk, &SpatOptions::set_todisk)
		.field("messages", &SpatOptions::msg, "messages")
	//	.property("overwrite", &SpatOptions::set_overwrite, &SpatOptions::get_overwrite )
		//.field("gdaloptions", &SpatOptions::gdaloptions)		
	;
	

    class_<SpatVector>("SpatVector")
		.constructor()	
		.method("names", &SpatVector::names, "names")		
		.method("nrow", &SpatVector::nrow, "nrow")		
		.method("ncol", &SpatVector::ncol, "ncol")		
		.method("size", &SpatVector::size, "size")		
		.property("crs", &SpatVector::getCRS, &SpatVector::setCRS, "crs")		
		.method("type", &SpatVector::type, "type")		
		.method("extent", &SpatVector::getExtent, "extent")		
		.method("read", &SpatVector::read, "read")		
		.method("getAttributes", &getAttributes, "getAttributes")
		.method("getGeometry", &getGeometry, "getGeometry")
		.method("setGeometry", &SpatVector::setGeometry, "setGeometry")
		.method("area", &SpatVector::area, "area")		
		.method("length", &SpatVector::length, "length")		
		.method("as_lines", &SpatVector::as_lines, "as_lines")
		.field("messages", &SpatVector::msg, "messages")
	;

	
/*
    class_<RasterSource>("RasterSource")	
		.field_readonly("memory", &RasterSource::memory)
		.field_readonly("filename", &RasterSource::filename)
		.field_readonly("driver", &RasterSource::driver)
		.field_readonly("nrow", &RasterSource::nrow)
		.field_readonly("ncol", &RasterSource::ncol)
		.field_readonly("nlyr", &RasterSource::nlyr)
		.field_readonly("crs", &RasterSource::crs)
		.field_readonly("extent", &RasterSource::extent)
		.field_readonly("datatype", &RasterSource::datatype)
		.field_readonly("NAflag", &RasterSource::NAflag)
		//std::vector<std::vector<int> > layers;		
	;	
*/
    class_<SpatRaster>("SpatRaster")
		.constructor()
	    //.constructor<std::string>()
	    .constructor<std::vector<std::string> >()
		.constructor<std::vector<unsigned>, std::vector<double>, std::string>()
		
		.property("extent", &SpatRaster::getExtent, &SpatRaster::setExtent )
		.property("crs", &SpatRaster::getCRS, &SpatRaster::setCRS )
		.property("names", &SpatRaster::getNames)
		.property("res", &SpatRaster::resolution)
		.property("origin", &SpatRaster::origin)
		.property("inMemory", &SpatRaster::inMemory )
		.property("filenames", &SpatRaster::filenames )
		.property("hasValues", &SpatRaster::hasValues )

			
		//.field_readonly("hasRAT", &SpatRaster::hasRAT )
		//.field_readonly("hasCT", &SpatRaster::hasCT )
		.property("hasRange", &SpatRaster::hasRange )
		.property("range_min", &SpatRaster::range_min )
		.property("range_max", &SpatRaster::range_max )
		.method("nrow", &SpatRaster::nrow, "nrow")		
		.method("ncol", &SpatRaster::ncol, "ncol")		
		.method("nsrc", &SpatRaster::nsrc, "nsrc" )	
		.field("messages", &SpatRaster::msg, "messages")
		.method("nlyrBySource", &SpatRaster::nlyrBySource, "nlyrBySource" )		
		.method("nlyr", &SpatRaster::nlyr, "nlyr" )
		.method("setNames", &SpatRaster::setNames, "setNames" )
// only of RasterSource is exposed
//		.field_readonly("source", &SpatRaster::source )

		.method("combineSources", &SpatRaster::combineSources, "combineSources")
		.method("subset", &SpatRaster::subset, "subset")
		.method("compare_geom", &SpatRaster::compare_geom, "compare_geom")
				
		.method("cellFromXY", ( std::vector<double> (SpatRaster::*)(std::vector<double>,std::vector<double>) )( &SpatRaster::cellFromXY ))
		.method("cellFromRowCol", ( std::vector<double> (SpatRaster::*)(std::vector<unsigned>,std::vector<unsigned>) )( &SpatRaster::cellFromRowCol ))
		.method("yFromRow", ( std::vector<double> (SpatRaster::*)(std::vector<unsigned>&) )( &SpatRaster::yFromRow ))
		.method("xFromCol", ( std::vector<double> (SpatRaster::*)(std::vector<unsigned>&) )( &SpatRaster::xFromCol ))
		.method("colFromX", ( std::vector<unsigned> (SpatRaster::*)(std::vector<double>&) )( &SpatRaster::colFromX ))
		.method("rowFromY", ( std::vector<unsigned> (SpatRaster::*)(std::vector<double>&) )( &SpatRaster::rowFromY ))
		.method("xyFromCell", ( std::vector< std::vector<double> > (SpatRaster::*)(std::vector<double>&) )( &SpatRaster::xyFromCell ))
		.method("rowColFromCell", ( std::vector< std::vector<unsigned> > (SpatRaster::*)(std::vector<double>) )( &SpatRaster::rowColFromCell ))

		.method("readStart", &SpatRaster::readStart, "readStart") 
		.method("readStop", &SpatRaster::readStop, "readStop") 
		.method("readValues", &SpatRaster::readValues, "readValues")	
		.method("getValues", &SpatRaster::getValues, "getValues")
		.method("getBlockSize", &getBlockSizeR)
		.method("setValues", &SpatRaster::setValues)

		.method("setRange", &SpatRaster::setRange, "setRange")
		.method("writeStart", &SpatRaster::writeStart, "writeStart") 
		.method("writeStop", &SpatRaster::writeStop, "writeStop") 
		.method("writeValues", &SpatRaster::writeValues, "writeValues") 

		.method("writeRaster", &SpatRaster::writeRaster, "writeRaster")
		.method("canProcessInMemory", &SpatRaster::canProcessInMemory, "canProcessInMemory")
		.method("chunkSize", &SpatRaster::chunkSize, "chunkSize")
		
		.method("adjacent", &SpatRaster::adjacent, "adjacent")
		.method("aggregate", &SpatRaster::aggregate, "aggregate")
		.method("get_aggregates", &SpatRaster::get_aggregates, "get_aggregates")
		.method("get_aggregate_dims", &SpatRaster::get_aggregate_dims2, "get_aggregate_dims")
		.method("arith_rast", ( SpatRaster (SpatRaster::*)(SpatRaster, std::string, SpatOptions&) )( &SpatRaster::arith ))
		.method("arith_numb", ( SpatRaster (SpatRaster::*)(double, std::string, SpatOptions&) )( &SpatRaster::arith ))
		.method("arith_rev", &SpatRaster::arith_rev, "arith_rev")
		.method("area", &SpatRaster::area, "area")
		.method("as_points", &SpatRaster::as_points, "as_points")
		.method("as_polygons", &SpatRaster::as_polygons, "as_polygons")
		.method("gridDistance", &SpatRaster::gridDistance, "gridDistance")
		.method("clamp", &SpatRaster::clamp, "clamp")
		.method("crop", &SpatRaster::crop, "crop")
		.method("cum", &SpatRaster::cum, "cum")
		.method("disaggregate", &SpatRaster::disaggregate, "disaggregate")
		.method("extractCell", &SpatRaster::extractCell, "extractCell")
		.method("extractVector", &SpatRaster::extractVector, "extractVector")
		.method("focal", &SpatRaster::focal, "focal")
		.method("focalValues", &SpatRaster::focal_values, "focalValues")
		
		.method("logic_rast", ( SpatRaster (SpatRaster::*)(SpatRaster, std::string, SpatOptions&) )( &SpatRaster::logic ))
		.method("logic_numb", ( SpatRaster (SpatRaster::*)(bool, std::string, SpatOptions&) )( &SpatRaster::logic ))
		.method("mask", &SpatRaster::mask, "mask")
		.method("math", &SpatRaster::math, "math")
		.method("rasterizeLines", &SpatRaster::rasterizeLines, "rasterizeLines")
		.method("rasterizePolygons", &SpatRaster::rasterizePolygons, "rasterizePolygons")
		.method("sampleRegular", &SpatRaster::sampleRegular, "sampleRegular")		
		.method("summary", &SpatRaster::summary, "summary")
		.method("summary_numb", &SpatRaster::summary_numb, "summary_numb")
		.method("trig", &SpatRaster::trig, "trig")
		.method("trim", &SpatRaster::trim, "trim")
		.method("warp", &SpatRaster::warp, "warp")
		
		//.method("rcppAdjacent", &rcppAdjacent, "rcppAdjacent")
		.method("rcppReclassify", &rcppReclassify, "rcppReclassify")
	
	;
}

