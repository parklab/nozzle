\name{setLogo}
\alias{setLogo}
\title{Set a logo file for one of six positions (three at the top, three at the bottom) in \code{report}, e.g. an institute logo.}
\usage{
  setLogo(report, filename, position)
}
\arguments{
  \item{report}{Report element.}

  \item{filename}{Path or URL to the logo file (relative)
  to the final location of the report HTML file.}

  \item{position}{One of LOGO.TOP.LEFT, LOGO.TOP.CENTER,
  LOGO.TOP.RIGHT, LOGO.BOTTOM.LEFT, LOGO.BOTTOM.CENTER,
  LOGO.BOTTOM.RIGHT.}
}
\value{
  Updated report element.
}
\description{
  Set a logo file for one of six positions (three at the
  top, three at the bottom) in \code{report}, e.g. an
  institute logo.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

