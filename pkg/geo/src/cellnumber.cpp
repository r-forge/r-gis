using namespace std;

#include "geo.h"
#include <cmath>



std::vector<double> GeoRaster::cellFromXY (std::vector<double> x, std::vector<double> y) {

// size of x and y should be the same
	size_t size = x.size();
	std::vector<double> cells(size);
	
	double yr_inv = nrow / (extent.ymax - extent.ymin);
	double xr_inv = ncol / (extent.xmax - extent.xmin);
  
	for (size_t i = 0; i < size; i++) {
		// cannot use trunc here because trunc(-0.1) == 0
		double row = std::floor((extent.ymax - y[i]) * yr_inv);
		// points in between rows go to the row below
		// except for the last row, when they must go up
		if (y[i] == extent.ymin) {  
			row = nrow-1 ;
		}
		
		double col = floor((x[i] - extent.xmin) * xr_inv);
		// as for rows above. Go right, except for last column
		if (x[i] == extent.xmax) {
			col = ncol - 1 ;
		}
		
		if (row < 0 || row >= nrow || col < 0 || col >= ncol) {
			cells[i] = NAN;
		} else {
			// result[i] = static_cast<int>(row) * ncols + static_cast<int>(col) + 1;
			cells[i] = row * ncol + col + 1 ;
		}
	}
  
	return cells;
}


double GeoRaster::cellFromXY (double x, double y) {
	std::vector<double> X = {x};
	std::vector<double> Y = {y};
	std::vector<double> cell = cellFromXY(X, Y);
	return  cell[0]; 
}


std::vector<double> GeoRaster::cellFromRowCol(std::vector<unsigned> rownr, std::vector<unsigned> colnr) {

	
	size_t rownr_size = rownr.size();
	size_t colnr_size = colnr.size();
  
	std::vector<double> result(std::max(rownr_size, colnr_size));

  // Manually recycle the shorter of rownr/colnr to match the other
	size_t len = std::max(rownr.size(), colnr.size());

	for (size_t i = 0; i < len; i++) {
    // The % is to recycle elements if they're not the same length
		double r = rownr[i < rownr_size ? i : i % rownr_size];
		double c = colnr[i < colnr_size ? i : i % colnr_size];

    // Detect out-of-bounds rows/cols and use NA for those
		result[i] = (r < 1 || r > nrow || c < 1 || c > ncol) ? NAN : (r-1) * ncol + c;
	}
  
	return result;
}


double GeoRaster::cellFromRowCol (unsigned rownr, unsigned colnr) {
	std::vector<unsigned> rows = {rownr};
	std::vector<unsigned> cols = {colnr};
	std::vector<double> cell = cellFromRowCol(rows, cols);
	return  cell[0]; 
}


std::vector<double> GeoRaster::yFromRow(std::vector<unsigned> rownr) {
	size_t size = rownr.size();
	std::vector<double> result( size );
	double ymax = extent.ymax;
	double yr = double(resolution()[1]);
	for (size_t i = 0; i < size; i++) {
		result[i] = (rownr[i] < 1 || rownr[i] > nrow ) ? NAN : ymax - ((rownr[i]-0.5) * yr);
	}
	return result;
}
	
double GeoRaster::yFromRow (unsigned rownr) {
	std::vector<unsigned> rows = {rownr};
	std::vector<double> y = yFromRow(rows);
	return y[0]; 
}



std::vector<double> GeoRaster::xFromCol(std::vector<unsigned> colnr) {
	size_t size = colnr.size();
	std::vector<double> result( size );
	double xmin = extent.xmin;
	double xr = xres();
	for (size_t i = 0; i < size; i++) {
		result[i] = (colnr[i] < 1 || colnr[i] > ncol ) ? NAN : xmin + ((colnr[i]-0.5) * xr);
	}
	return result;
}
	
double GeoRaster::xFromCol(unsigned colnr) {
	std::vector<unsigned> cols = {colnr};
	std::vector<double> x = xFromCol(cols);
	return x[0]; 
}

std::vector<unsigned> GeoRaster::colFromX(std::vector<double> x) {
	size_t size = x.size();
	std::vector<unsigned> result( size );
	double xmin = extent.xmin;
	double xmax = extent.xmax;
	double xr = xres();
	
	for (size_t i = 0; i < size; i++) {
		if (x[i] == xmax) {  
			result[i] = ncol ;
		} else {
			result[i] = (x[i] < xmin || x[i] > xmax ) ? NAN : ((x[i] - xmin) / xr) + 1;
		}
	}
	return result;
}


unsigned GeoRaster::colFromX(double x) {
	std::vector<double> X = {x};
	std::vector<unsigned> col = colFromX(X);
	return col[0]; 
}


std::vector<unsigned> GeoRaster::rowFromY(std::vector<double> y) {
	size_t size = y.size();
	std::vector<unsigned> result( size );
	double ymin = extent.ymin;
	double ymax = extent.ymax;
	double yr = double(resolution()[1]);
	
	for (size_t i = 0; i < size; i++) {
		if (y[i] == ymin) {  
			result[i] = nrow ;
		} else {
			result[i] = (y[i] < ymin || y[i] > ymax ) ? NAN : ((ymax - y[i]) / yr) + 1;
		}
	}
	return result;
}

unsigned GeoRaster::rowFromY(double y) {
	std::vector<double> Y = {y};
	std::vector<unsigned> row = rowFromY(Y);
	return row[0]; 
}



std::vector< std::vector<double> > GeoRaster::xyFromCell( std::vector<double> cell ) {
	size_t size = cell.size();
	double xmin = extent.xmin;
	double ymax = extent.ymax;
	double yr = yres();
	double xr = xres();
  
	std::vector< std::vector<double> > result(2, std::vector<double> (size) );
	for (size_t i = 0; i < size; i++) {
		double c = cell[i] - 1;
		size_t col = fmod(c, ncol);
		size_t row = (c / ncol);
		result[0][i] = (col + 0.5) * xr + xmin;
		result[1][i] = ymax - (row + 0.5) * yr;
	}
	return result;
}


std::vector< std::vector<double> > GeoRaster::xyFromCell( double cell ) {
	std::vector<double> Cell = {cell};
	std::vector< std::vector<double> >  xy = xyFromCell(Cell);
	return xy; 
}


std::vector< std::vector<unsigned> > GeoRaster::rowColFromCell(std::vector<double> cell) {
	size_t size = cell.size();
	std::vector< std::vector<unsigned> > result(2, std::vector<unsigned> (size) );

	double nc = ncell();
	
	for (size_t i = 0; i < size; i++) {
		if ((cell[i] < 1 || cell[i] > nc )) {  
			result[0][i] = -1;
			result[1][i] = -1;
		} else {
			result[0][i] = ((cell[i] -1)/ ncol) + 1;
			result[1][i] = (cell[i] - ((result[0][i] - 1) * ncol));
		}
	}
	return result;
}
