\name{geo-package}
\alias{geo-package}

\alias{geo}

\docType{package}

\title{geo}

\description{
This package is conceived as a replacement of the raster package. It has a very similar, but simpler, interface, and it is faster.
 
To speed up computations. In this package all native computations are done in C++. 

Methods that heavily interact with native R functions (e.g. "predict") will be written in R, calling C++ functions for reading/writing.

Classes, methods and properties are exposed via a Rcpp module, but Rcpp classes are generally not used.

There is one main S4 class "GeoRaster" that holds a C++ reference class to a C++ GeoRaster object.

The normal end-user won't directly use the reference class.

This package has single main class, "GeoRaster", as opposed to the three classes in the raster package (RasterLayer, Stack, Brick). 

A new design rule each algorithm is implemented only once... In the raster package many algos are implemented twice, once for in memory, once for chunk wise to disk computations for large files. 

Note that the C++ code uses 0 based indexing for row, col, layer, and cell numbers. 

Raster data are three-dimensional (and in the future there could be support for more). But in C++ they are represented as one dimensional vector. 

}


\keyword{ package }
\keyword{ spatial }

