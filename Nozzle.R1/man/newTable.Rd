\name{newTable}
\alias{newTable}
\title{Create new table element.}
\usage{
  newTable(table, ..., file = NA,
    significantDigits = TABLE.SIGNIFICANT.DIGITS,
    exportId = NULL, protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{table}{A matrix or data frame containing the table
  data. Column names will be extracted and used as column
  headers.}

  \item{...}{Strings that will be concatenated to form the
  table caption.}

  \item{file}{Path or URL to a file containing the full
  table. It is recommend to only show a relevant subset of
  all results in the report itself to increase
  readability.}

  \item{significantDigits}{Number of significant digits
  used to trim all numeric columns. The default is
  \code{TABLE.SIGNIFICANT.DIGITS}.}

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
  Create new table element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

