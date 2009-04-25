\name{data path}
\alias{setDataPath}
\alias{setDataPathDefault}
\alias{dataPath}
\alias{dataPathDefault}

\title{ Set (or get) the default data path for the geodata package }
\description{
geodata provides access to spatial data stored on the Internet. To use these data they are first downloaded to the local computer and stored in the data path. The default path is a subdirectory of the package installation. This can be problematic because the data will be deleted when a new version of the package is installed. There may also be disk space and write access limitations. Use set.data.path to have the data downloaded into (and searched for in) another path of your preference.
}
\usage{
setDataPath(path, create=FALSE)
setDataPathDefault()
dataPath()
dataPathDefault()
}

\arguments{
  \item{path}{ path (e.g. "d:/data/spatial/R" on windows) where geodata should store and access data it knows about in its internal functions }
  \item{create}{ logical. If \code{TRUE} then R will attempt to create the path if it does not exist }
  
}
\details{

}
\value{
}

\author{Robert J. Hijmans}
\examples{
}
\keyword{ spatial }
