\name{raster.read}
\alias{raster.read.all}
\alias{raster.read.row}
\alias{raster.read.rows}
\alias{raster.read.part.of.row}
\alias{raster.read.block}
\alias{raster.read.cells}
\alias{raster.read.xy}
\alias{raster.get.matrix}

\title{ Read from a raster data file }
\description{
  Data associated with a raster object are read from file. Either all the data, by row, part of row, block, by cellnumber, or for (x,y) coordinates.
  Data can be read for Rgis binary files, as well as for many other formats (via a bridge to rgdal).
  raster.get.matrix will return a matrix, optionally with the row and col numbers as names of the whole or part of the data that has been previously 
  read with raster.read.all, read.row, read.part.of.row, read.block
}

\usage{
raster.read.all(raster)
raster.read.row(raster, rownr)
raster.read.rows(raster, startrow, nrows = 3)
raster.read.part.of.row(raster, rownr,  startcol=1, ncols=(raster@ncols-startcol+1)) 
raster.read.block(raster, startrow, nrows=3, startcol=1, ncols=(raster@ncols-startcol+1)) 
raster.read.cells(raster, cells)
raster.read.xy(raster, xy)
raster.get.matrix(raster, names=FALSE)
}

\arguments{
  \item{raster}{ A raster object }
  \item{rownr}{ the row number of the row to read  (between 1 and raster@nrows) }
  \item{startrow}{ the frist row to read  (>= 1 & <= raster@nrows) }
  \item{nrows}{ the number of the rows to read (>= 1 & <= raster@nrows) }
  \item{startcol}{ first column of the block ( (>= 1 & <= raster@ncols) }
  \item{ncols}{ number of columns to read on this each row ( (>= 1 & <= raster@ncols & > firstcol) }
  \item{cells}{ vector of cell numbers }
  \item{xy}{ x and y coordinates  }
  \item{names}{ If TRUE, row and col names are provided }
}
\details{
}
\value{
  a rater object containing a vector with raster values.  
  or rater values for a set of points
  or a matrix with raster values
}
\author{ Robert J. Hijmans \email{r.hijmans@gmail.com} }

\examples{

 rs <- raster.create.from.file(system.file("external/test.ag", package="sp"))

# read values for cells
  cells <- c(1, 1900, 5000)
  raster.read.cells(rs, cells)

# read values for (x, y) coordinates
  xy <- raster.get.xy.from.cell(rs, cells)
  raster.read.xy(rs, xy)
  	
# read a row
  firstrow <- raster.read.row(rs, 1)
  lastrow <- raster.read.row(rs, rs@nrows)

# read a number of rows
  fiverows <- raster.read.rows(rs, startrow=50, nrows=5)

# read part of a row 
  rowpart <- raster.read.part.of.row(rs, 50,  startcol=30, ncols=10) 

# read a block
  block <- raster.read.block(rs, startrow=50, nrows=5, startcol=30, ncols=10) 
}
  
\keyword{ spatial }
