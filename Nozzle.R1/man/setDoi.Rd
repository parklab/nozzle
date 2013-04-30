\name{setDoi}
\alias{setDoi}
\title{Set the DOI (document object identifier, http://www.doi.org) for \code{report}. A warning will be emitted if the report has been assigned a DOI before.}
\usage{
  setDoi(report, doi)
}
\arguments{
  \item{report}{Report element.}

  \item{doi}{The document object identifier.}
}
\value{
  Updated report element.
}
\description{
  Set the DOI (document object identifier,
  http://www.doi.org) for \code{report}. A warning will be
  emitted if the report has been assigned a DOI before.
}
\note{
  A document object identifer must have been created before
  this is called.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}
\references{
  \url{http://www.doi.org}
}

