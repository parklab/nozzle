\name{newList}
\alias{newList}
\title{Create a new list element.}
\usage{
  newList(..., isNumbered = FALSE, exportId = NULL,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{...}{Elements of type paragraph, list or result
  that will form the items in the list.}

  \item{isNumbered}{If set to FALSE, the list will be
  unordered with bullet points. If set to TRUE, the list
  will be numbered with arabic numerals.}

  \item{exportId}{Unique string to identify this element.
  Used to retrieve the element using
  \code{getExportedElement}.}

  \item{protection}{Procection level. One of
  PROTECTION.PUBLIC, PROTECTION.GROUP or
  PROTECTION.PRIVATE.}
}
\value{
  New element.
}
\description{
  Create a new list element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

