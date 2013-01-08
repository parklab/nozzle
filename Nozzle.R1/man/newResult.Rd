\name{newResult}
\alias{newResult}
\title{Create a new result element.}
\usage{
  newResult(..., isSignificant = FALSE,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{...}{One or more strings that will be concatenated
  to form the text associated with the result (often just a
  scalar or single string).}

  \item{isSignificant}{If TRUE, the result will be declared
  signficant.}

  \item{protection}{Procection level. One of
  PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.}
}
\value{
  New element.
}
\description{
  Create a new result element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

