\name{newHtml}
\alias{newHtml}
\title{Create a new freeform HTML element. THIS MUST BE USED WITH EXTRAORDINARTY CARE!}
\usage{
  newHtml(..., style = NULL, exportId = NULL,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{...}{Strings that will be concatenated to form the
  HTML content that will be wrapped into a \code{div}
  element.}

  \item{style}{CSS to be applied to the \code{div}
  element.}

  \item{exportId}{Unique string to identify this element.
  Used to retrieve the element using
  \code{getExportedElement}.}

  \item{protection}{Procection level. One of
  PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.}
}
\value{
  New element.
}
\description{
  Create a new freeform HTML element. THIS MUST BE USED
  WITH EXTRAORDINARTY CARE!
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

