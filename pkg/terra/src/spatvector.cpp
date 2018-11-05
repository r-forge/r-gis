#include "spatVector.h"

SpatHole::SpatHole() {}

SpatHole::SpatHole(std::vector<double> X, std::vector<double> Y) {	
	x = X; y = Y;  
	extent.xmin = *std::min_element(X.begin(), X.end());
	extent.xmax = *std::max_element(X.begin(), X.end());
	extent.ymin = *std::min_element(Y.begin(), Y.end());
	extent.ymax = *std::max_element(Y.begin(), Y.end());
}

bool SpatPart::addHole(std::vector<double> X, std::vector<double> Y) { 
	SpatHole h(X, Y);	
	holes.push_back(h);
	// check if inside pol?
	return true;
}


bool SpatPart::addHole(SpatHole h) { 
	holes.push_back(h);
	// check if inside pol?
	return true;
}


SpatPart::SpatPart() {}

SpatPart::SpatPart(double X, double Y) {
	x.push_back(X); 
	y.push_back(Y);  
	extent.xmin = X;
	extent.xmax = X;
	extent.ymin = Y;
	extent.ymax = Y;
}

SpatPart::SpatPart(std::vector<double> X, std::vector<double> Y) { 
	x = X; y = Y;  
	extent.xmin = *std::min_element(X.begin(), X.end());
	extent.xmax = *std::max_element(X.begin(), X.end());
	extent.ymin = *std::min_element(Y.begin(), Y.end());
	extent.ymax = *std::max_element(Y.begin(), Y.end());
}


SpatGeom::SpatGeom() {};

SpatGeom::SpatGeom(SpatPart p) {
	parts.push_back(p); 
	extent = p.extent;			
}
		
bool SpatGeom::addPart(SpatPart p) { 
	parts.push_back(p); 
	if (parts.size() > 1) {
		extent.unite(p.extent);
	} else {
		extent = p.extent;
	}
	return true; 
}

bool SpatGeom::addHole(SpatHole h) { 
	long i = parts.size()-1;
	if (i > -1) {
		parts[i].addHole(h);
		return true;
	} else {
		return false;
	}
}


bool SpatGeom::setPart(SpatPart p, unsigned i) { 
	parts[i] = p; 
	if (parts.size() > 1) {
		extent.unite(p.extent);
	} else {
		extent = p.extent;
	}
	return true; 
}

SpatPart SpatGeom::getPart(unsigned i) { 
	return parts[i]; 
}

std::vector<double> SpatLayer::getDv(unsigned i) {
	unsigned j = df.iplace[i];
	return df.dv[j];
}

std::vector<long> SpatLayer::getIv(unsigned i){
	unsigned j = df.iplace[i];
	return df.iv[j];
}

std::vector<std::string> SpatLayer::getSv(unsigned i){
	unsigned j = df.iplace[i];
	return df.sv[j];
}

std::vector<unsigned> SpatLayer::getItype(){
	return df.itype;
}

std::vector<unsigned> SpatLayer::getIplace(){
	return df.iplace;
}

std::vector<std::string> SpatLayer::names(){
	return df.names;
}

unsigned SpatLayer::ncol() {
	return df.ncol();
}

unsigned SpatLayer::nrow() {
	return geoms.size();
}

unsigned SpatLayer::size() {
	return geoms.size();
}


SpatExtent SpatLayer::getExtent(){
	return extent;
}

std::string SpatLayer::getCRS(){
	return crs;
}

void SpatLayer::setCRS(std::string CRS){
	crs = CRS;
}


std::string SpatLayer::type(){
	if (size() == 0) {
		return "none";
	} else if (geoms[0].gtype == 0) {
		return "points";
	} else if (geoms[0].gtype == 1) {
		return "lines";
	} else if (geoms[0].gtype == 2) {
		return "polygons";		
	} else {
		return("unknown");
	}
}

double SpatGeom::area(){
	return 0;
}

std::vector<double> SpatLayer::area(){
	unsigned n = size();
	std::vector<double> out(n);
	SpatGeom g;
	for (size_t i=0; i<n; i++) {
		g = getGeom(i);
		out[i] = g.area();
	}
	return(out);
};

double SpatGeom::length(){
	return 0;
}

std::vector<double> SpatLayer::length() {
	unsigned n = size();
	std::vector<double> out(n);
	SpatGeom g;
	for (size_t i=0; i<n; i++) {
		g = getGeom(i);
		out[i] = g.length();
	}
	return(out);	
};



SpatGeom SpatLayer::getGeom(unsigned i) { 
	return geoms[i]; 
}

bool SpatLayer::addGeom(SpatGeom p) { 
	geoms.push_back(p); 
	if (geoms.size() > 1) {
		extent.unite(p.extent);
	} else {
		extent = p.extent;
	}
	return true; 
}


unsigned SpatLayer::nxy() {
	unsigned n = 0;
	for (size_t i=0; i < size(); i++) {
		SpatGeom g = getGeom(i);
		for (size_t j=0; j < g.size(); j++) {
			SpatPart p = g.getPart(j);
			n += p.x.size();
			if (p.hasHoles()) {
				for (size_t k=0; k < p.nHoles(); k++) {
					SpatHole h = p.getHole(k);
					n += h.x.size();
				}
			}
		}
	}
	return n;
}

SpatDataFrame SpatLayer::getGeometryDF() {
	unsigned n = nxy();

	SpatGeom g;
	SpatPart p;
	SpatHole h;
	SpatDataFrame out;
	
	out.add_column(1, "geom");
	out.add_column(1, "part");
	out.add_column(0, "x");
	out.add_column(0, "y");
	out.add_column(1, "hole");
	out.resize(n);
	
	size_t idx = 0;
	for (size_t i=0; i < size(); i++) {
		g = getGeom(i);
		for (size_t j=0; j < g.size(); j++) {
			p = g.getPart(j);
			for (size_t q=0; q < p.x.size(); q++) {
				out.iv[0][idx] = i;
				out.iv[1][idx] = j;
				out.dv[0][idx] = p.x[q];
				out.dv[1][idx] = p.y[q];
				out.iv[2][idx] = 0;
				idx++;
			}
			if (p.hasHoles()) {
				for (size_t k=0; k < p.nHoles(); k++) {
					h = p.getHole(k);
					for (size_t q=0; q < h.x.size(); q++) {
						out.iv[0][idx] = i;
						out.iv[1][idx] = j;
						out.dv[0][idx] = h.x[q];
						out.dv[1][idx] = h.y[q];
						out.iv[2][idx] = 1;
						idx++;
					}
				}
			}
		}
	}
	return out;
}

SpatGeomType SpatLayer::getGType(std::string &type) {
	if (type == "points") { return points; }
	else if (type == "lines") { return lines; }
	else if (type == "polygons") { return polygons; }
	else { return unknown; }
}
	

void SpatLayer::setGeometry(std::string type, std::vector<unsigned> geom, std::vector<unsigned> part, std::vector<double> x, std::vector<double> y, std::vector<bool> hole) {

// it is assumed that values are sorted by geom, part, hole
	
	unsigned lastgeom = geom[0];
	unsigned lastpart = part[0];
	std::vector<double> X, Y;
	X.push_back(x[0]);
	Y.push_back(y[0]);
	bool isHole = hole[0];

	SpatGeom g;
	g.gtype = getGType(type);
	
	for (size_t i=0; i<geom.size(); i++) {
		if ((lastgeom != geom[i]) | (lastpart != part[i])) {
			if (isHole) {
				SpatHole h(X, Y);
				g.addHole(h);
			} else {
				SpatPart p(X, Y);
				g.addPart(p);
			}
			lastpart = part[i];
			isHole = hole[i];
			X.resize(0);
			Y.resize(0);	
			if (lastgeom != geom[i]) {
				addGeom(g);
				g.parts.resize(0);
				lastgeom = geom[i];
			}
		}
		X.push_back(x[i]);
		Y.push_back(y[i]);
	}
	if (isHole) {
		SpatHole h(X, Y);
		g.addHole(h);
	} else {
		SpatPart p(X, Y);
		g.addPart(p);
	}
	addGeom(g);	
}



SpatLayer SpatLayer::subset(std::vector<unsigned> range) { 
	SpatLayer out;
	for (size_t i=0; i < range.size(); i++) {
		out.addGeom( geoms[range[i]] ); 
	}
	out.crs = crs;
	return out;	
};
