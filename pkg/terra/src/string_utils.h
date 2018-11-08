bool file_exists(const std::string& name);
std::string concatenate(std::vector<std::string> v, std::string delim);
void lowercase(std::string &s);
bool is_in_set(std::string s, std::vector<std::string> ss);
std::string is_in_set_default(std::string s, std::vector<std::string> ss, std::string defvalue, bool tolower);
std::vector<std::string> strsplit(std::string s, std::string delimiter);
std::vector<double> str2dbl(std::vector<std::string> s);
std::vector<std::string> dbl2str(std::vector<double> d);
std::string getFileExt(const std::string& s);
std::string setFileExt(const std::string& s, const std::string& ext);
std::string basename(std::string filename);
void lrtrim(std::string &s);

