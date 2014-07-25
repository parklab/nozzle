\name{newSubSection}
\alias{newSubSection}
\title{Create a new subsection element.}
\usage{
  newSubSection(..., exportId = NULL,
    protection = PROTECTION.PUBLIC, expanded = FALSE)
}
\arguments{
  \item{...}{Strings that will be concatenated to form the
  subsection title.}

  \item{exportId}{Unique string to identify this element.
  Used to retrieve the element using
  \code{getExportedElement}.}

  \item{protection}{Procection level. One of
  PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.}

  \item{expanded}{Whether the section should expanded by
  default or not. This will not affect the state of parent
  sections.}
}
\value{
  New element.
}
\description{
  Create a new subsection element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

