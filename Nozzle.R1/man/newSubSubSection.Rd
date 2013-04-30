\name{newSubSubSection}
\alias{newSubSubSection}
\title{Create a new subsubsection element.}
\usage{
  newSubSubSection(..., exportId = NULL,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{...}{Strings that will be concatenated to form the
  subsubsection title.}

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
  Create a new subsubsection element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

