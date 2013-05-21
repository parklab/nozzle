\name{setCollectionVersion}
\alias{setCollectionVersion}
\title{Set the collection version of \code{report}. The collection version is the version string of the collection that this report is part of.}
\usage{
  setCollectionVersion(report, ...)
}
\arguments{
  \item{report}{Report element.}

  \item{...}{One or more strings that will be concatenated
  to form the collection version of the report.}
}
\value{
  Updated report element or NA if \code{report} has no
  collection version element.
}
\description{
  Set the collection version of \code{report}. The
  collection version is the version string of the
  collection that this report is part of.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

