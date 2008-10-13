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
rasterstack.read.part.of.row(rasterstack, rownumber, startcol, ncols)
rasterstack.read.xy(rasterstack, xy)
rasterstack.read.cell(rasterstack, cell)
}

\arguments{
  \item{rasterstack}{ a rasterstack object  }
  \item{rownumber}{ number of the row for which to read data }
  \item{startcol}{  }
  \item{ncols}{  }
  \item{xy}{ ~~Describe \code{xy} here~~ }
  \item{cell}{ ~~Describe \code{xy} here~~ }  
 }

\value{
  a matrix with values, each column representing a different raster. 
}

\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}

\seealso{ ~~objects to See Also as \code{\link{help}}, ~~~ }

\examples{ }

\keyword{ spatial }
