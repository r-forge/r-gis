\name{rasterstack.create}
\alias{rasterstack.create.from.stackfile}
\alias{rasterstack.create.from.rasterfiles}
\alias{rasterstack.create.from.rasters}
\alias{rasterstack.add.files}
\alias{rasterstack.add.rasters}
\alias{rasterstack.remove.rasters}
\alias{rasterstack.save}

\title{ Create or change a new rasterstack }
\description{
  A raster stack is a collection of rasters with the same spatial extent and resolution. They can be crated from raster objects, or from raster files.
  You can add raster to or remove raster from a rasterstack. You can also save a rasterstack to a file, to recreate it later.  
}

\usage{
rasterstack.create.from.stackfile(stackfile)
rasterstack.create.from.rasterfiles(rasterfiles, bands= rep(1, length(rasterfiles)))
rasterstack.create.from.rasters(rasters)
rasterstack.add.files(rasterstack, rasterfiles, bands= rep(1, length(rasterfiles))) 
rasterstack.add.rasters(rasterstack, rasters) 
rasterstack.remove.rasters(rasterstack, indices) 
rasterstack.save(rasterstack, stackfile, forceext = TRUE)
}

\arguments{
  \item{stackfile}{ Filename for the rasterstack (to save it on disk) }
  \item{rasterstack}{ a rasterstack object }
  \item{rasterfiles}{ Filename(s) of (a) raster dataset(s) }
  \item{bands}{ A vector or list of bands of raster data files (default values = 1)}
  \item{rasters}{ raster object(s) }
  \item{indices}{ the indices (in rasterstack@rasters) of the raster(s) to remove from a rasterstack }
  \item{forceext}{ Force the rasterstack filename extension to the default '.stk' }
}
\details{
  When a  rasterstack is saved to a file, only pointers (filenames) to raster datasets are saved, not the data. If the name or location of a raster file changes, the rasterstack becomes invalid.
  rasters contained in a rasterstack can be accessed like this rasterstack@rasters[[index]] where index is between 1 and rasterstack@nrasters.  
}
\value{
  a rasterstack object
}
\author{Robert J. Hijmans  \email{r.hijmans@gmail.com}}

\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }
\examples{
  rasterfile <- system.file("external/test.ag", package="sp")
  st <- rasterstack.create.from.rasterfiles(rasterfile)
# adding the same file multiple times, in most cases you would add different files  
# this generates warnings, but it is not an error
  st <- rasterstack.add.files(st, c(rasterfile, rasterfile))
  rs <- raster.file(rasterfile)
  st <- rasterstack.add.rasters(st, c(rs, rs))
  st
  st <- rasterstack.remove.rasters(st, c(3, 5))
  st@nrasters
}
\keyword{ spatial }
