\name{stack.create}
\alias{stack.from.stackfile}
\alias{stack.from.rasterfiles}
\alias{stack.from.rasters}
\alias{stack.add.files}
\alias{stack.add.rasters}
\alias{stack.remove.rasters}
\alias{stack.save}

\title{ Create or change a new stack }
\description{
  A raster stack is a collection of rasters with the same spatial extent and resolution. They can be crated from raster objects, or from raster files.
  You can add raster to or remove raster from a stack. You can also save a stack to a file, to recreate it later.  
}

\usage{
stack.from.stackfile(stackfile)
stack.from.rasterfiles(rasterfiles, bands= rep(1, length(rasterfiles)))
stack.from.rasters(rasters)
stack.add.files(rstack, rasterfiles, bands= rep(1, length(rasterfiles))) 
stack.add.rasters(rstack, rasters) 
stack.remove.rasters(rstack, indices) 
stack.save(rstack, stackfile, forceext = TRUE)
}

\arguments{
  \item{stackfile}{ Filename for the stack (to save it on disk) }
  \item{rstack}{ a stack object }
  \item{rasterfiles}{ Filename(s) of (a) raster dataset(s) }
  \item{bands}{ A vector or list of bands of raster data files (default values = 1)}
  \item{rasters}{ raster object(s) }
  \item{indices}{ the indices (in stack@rasters) of the raster(s) to remove from a stack }
  \item{forceext}{ Force the stack filename extension to the default '.stk' }
}
\details{
  When a  stack is saved to a file, only pointers (filenames) to raster datasets are saved, not the data. If the name or location of a raster file changes, the stack becomes invalid.
  rasters contained in a stack can be accessed like this stack@rasters[[index]] where index is between 1 and stack@nrasters.  
}
\value{
  a stack object
}
\author{Robert J. Hijmans  \email{r.hijmans@gmail.com}}

\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
  rasterfile <- system.file("external/test.ag", package="sp")
  st <- stack.from.rasterfiles(rasterfile)
# adding the same file multiple times, in most cases you would add different files  
# this generates warnings, but it is not an error
  st <- stack.add.files(st, c(rasterfile, rasterfile))
  rs <- raster.from.file(rasterfile)
  st <- stack.add.rasters(st, c(rs, rs))
  st
  st <- stack.remove.rasters(st, c(3, 5))
  nlayers(st)
}
\keyword{ spatial }
