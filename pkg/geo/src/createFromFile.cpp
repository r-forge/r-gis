using namespace std;
#include <string>
#include <vector>
#include "geo.h"
#include "SimpleIni.h"


std::vector<double> s2d(std::vector<string> s) { 
  std::vector<double> d (s.size());
  std::transform(s.begin(), s.end(), d.begin(), [](const std::string& val) {
    return std::stod(val);
  });
  return d;
}


std::vector<std::string> strsplit(std::string s, std::string delimiter){
  std::vector<std::string> out;
  size_t pos = 0;
  std::string token;
  while ((pos = s.find(delimiter)) != std::string::npos) {
    token = s.substr(0, pos);
    out.push_back(token);
    s.erase(0, pos + delimiter.length());
  }
  token = s.substr(0, pos);
  out.push_back(token);
  return out;
}


string getFileExt(const string& s) {
	size_t i = s.rfind('.', s.length());
	if (i != string::npos) {
		return(s.substr(i, s.length() - i));
	}
	return("");
}

string setFileExt(const string& s, const string& ext) {
	size_t i = s.rfind('.', s.length());
	if (i != string::npos) {
		return(s.substr(0, i) + ext);
	}
	return(s + ext);
}


bool GeoRaster::createFromFile(std::string fname) {
	
	string ext = getFileExt(fname);
	
	if (ext == ".grd") {
		CSimpleIniA ini(TRUE, FALSE, FALSE);
		char ss[fname.length()];
		strcpy(ss, fname.c_str());
		SI_Error rc = ini.LoadFile(ss);
		if (rc < 0) {
			return false;
			
		} else {
			
			unsigned nrows = atoi(ini.GetValue("georeference", "nrows"));
			unsigned ncols = atoi(ini.GetValue("georeference", "ncols"));
			double xmin = atof(ini.GetValue("georeference", "xmin"));
			double xmax = atof(ini.GetValue("georeference", "xmax"));
			double ymin = atof(ini.GetValue("georeference", "ymin"));
			double ymax = atof(ini.GetValue("georeference", "ymax"));	
			std::vector<double> e {xmin, xmax, ymin, ymax};
			if (nlyr() == 0) {
				setExtent(e);
				ncol = ncols;
				nrow = nrows;
			} else if (!compare(nrows, ncols, extent)) {
				return false;
			}
			string crs = ini.GetValue("georeference", "projection");
			string dtp = ini.GetValue("data", "datatype");
			int nbnd = atoi(ini.GetValue("data", "nbands"));

			string smin = ini.GetValue("data", "minvalue");
			string smax = ini.GetValue("data", "maxvalue");
			std::vector<string> vmin = strsplit(smin, ":");
			std::vector<string> vmax = strsplit(smax, ":");
			std::vector<double> dmin = s2d(vmin);
			std::vector<double> dmax = s2d(vmax);	
			range[0].insert(range[0].end(), dmin.begin(), dmin.end());
			range[1].insert(range[1].end(), dmax.begin(), dmax.end());
			for (unsigned i=0; i< vmin.size(); i++) {
				hasRange.push_back( true );
			}

			string snames = ini.GetValue("description", "layername");
			std::vector<string> vnames = strsplit(snames, ":");
			names.insert(names.end(), vnames.begin(), vnames.end());

			double vna  = atof(ini.GetValue("data", "nodatavalue"));
			
			source.filename.push_back( setFileExt(fname, ".gri") );
			source.datatype.push_back (dtp);
			source.nlayers.push_back(nbnd);
			
			hasValues = true; 
			source.memory.push_back(false);
			source.driver.push_back("raster");
			source.NAflag.push_back(vna);

			//source.layers.push_back( std::vector<int> )
	
			setCRS(crs);
			
			return true;
		}
	} else {
	
		return false;
   }
   return true;
}


