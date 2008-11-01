\name{write}
\alias{write.raster}
\alias{write.row}
\alias{write.ascii}
\alias{write.import}
\alias{write.export}

\title{ Write raster data to a file }
\description{
  Write raster data to a file. Either as binary ('raster') format or Ascii (ESRI Arc Ascii) format. 
}
\usage{
write.raster(raster, overwrite=FALSE)
write.row(raster, overwrite=FALSE)
write.ascii(raster, overwrite=FALSE)
write.import(raster, outfile, overwrite=FALSE)
write.export(raster, outfile, filetype='ascii', overwrite=FALSE)
}

%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{raster}{ Raster object }
  \item{outfile}{ The file resulting from import or export }
  \item{filetype}{ The type of file to export to }
  \item{overwrite} { if TRUE existing files are overwritten }
%  \item{sparse} { if TRUE a sparse format file is written }
}
\details{
	data in \code{raster@data} is written to a file. Small datasets can be loaded into memory manipulated, 
	and saved to disk again. For large datasets, you can read and write by row. 
	}

\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}

\seealso{ \code{\link[rgdal]{rgdal}} }
\examples{ 

 rs <- raster.from.file(system.file("external/test.ag", package="sp"))
 
\dontrun{
#read all data
 rs <- read.all(rs)

# write all to binary file
 rs <- set.filename(rs, "binall.grd")
 rs <- write.binary(rs, overwrite=TRUE)
 
# write all to integer binary file
 rs <- set.filename(rs, "binallint.grd")
 rs <- set.datatype(rs, "integer")
 rs <- write.binary(rs, overwrite=TRUE)
 
# write all to ascii file
 rs <- set.filename(rs, "ascall.asc")
 write.ascii(rs, overwrite=TRUE)
 
# read and write row by row; write to ascii file
 ascrow <- set.filename(rs, "ascrow.asc")
 for (r in 1:rs@nrows) {
	rs <- read.row(rs, r)
	ascrow@data <- rs@data
	ascrow <- write.ascii.row(ascrow, r, overwrite=TRUE) }
	
# read and write row by row; write to binary file
 binrow <- set.filename(rs, "binrow.grd")
 for (r in 1:rs@nrows) {
	binrow@data <- read.row(rs, r)@data
	binrow <- write.binary.row(binrow, r, overwrite=TRUE) }
  }
}

\keyword{ spatial }
