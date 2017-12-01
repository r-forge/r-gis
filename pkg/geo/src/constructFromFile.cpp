using namespace std;
#include <string>
#include <vector>
#include "geo.h"
#include "SimpleIni.h"
#include "util.h"


bool GeoRaster::constructFromFile(std::string fname) {
	
	string ext = getFileExt(fname);
	
	if (ext == ".grd") {
		CSimpleIniA ini(TRUE, FALSE, FALSE);
		char ss[fname.length()];
		strcpy(ss, fname.c_str());
		SI_Error rc = ini.LoadFile(ss);
		if (rc < 0) {
			return false;
			
		} else {

			double xmin = atof(ini.GetValue("georeference", "xmin"));
			double xmax = atof(ini.GetValue("georeference", "xmax"));
			double ymin = atof(ini.GetValue("georeference", "ymin"));
			double ymax = atof(ini.GetValue("georeference", "ymax"));	
			GeoExtent e(xmin, xmax, ymin, ymax);

			std::vector<double> dmin, dmax; 			
			unsigned nlyrs;
			
			unsigned version = atoi(ini.GetValue("version", "version", "1"));
			if (version == 1) {
				unsigned nrows = atoi(ini.GetValue("georeference", "nrows"));
				unsigned ncols = atoi(ini.GetValue("georeference", "ncols"));
				GeoExtent e(xmin, xmax, ymin, ymax);
				if (nlyr == 0) {
					setExtent(e, false);
					ncol = ncols;
					nrow = nrows;
					
				} else if (!compare(nrows, ncols, e)) {
					return false;
				}
				
				string crs = ini.GetValue("georeference", "projection");

				string dtp = ini.GetValue("data", "datatype");
				nlyrs = atoi(ini.GetValue("data", "nbands"));
				double vna  = atof(ini.GetValue("data", "nodatavalue"));

				string smin = ini.GetValue("data", "minvalue");
				string smax = ini.GetValue("data", "maxvalue");
				dmin = str2dbl(strsplit(smin, ":"));
				dmax = str2dbl(strsplit(smax, ":"));	

				string snames = ini.GetValue("description", "layername");
				std::vector<string> vnames = strsplit(snames, ":");
				names.insert(names.end(), vnames.begin(), vnames.end());

				source.datatype.push_back (dtp);
				source.nlayers.push_back(nlyrs);		
				hasValues = true; 
				source.NAflag.push_back(vna);
				
			} else {  // version 2
			
				unsigned nrows = atoi(ini.GetValue("georeference", "nrows"));
				unsigned ncols = atoi(ini.GetValue("georeference", "ncols"));
				if (nlyr == 0) {
					setExtent(e, false);
					ncol = ncols;
					nrow = nrows;
					
				} else if (!compare(nrows, ncols, e)) {
					return false;
				}
				
				string crs = ini.GetValue("georeference", "projection");
				string dtp = ini.GetValue("data", "datatype");
				nlyrs = atoi(ini.GetValue("data", "nlyr"));

				string smin = ini.GetValue("data", "range_min");
				string smax = ini.GetValue("data", "range_max");
				std::vector<double> dmin = str2dbl(strsplit(smin, ":"));
				std::vector<double> dmax = str2dbl(strsplit(smax, ":"));	

				string snames = ini.GetValue("description", "layername");
				std::vector<string> vnames = strsplit(snames, ":");
				names.insert(names.end(), vnames.begin(), vnames.end());

				double vna  = atof(ini.GetValue("data", "nodatavalue"));
				source.datatype.push_back (dtp);
				source.nlayers.push_back(nlyrs);		
				hasValues = true; 
				source.NAflag.push_back(vna);
			}

			//source.layers.push_back( std::vector<int> )

			for (unsigned i=0; i<nlyrs; i++) {
				hasRange.push_back( true );
				range_min.push_back(dmin[i]);
				range_max.push_back(dmax[i]);
			}
			//range[0].insert(range[0].end(), dmin.begin(), dmin.end());
			//range[1].insert(range[1].end(), dmax.begin(), dmax.end());
			
			source.memory.push_back(false);
			source.filename.push_back( setFileExt(fname, ".gri") );
			source.driver.push_back("raster");
			setCRS(crs);
			setnlyr();

			return true;
		}
	} else {
	 /// gdal files

	 
		return false;
   }
   return true;
}


