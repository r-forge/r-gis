
using namespace std;
#include <vector>
#include "geo.h"


SpatPolygons SpatPolygons::getPart(unsigned polyid, unsigned partid) {
	SpatPolygons p;
	p.n = 1;
	p.id = std::vector<unsigned> {0};
	// check that part <= nparts[poly]
	p.part = p.id;
	p.start = p.id;

	auto i = std::find(id.begin(), id.end(), polyid );
	int ix = std::distance(id.begin(), i);
	auto j = std::find(part.begin()+ix, part.end(), partid );
	int jx = std::distance(part.begin(), j);

	p.end = std::vector<unsigned> { end[jx] - start[jx] };
	p.ishole = std::vector<bool> { ishole[jx] };
	p.hasholes = p.ishole;
	
	std::vector<double>::const_iterator first = x.begin() + start[jx];
	std::vector<double>::const_iterator last  = x.begin() + end[jx];
	p.x = std::vector<double>(first, last);	
	p.y = std::vector<double>(first, last);	
	
	p.hasAttr = hasAttr;
	if (hasAttr) {
		p.attr = std::vector<double> { attr[polyid] }; 
	}
	return(p);
}

