\name{setContactInformation}
\alias{setContactInformation}
\title{Set contact information for \code{report}. This is used to create a "contact" button in the top right corner of the report, e.g. to collect feedback about the report.}
\usage{
  setContactInformation(report, email, subject, message,
    label = NA)
}
\arguments{
  \item{report}{Report element.}

  \item{email}{Email address of the recipient of contact
  emails.}

  \item{subject}{Subject of the email to be sent.}

  \item{message}{Message used to pre-populate the email
  body.}

  \item{label}{Label for the button, e.g. "Contact Us".}
}
\value{
  Updated report element.
}
\description{
  Set contact information for \code{report}. This is used
  to create a "contact" button in the top right corner of
  the report, e.g. to collect feedback about the report.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

