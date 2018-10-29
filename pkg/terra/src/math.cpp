using namespace std;
#include "spat.h"
#include <functional>


template <typename T> int sign(T value) {
    return (T(0) < value) - (value < T(0));
}


SpatRaster SpatRaster::math(std::string fun, std::string filename, bool overwrite) {

	SpatRaster out = geometry();
	std::vector<string> f {"abs", "sqrt", "ceiling", "floor", "trunc", "log", "log10", "log2", "log1p", "exp", "expm1", "sign"}; 
	if (std::find(f.begin(), f.end(), fun) == f.end()) {
		out.error = true;
		out.error_message = "unknown math function";
		return out;
	}

  	out.writeStart(filename, overwrite);
	readStart();
	for (size_t i = 0; i < out.bs.n; i++) {
		std::vector<double> a = readBlock(out.bs, i);
		if (fun == "sqrt") {
			for(double& d : a) if (!std::isnan(d)) d = sqrt(d);
		} else if (fun == "abs") {
			for(double& d : a) if (!std::isnan(d)) d = abs(d);
		} else if (fun == "log") {
			for(double& d : a) if (!std::isnan(d)) d = log(d);
		} else if (fun == "log2") {
			for(double& d : a) if (!std::isnan(d)) d = log2(d);
		} else if (fun == "log10") {
			for(double& d : a) if (!std::isnan(d)) d = log10(d);
		} else if (fun == "log1p") {
			for(double& d : a) if (!std::isnan(d)) d = log1p(d);
		} else if (fun == "exp") {
			for(double& d : a) if (!std::isnan(d)) d = exp(d);
		} else if (fun == "expm1") {
			for(double& d : a) if (!std::isnan(d)) d = expm1(d);			
		} else if (fun == "sign") {
			for(double& d : a) if (!std::isnan(d)) d = sign(d);
		} else if (fun == "ceiling") {
			for(double& d : a) if (!std::isnan(d)) d = ceil(d);
		} else if (fun == "floor") {
			for(double& d : a) if (!std::isnan(d)) d = floor(d);
		} else if (fun == "trunc") {
			for(double& d : a) if (!std::isnan(d)) d = trunc(d);
		} 
		out.writeValues(a, out.bs.row[i]);
	}
	out.writeStop();
	readStop();		
	return(out);
}


SpatRaster SpatRaster::trig(std::string fun, std::string filename, bool overwrite) {

	SpatRaster out = geometry();

	std::vector<string> f {"acos", "asin", "atan", "cos", "sin", "tan", "acosh", "asinh", "atanh", "cosh", "cospi", "sinh", "sinpi", "tanh", "tanpi"}; 
	if (std::find(f.begin(), f.end(), fun) == f.end()) {
		out.error = true;
		out.error_message = "unknown trig function";
		return out;
	}
	
  	out.writeStart(filename, overwrite);
	readStart();
	for (size_t i = 0; i < out.bs.n; i++) {
		std::vector<double> a = readValues(out.bs.row[i], out.bs.nrows[i], 0, ncol, 0, nlyr());
		if (fun == "sin") {
			for(double& d : a) if (!std::isnan(d)) d = sin(d);
		} else if (fun == "cos") {
			for(double& d : a) if (!std::isnan(d)) d = cos(d);
		} else if (fun == "tan") {
			for(double& d : a) if (!std::isnan(d)) d = tan(d);
		} else if (fun == "asin") {
			for(double& d : a) if (!std::isnan(d)) d = asin(d);
		} else if (fun == "acos") {
			for(double& d : a) if (!std::isnan(d)) d = acos(d);
		} else if (fun == "atan") {
			for(double& d : a) if (!std::isnan(d)) d = atan(d);
		} else if (fun == "sinh") {
			for(double& d : a) if (!std::isnan(d)) d = sinh(d);
		} else if (fun == "cosh") {
			for(double& d : a) if (!std::isnan(d)) d = cosh(d);
		} else if (fun == "tanh") {
			for(double& d : a) if (!std::isnan(d)) d = tanh(d);
		} else if (fun == "asinh") {
			for(double& d : a) if (!std::isnan(d)) d = asinh(d);
		} else if (fun == "acosh") {
			for(double& d : a) if (!std::isnan(d)) d = acosh(d);
		} else if (fun == "atanh") {
			for(double& d : a) if (!std::isnan(d)) d = atanh(d);
		} else if (fun == "sinpi") {
			for(double& d : a) if (!std::isnan(d)) d = sin(d * M_PI);
		} else if (fun == "cospi") {
			for(double& d : a) if (!std::isnan(d)) d = cos(d * M_PI);
		} else if (fun == "tanpi") {
			for(double& d : a) if (!std::isnan(d)) d = tan(d * M_PI);
		} 
		out.writeValues(a, out.bs.row[i]);
	}
	out.writeStop();
	readStop();		
	return(out);
}

