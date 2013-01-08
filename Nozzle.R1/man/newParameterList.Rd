\name{newParameterList}
\alias{newParameterList}
\title{Create a new parameter list element. A parameter list is an unnumbered list of the form param_1 = value_1, ..., param_n = value_n where param_i is formated as a parameter and value_i is formatted as a value.}
\usage{
  newParameterList(..., separator = " = ", exportId = NULL,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{...}{2n strings that will be contactenated to form
  the parameter-value pairs. Strings at positions 1, ...,
  2n - 1 will be treated as parameters 1 through n and
  strings at positions 2, ..., 2n will be treated as values
  1 through n.}

  \item{separator}{String to be used to separate parameters
  and values. Whitespace characters need to be supplied if
  required.}

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
  Create a new parameter list element. A parameter list is
  an unnumbered list of the form param_1 = value_1, ...,
  param_n = value_n where param_i is formated as a
  parameter and value_i is formatted as a value.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

