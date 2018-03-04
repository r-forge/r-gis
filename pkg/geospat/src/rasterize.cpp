// Based on  public-domain code by Darel Rex Finley, 2007
// http://alienryderflex.com/polygon_fill/

using namespace std;
#include <vector>
#include "geo.h"
  
std::vector<double> rasterize_single_polygon(std::vector<double> r, double value, std::vector<double> pX, std::vector<double> pY, int nrows, int ncols, double xmin, double ymax, double rx, double ry) {

  int i, j, nodes, row, col ;
  int n = pX.size();
  std::vector<int> nCol(n);
  
  for (row=0; row<nrows; row++) {
  
    double y = ymax - (row+0.5) * ry;
    
    //  Build a list of nodes.
    nodes = 0; 
    j = n-1;
    for (i=0; i<n; i++) {
      if (((pY[i] < y) && (pY[j] >= y)) ||   ((pY[j] < y) && (pY[i] >= y))) {
        nCol[nodes++]=(int)  (((pX[i] - xmin + (y-pY[i])/(pY[j]-pY[i]) * (pX[j]-pX[i])) + 0.5 * rx ) / rx); 
      }
      j = i; 
    }
    
    std::sort(nCol.begin(), nCol.begin()+nodes);
    
    //  Fill the pixels between node pairs.
    for (i=0; i < nodes; i+=2) {
      if (nCol[i] >= ncols) break;
      if (nCol[i+1] > 0) {
        if (nCol[i] < 0) nCol[i]=0 ;
        if (nCol[i+1] > ncols) nCol[i+1] = ncols;
        int ncell = ncols * row;
        for (col = nCol[i]; col < nCol[i+1]; col++) {
           r[col + ncell] = value;
        }
      }
    }
  }
  return(r);
}  

GeoRaster GeoRaster::rasterizePolygons(SpatPolygons p, string filename, bool overwrite) {

	GeoRaster out = *this;
	out.values.resize(0);
  	out.writeStart(filename, overwrite);
	
	double value = 1;
	double resx = xres();
	double resy = yres();
	
	SpatPolygons poly;
	
	for (size_t i = 0; i < out.bs.n; i++) {
		std::vector<double> v(out.bs.nrows[i] * ncol);

		for (size_t j = 0; j < p.n; j++) {
			unsigned np = p.nparts[j];
			for (size_t k = 0; k < np; k++) {
				poly = p.getPart(j, k);
				v = rasterize_single_polygon(v, value, poly.x, poly.y, nrow, ncol, extent.xmin, extent.ymax, resx, resy);
			}
		}
		out.writeValues(v, out.bs.row[i]);
	}
	out.writeStop();
	
	return(out);

}
	