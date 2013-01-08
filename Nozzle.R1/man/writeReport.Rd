\name{writeReport}
\alias{writeReport}
\title{Write \code{report} to file.}
\usage{
  writeReport(report, filename = DEFAULT.REPORT.FILENAME,
    debug = FALSE, output = c(HTML.REPORT, RDATA.REPORT),
    credits = TRUE, level = PROTECTION.PUBLIC,
    debugCss = NA, debugJavaScript = NA)
}
\arguments{
  \item{report}{The report to be written.}

  \item{filename}{Name of the output file without file
  extension.}

  \item{debug}{If TRUE, external CSS (\code{debugCss}) and
  JavaScript (\code{debugJavaScript}) can be supplied.}

  \item{output}{A list of output formats. Any combination
  of HTML.REPORT and RDATA.REPORT is allowed.}

  \item{credits}{If TRUE, a note and a link will be
  included at the bottom of the report to indicate that it
  was created with Nozzle.}

  \item{level}{The protection level of the report. If set
  to PROTECTION.PUBLIC only elements with protection level
  PROTECTION.PUBLIC (default) will be included in the
  report. If set to PROTECTION.GROUP, then all elements
  with protection level PROTECTION.PUBLIC and
  PROTECTION.GROUP will be included. If set to
  PROTECTION.PRIVATE all elements will be included.}

  \item{debugCss}{A path or URL to a CSS file that should
  be used instead of the built-in CSS. Only used if
  \code{debug} is TRUE.}

  \item{debugJavaScript}{A path or URL to a JavaScript file
  that should be used instead of the built-in JavaScript.
  Only used if \code{debug} is TRUE.}
}
\description{
  Write \code{report} to file.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

