\name{newFigure}
\alias{newFigure}
\title{Create a new list element.}
\usage{
  newFigure(file, ..., fileHighRes = NA,
    type = IMAGE.TYPE.RASTER, exportId = NULL,
    protection = PROTECTION.PUBLIC)
}
\arguments{
  \item{file}{Path or URL to the image file. Paths can be
  absolute or relative.}

  \item{...}{Strings that will be concatenated to form the
  figure caption.}

  \item{fileHighRes}{Path or URL to a high-resolution or
  vector-based version of the image file. Paths can be
  absolute or relative.}

  \item{type}{Currenlty only IMAGE.TYPE.RASTER is allowed.}

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
  Create a new list element.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

