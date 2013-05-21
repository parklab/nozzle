\name{setCollectionDate}
\alias{setCollectionDate}
\title{Set the collection date of \code{report}. The collection date is the date when the collection that this report is part of was created.}
\usage{
  setCollectionDate(report, ...)
}
\arguments{
  \item{report}{Report element.}

  \item{...}{One or more strings that will be concatenated
  to form the collection date of the report.}
}
\value{
  Updated report element or NA if \code{report} has no
  collection date element.
}
\description{
  Set the collection date of \code{report}. The collection
  date is the date when the collection that this report is
  part of was created.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

