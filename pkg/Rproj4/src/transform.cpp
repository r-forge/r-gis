#include <Rcpp.h>
using namespace Rcpp;

#include "proj_api.h"
#include<string>

const char* toConstChar(std::string s){ return s.c_str(); }

// [[Rcpp::export(name = "checkCRS")]]
bool pjcheckcrs(String crs) {
	if (pj_init_plus(toConstChar(crs))) {
		return true;
	} else {
		return false;	
	}
}

// [[Rcpp::export(name = ".pjtransform")]]
NumericMatrix pjtransform3(NumericVector x, NumericVector y, String pj_in, String pj_out) {
    projPJ pj_input, pj_output;
	
	NumericMatrix error(1, 1);
	error(0,0) = 0;
    if (!(pj_input = pj_init_plus(toConstChar(pj_in)))) 
		return error;
    if (!(pj_output = pj_init_plus(toConstChar(pj_out))))
		return error;

	int n = x.length();
	NumericMatrix out(n, 2);

	if (pj_is_latlong(pj_input)) {
        x = x * DEG_TO_RAD;
        y = y * DEG_TO_RAD;
	}

	pj_transform(pj_input, pj_output, n, 1, x.begin(), y.begin(), NULL );

	if (pj_is_latlong(pj_output)) {
        x = x * RAD_TO_DEG;
        y = y * RAD_TO_DEG;
	}

	out( _ , 0) = x;
	out( _ , 1) = y;

	return out;
}

