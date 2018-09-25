//source http://alienryderflex.com/polygon/

using namespace std;
#include <vector>
#include "spat.h"
  
std::vector<bool> points_in_polygon(std::vector<double> polX, std::vector<double> polY, std::vector<double> pX, std::vector<double> pY) {

	unsigned nodes = polX.size();
	std::vector<double> constant(nodes);
	std::vector<double> multiple(nodes);
	std::vector<bool> result(nodes);
	
	size_t j = nodes-1 ;
	for(size_t i=0; i < nodes; i++) {
		if (polY[j] == polY[i]) {
			constant[i] = polX[i];
			multiple[i] = 0; 
		} else {
			constant[i] = polX[i]-(polY[i]*polX[j])/(polY[j]-polY[i])+(polY[i]*polX[i])/(polY[j]-polY[i]);
			multiple[i] = (polX[j]-polX[i])/(polY[j]-polY[i]); 
		}
		j=i;
	}

	j = nodes-1;
	for (size_t p=0; p<nodes; p++) {
		bool oddNodes = false;
		double x = pX[p];
		double y = pY[p];
		
		for (size_t i=0; i< nodes; i++) {
			if ((((polY[i]< y) && (polY[j]>=y)) || ((polY[j]< y) && (polY[i]>=y)))) {
				oddNodes ^= (y * multiple[i]+constant[i] < x); 
			}
			j=i; 
		}
		result[p] = oddNodes;
	}
	return result;
}



std::vector<int> pointsInPolygons(SpatPolygons pol, std::vector<double> pX, std::vector<double> pY) {

	unsigned n = pol.size();	
	std::vector<int> result(n, -1);
	
	for (size_t j = 0; j < n; j++) {
			
		SpatPoly poly = pol.getPoly(j);
		unsigned np = poly.size();
		std::vector<bool> inside;	
		for (size_t k = 0; k < np; k++) {
			SpatPolyPart part = poly.getPart(k);
			if (part.hasHoles()) {
				inside = points_in_polygon(part.x, part.y, pX, pY);
				for (size_t h=0; h < part.nHoles(); h++) {
					std::vector<bool> inhole = points_in_polygon(part.x, part.y, pX, pY);
					for (size_t i=0; i<pX.size(); i++) {
						if (inhole[i]) inside[i] = false;
					}
					// remove inhole from inside
				}
			} else {
				inside = points_in_polygon(part.x, part.y, pX, pY);
			}
			for (size_t i=0; i<pX.size(); i++) {
				if (inside[i]) result[i] = j;
			}
		}
	}
	return result;
}
	