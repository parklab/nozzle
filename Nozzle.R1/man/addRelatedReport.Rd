\name{addRelatedReport}
\alias{addRelatedReport}
\title{Add the URL, title, and signficance status of a related report, e.g. one summarizing the same type of analysis but on a different input set.}
\usage{
  addRelatedReport(report, name, url,
    isSignificant = FALSE)
}
\arguments{
  \item{report}{Report object.}

  \item{name}{Name of the related report.}

  \item{url}{URL of the related report (may be relative).}

  \item{isSignificant}{Flag indicating whether the related
  report contains significant findings.}
}
\value{
  Updated report element.
}
\description{
  Add the URL, title, and signficance status of a related
  report, e.g. one summarizing the same type of analysis
  but on a different input set.
}
\author{
  nils
}

