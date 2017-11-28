using namespace std;
#include <string>
#include <vector>
#include "geo.h"
#include "SimpleIni.h"
#include "util.h"


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
			GeoExtent e(xmin, xmax, ymin, ymax);
			if (nlyr() == 0) {
				setExtent(e, false);
				ncol = ncols;
				nrow = nrows;
				
			} else if (!compare(nrows, ncols, e)) {
				return false;
			}
			
			string crs = ini.GetValue("georeference", "projection");
			string dtp = ini.GetValue("data", "datatype");
			int nbnd = atoi(ini.GetValue("data", "nbands"));

			string smin = ini.GetValue("data", "minvalue");
			string smax = ini.GetValue("data", "maxvalue");
			std::vector<string> vmin = strsplit(smin, ":");
			std::vector<string> vmax = strsplit(smax, ":");
			std::vector<double> dmin = str2double(vmin);
			std::vector<double> dmax = str2double(vmax);	
			
			range.resize(2, std::vector<double>(nbnd));
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
	 /// gdal files
	 
		return false;
   }
   return true;
}


