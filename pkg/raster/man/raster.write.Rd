\name{raster.write}
\alias{raster.write}
\alias{raster.write.row}
\alias{raster.write.ascii}
\alias{raster.write.import}
\alias{raster.write.export}

\title{ Write raster data to a file }
\description{
  Write raster data to a file. Either as Ascii (ESRI Arc Ascii) format, or a binary (DIVA-GIS) format. 
}
\usage{
raster.write(raster, overwrite=FALSE)
raster.write.row(raster, overwrite=FALSE)
raster.write.ascii(raster, overwrite=FALSE)
raster.write.import(raster, outfile, overwrite=FALSE)
raster.write.export(raster, outfile, filetype, overwrite=FALSE)
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
 rs <- raster.read.all(rs)

# write all to binary file
 rs <- set.filename(rs, "binall.grd")
 rs <- raster.write.binary(rs, overwrite=TRUE)
 
# write all to integer binary file
 rs <- set.filename(rs, "binallint.grd")
 rs <- raster.set.datatype(rs, "integer")
 rs <- raster.write.binary(rs, overwrite=TRUE)
 
# write all to ascii file
 rs <- set.filename(rs, "ascall.asc")
 raster.write.ascii(rs, overwrite=TRUE)
 
# read and write row by row; write to ascii file
 ascrow <- set.filename(rs, "ascrow.asc")
 for (r in 1:rs@nrows) {
	rs <- raster.read.row(rs, r)
	ascrow@data <- rs@data
	ascrow <- raster.write.ascii.row(ascrow, r, overwrite=TRUE) }
	
# read and write row by row; write to binary file
 binrow <- set.filename(rs, "binrow.grd")
 for (r in 1:rs@nrows) {
	binrow@data <- raster.read.row(rs, r)@data
	binrow <- raster.write.binary.row(binrow, r, overwrite=TRUE) }
  }
}

\keyword{ spatial }
