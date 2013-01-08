\name{getExportedElement}
\alias{getExportedElement}
\title{Get an exported element from a report. This can be used to generate aggregate reports. This is an experimental feature of Nozzle and may not lead to the expected results.}
\usage{
  getExportedElement(report, exportId)
}
\arguments{
  \item{report}{The source report.}

  \item{exportId}{The ID of the exported element.
  \code{getExportedElementIds} returns a list of exported
  element IDs.}
}
\value{
  The exported report element or NULL if the ID does not
  exist in \code{report}.
}
\description{
  Get an exported element from a report. This can be used
  to generate aggregate reports. This is an experimental
  feature of Nozzle and may not lead to the expected
  results.
}
\note{
  Elements containing references should not be exported
  since references cannot be resolved in the target report.
  Relative paths in exported elements may have to be
  adjusted manually if the target report will be located in
  a different directory.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

