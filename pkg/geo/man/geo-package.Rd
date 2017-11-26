\name{geo-package}
\alias{geo-package}

\alias{geo}

\docType{package}

\title{geo}

\description{
This package is conceived as a replacement of the raster package. It has a very similar, but simpler, interface, and it is faster.
 
To speed up computations. In this package all native computations are done in C++. 

Classes, methods and properties are exposed via a Rcpp module, but Rcpp classes are generally not used.

There is one main S4 class "GeoRaster" that holds a C++ reference class to a C++ GeoRaster object.

The normal end-user won't directly use the reference class.
}


\keyword{ package }
\keyword{ spatial }

