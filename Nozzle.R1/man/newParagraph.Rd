\name{newParagraph}
\alias{newParagraph}
\title{Create a new paragraph element.}
\usage{
  newParagraph(..., exportId = NULL,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{...}{Strings that will be concatenated to form the
  text of the paragraph.}

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
  Create a new paragraph element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

