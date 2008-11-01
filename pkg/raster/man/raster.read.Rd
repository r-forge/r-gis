\name{raster.read}
\alias{read.all}
\alias{read.row}
\alias{read.rows}
\alias{read.part.of.row}
\alias{read.block}
\alias{read.cells}
\alias{read.xy}

\title{ Read from a raster data file }
\description{
  Data associated with a raster object are read from file. Either all the data, by row, part of row, block, by cellnumber, or for (x,y) coordinates.
  Data can be read for Rgis binary files, as well as for many other formats (via a bridge to rgdal).
  read with read.all, read.row, read.part.of.row, read.block
}

\usage{
read.all(raster)
read.row(raster, rownr)
read.rows(raster, startrow, nrows = 3)
read.part.of.row(raster, rownr,  startcol=1, ncols=(raster@ncols-startcol+1)) 
read.block(raster, startrow, nrows=3, startcol=1, ncols=(raster@ncols-startcol+1)) 
read.cells(raster, cells)
read.xy(raster, xy)

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

 rs <- raster.from.file(system.file("external/test.ag", package="sp"))

# read values for cells
  cells <- c(1, 1900, 5000)
  read.cells(rs, cells)

# read values for (x, y) coordinates
  xy <- get.xy.from.cell(rs, cells)
  read.xy(rs, xy)
  	
# read a row
  firstrow <- read.row(rs, 1)
  lastrow <- read.row(rs, rs@nrows)

# read a number of rows
  fiverows <- read.rows(rs, startrow=50, nrows=5)

# read part of a row 
  rowpart <- read.part.of.row(rs, 50,  startcol=30, ncols=10) 

# read a block
  block <- read.block(rs, startrow=50, nrows=5, startcol=30, ncols=10) 
}
  
\keyword{ spatial }
