\name{rasterstack.read}
\alias{rasterstack.read.all}
\alias{rasterstack.read.row}
\alias{rasterstack.read.part.of.row}
\alias{rasterstack.read.xy}
\alias{rasterstack.read.cell}

\title{ Read data for a stack of rasters  }
\description{
  Read data for a stack of rasters. Either all data, or a single row. 
}
\usage{
rasterstack.read.all(rasterstack)
rasterstack.read.row(rasterstack, rownumber)
rasterstack.read.part.of.row(rasterstack, rownumber, startcol=1, ncols=(rasterstack@ncols-startcol+1)) 
rasterstack.read.xy(rasterstack, xy)
rasterstack.read.cell(rasterstack, cell)
}

\arguments{
  \item{rasterstack}{ a rasterstack object  }
  \item{rownumber}{ number of the row for which to read data }
  \item{startcol}{ first column to read }
  \item{ncols}{ number of columns to read }
  \item{xy}{ pair(s) of x an y coordinates, e.g., c(0, 0) }
  \item{cell}{ (vector of) cell number(s) }  
 }

\value{
  a matrix with values, each column representing a different raster. 
}

\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}

\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }

\examples{ }

\keyword{ spatial }
