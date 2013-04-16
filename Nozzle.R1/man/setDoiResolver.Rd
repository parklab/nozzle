\name{setDoiResolver}
\alias{setDoiResolver}
\title{Set the DOI resolver URL (e.g. http://dx.doi.org) for \code{report}. The URL must not end with a slash!}
\usage{
  setDoiResolver(report, url)
}
\arguments{
  \item{report}{Report element.}

  \item{url}{The resolver URL (without a trailing slash).
  The default is "http://dx.doi.org".}
}
\value{
  Updated report element.
}
\description{
  Set the DOI resolver URL (e.g. http://dx.doi.org) for
  \code{report}. The URL must not end with a slash!
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

