\name{miscellanous}
\alias{file.change.extension}
\alias{file.get.extension}
\alias{file.get.name}
\alias{file.get.path}
\alias{string.trim}
\alias{calc.mode}
\alias{calc.cv}

\title{ Miscellaneous functions }
\description{
  Low level functions for file and string handling. Get or change file extension or extract
  the file name from a full name (path + filename). Trim a string of characters (remove the whitespace before or after the string).
}
\usage{
file.change.extension(filename, newextension)
file.get.extension(filename)
file.get.name(filename)
file.get.path(filename)
string.trim(astring)
calc.mode(x, na.rm = TRUE)
calc.cv(x, na.rm = TRUE, singlevalueaszero=TRUE)
}
\arguments{
  \item{filename}{ a filename with or without the path }
  \item{newextension}{ a file extension, e.g., ".txt"  }
  \item{astring} { a string that needs to be trimmed }
  \item{x} { a vector of numbers (typically integers for mode) }
  \item{na.rm} { remove (ignore) NA values }
  \item{singlevalueaszero} { if TRUE a zero is returned (rather than an NA) if the mode of single value is computed }
}

\value{
  file.get return a file extension, filename or path.  
  calc.mode returns the modal (most frequent) value of a vector of values, ties are broken at random
  calc.cv returns the coefficient of variation (expressed as a percentage). If there is only a single value, sd = NA
  and calc.cv returns NA if singlevaluecvzero=FALSE. However, the default is that cv=0 in this case.
}

\author{Robert J. Hijmans \email{r.hijmans@gmail.com}}

\examples{
  fn <- "c:/temp folder/this is the file name. this is the extension"
  file.get.extension(fn)
  file.change.extension(fn, ".txt")
  file.get.name(fn)
}
\keyword{ spatial }

