using namespace std;
#include <algorithm> 
#include <cctype>
#include <locale>
#include <set>
#include <string>


std::string concatenate(std::vector<string> v, std::string delim) {	
	for (size_t i=0; i<(v.size()-1); i++) {
		v[i] = v[i] + delim;
	}
	std::string s;
	for (const auto &piece : v) s += piece;
	return s;
}

bool is_equal(double a, double b, double error_factor=1.0) {
	return a==b || std::abs(a-b)<std::abs(std::min(a,b))*std::numeric_limits<double>::epsilon()*error_factor;
}

bool is_equal_range(double x, double y, double range, double tolerance) {
	return (fabs(x - y) / range) < tolerance ;
}

void lowercase(std::string &s) {
	std::transform(s.begin(), s.end(), s.begin(), ::tolower);
}

bool is_in_set(string s, std::vector<string> ss) {
	std::set<std::string> sset (ss.begin(), ss.end());
	return sset.find(s) != sset.end();	
}

std::string is_in_set_default(string s, std::vector<string> ss, string defvalue, bool tolower) {
	if (tolower) lowercase(s);
	std::set<std::string> sset (ss.begin(), ss.end());
	if (sset.find(s) == sset.end() ) {
		s = defvalue;
	} 
	return s;
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


std::vector<double> str2double(std::vector<string> s) { 
	std::vector<double> d (s.size());
	std::transform(s.begin(), s.end(), d.begin(), [](const std::string& val) {
		return std::stod(val);
	});
	return d;
}

std::vector<double> double2str(std::vector<double> d) { 
	std::vector<string> s (d.size());
	std::transform(d.begin(), d.end(), s.begin(), [](const std::double& val) {
		return std::to_string(val);
	});
	return s;
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



// trim from start (in place)
void ltrim(std::string &s) {
    s.erase(s.begin(), std::find_if(s.begin(), s.end(), [](int ch) {
        return !std::isspace(ch);
    }));
}

// trim from end (in place)
void rtrim(std::string &s) {
    s.erase(std::find_if(s.rbegin(), s.rend(), [](int ch) {
        return !std::isspace(ch);
    }).base(), s.end());
}

// trim from both ends (in place)
void lrtrim(std::string &s) {
    ltrim(s);
    rtrim(s);
}

// trim from start (copying)
std::string ltrim_copy(std::string s) {
    ltrim(s);
    return s;
}

// trim from end (copying)
std::string rtrim_copy(std::string s) {
    rtrim(s);
    return s;
}

// trim from both ends (copying)
std::string lrtrim_copy(std::string s) {
    lrtrim(s);
    return s;
}

