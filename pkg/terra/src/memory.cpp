#include "spatraster.h"

#ifdef _WIN32 
#include <windows.h>
#elif __linux__
#include "sys/types.h"
#include "sys/sysinfo.h"
#include <unistd.h>
#elif __APPLE__
#include <mach/vm_statistics.h>
#include <mach/mach_types.h>
#include <mach/mach_init.h>
#include <mach/mach_host.h>
#endif


double availableRAM() {
//https://stackoverflow.com/questions/38490320/how-to-query-amount-of-allocated-memory-on-linux-and-osx
//https://stackoverflow.com/questions/63166/how-to-determine-cpu-and-memory-consumption-from-inside-a-process
	double ram = 1e+9;
	// return available RAM in number of double (8 byte) cells.
	#ifdef _WIN32
		MEMORYSTATUSEX statex;
		statex.dwLength = sizeof(statex);
		GlobalMemoryStatusEx(&statex);
		ram = statex.ullAvailPhys;
	#elif __linux__
		struct sysinfo memInfo;
		sysinfo (&memInfo);
		ram = memInfo.freeram;
	#elif __APPLE__
		vm_size_t page_size;
		mach_port_t mach_port;
		mach_msg_type_number_t count;
		vm_statistics64_data_t vm_stats;
		mach_port = mach_host_self();
		count = sizeof(vm_stats) / sizeof(natural_t);
		if (KERN_SUCCESS == host_page_size(mach_port, &page_size) &&
					KERN_SUCCESS == host_statistics64(mach_port, HOST_VM_INFO,
											(host_info64_t)&vm_stats, &count)) {
			ram = (int64_t)vm_stats.free_count * (int64_t)page_size;
		}
	#endif	
	return ram / 8;
}


bool SpatRaster::canProcessInMemory(unsigned n) {
	double f = 0.5;
	return (n * size()) < (availableRAM() * f);
}

unsigned SpatRaster::chunkSize(unsigned n) {
	double f = 0.25;
	unsigned cells_in_row = n * ncol * nlyr();
	unsigned rows = availableRAM() * f / cells_in_row;
	return rows == 0 ? 1 : std::min(rows, nrow);
}

BlockSize SpatRaster::getBlockSize(unsigned n) {
	BlockSize bs;

//	if (source[0].filename == "") {
	// in memory
//		bs.row = {0};
//		bs.nrows = {nrow};
//		bs.n = 1;

//	} else {

		unsigned cs = chunkSize(n);
		unsigned chunks = ceil(nrow / double(cs));
		bs.n = chunks;
		bs.row = std::vector<unsigned>(chunks);
		bs.nrows = std::vector<unsigned>(chunks, cs);

		unsigned r = 0;
		for (size_t i =0; i<chunks; i++) {
			bs.row[i] = r;
			r += cs;
		}	
		bs.nrows[chunks-1] = cs - ((chunks * cs) - nrow);	

//	}
	return bs;
}
