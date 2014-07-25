\name{newSection}
\alias{newSection}
\title{Create a new section element.}
\usage{
  newSection(..., class = "", exportId = NULL,
    protection = PROTECTION.PUBLIC, expanded = FALSE)
}
\arguments{
  \item{...}{Strings that will be concatenated to form the
  section title.}

  \item{class}{If set to SECTION.CLASS.RESULTS, results can
  be reported in this section. If set to SECTION.CLASS.META
  the section will be a meta data section.}

  \item{exportId}{Unique string to identify this element.
  Used to retrieve the element using
  \code{getExportedElement}.}

  \item{protection}{Procection level. One of
  PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.}

  \item{expanded}{Whether the section should expanded by
  default or not.}
}
\value{
  New element.
}
\description{
  Create a new section element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

