// Copyright (c) 2018-2019  Robert J. Hijmans
//
// This file is part of the "spat" library.
//
// spat is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 2 of the License, or
// (at your option) any later version.
//
// spat is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with spat. If not, see <http://www.gnu.org/licenses/>.

#include <Rcpp.h>
#include "spatRaster.h"


/*
NumericMatrix getValuesM(SpatRaster* r) {
	NumericMatrix x(r->ncell(), r->nlyr() );
	std::vector<double> v;
	v = r->getValues();
	std::copy(v.begin(), v.end(), x.begin());
	return(x);
}
*/

Rcpp::List getBlockSizeR(SpatRaster* r, unsigned n) { 
    BlockSize bs = r->getBlockSize(n);
	Rcpp::List L = Rcpp::List::create(Rcpp::Named("row") = bs.row, Rcpp::Named("nrows") = bs.nrows, Rcpp::Named("n") = bs.n);
	return(L);
}


Rcpp::List getDataFrame(SpatDataFrame* v) {

	unsigned n = v->ncol();
	Rcpp::List out(n);	
	if (n == 0) {
		return(out);
	} 

	std::vector<std::string> nms = v->names;
	std::vector<unsigned> itype = v->itype;
	for (size_t i=0; i < n; i++) {
		if (itype[i] == 0) {
			out[i] = v->getD(i);
		} else if (itype[i] == 1) {
			out[i] = v->getI(i);
		} else {
			out[i] = v->getS(i);
		}
	}	
	out.names() = nms;
	// todo: deal with NAs in int and str
	return out;
//  Rcpp::df is nice, but no of variables is <= 20, 
//  and no "stringsAsFactors"=false
//	Rcpp::DataFrame result(out);
//	result.attr("names") = v->names();
//	return result;
}	



Rcpp::List getAttributes(SpatVector* v) {
	SpatDataFrame df = v->lyr.df;
	Rcpp::List lst = getDataFrame(&df);
	return lst;
}



Rcpp::DataFrame getGeometry(SpatVector* v) {
	SpatDataFrame df = v->getGeometryDF();

	Rcpp::DataFrame out = Rcpp::DataFrame::create(
			Rcpp::Named("id") = df.iv[0], 
			Rcpp::Named("part") = df.iv[1], 
			Rcpp::Named("x") = df.dv[0],
			Rcpp::Named("y") = df.dv[1],
			Rcpp::Named("hole") = df.iv[2]
	);
	return out;
}


/*
bool setAttributes(SpatVector* v, Rcpp::List x, std::vector<std::string> names, std::vector<std::string> types) {
	unsigned n = x.size();
	std::vector<double> vd;
	std::vector<long> vi;
	std::vector<std::string> vs;
	
	for (size_t i=0; i < n; i++) {
		Rcpp::NumericVector nv = x[i];
		if (types[i] == "numeric") {
			vd = Rcpp::as<std::vector<double> >(nv);
			v->lyr.df.add_column(vd, names[i]);
		} else if (types[i] == "integer") {
			vi = Rcpp::as<std::vector<long> >(nv);
			v->lyr.df.add_column(vi, names[i]);
		} else {
			vs = Rcpp::as<std::vector<std::string> >(nv);
			v->lyr.df.add_column(vs, names[i]);
		}
	}
	return true;
}
*/

/*
SpatRaster rcppReclassify(SpatRaster* x, Rcpp::NumericMatrix rcl, unsigned right, bool lowest, bool othersNA, SpatOptions &opt) {
	unsigned nc = rcl.ncol();
	unsigned nr = rcl.nrow();
	//printf("nc %u nr %u \n", nr, nr);
	std::vector< std::vector<double>> rc(nc);
	for (size_t c=0; c<nc; c++) {
		for (size_t r=0; r<nr; r++) {
			rc[c].push_back(rcl(r,c));
		}
	}
	SpatRaster out = x->reclassify(rc, right, lowest, othersNA, opt);
	return out;
}
*/

/*
Rcpp::NumericMatrix rcppAdjacent(SpatRaster* x, std::vector<double> cells, std::string directions, bool include) {
	
	std::vector<std::vector<double>> a = x->adjacent(cells, directions, include);

	unsigned nr = a.size();
	unsigned nc = a[0].size();
	Rcpp::NumericMatrix m(nr, nc);
	for (size_t i=0; i<nr; i++) {
		for (size_t j=0; j<nc; j++) {
			m(i,j) = a[i][i];
		}
	}
	return m;
}
*/


