\name{newJournalCitation}
\alias{newJournalCitation}
\title{Create a citation element that represents a document published in a journal. This is a convenience wrapper for \code{newCitation}.}
\usage{
  newJournalCitation(authors, title, publication, issue,
    number, pages, year, url = "")
}
\arguments{
  \item{authors}{Names of authors.}

  \item{title}{Title of the document.}

  \item{publication}{Name of the publication where the
  document appeared.}

  \item{issue}{Issue of the publication.}

  \item{number}{Number of the publication.}

  \item{pages}{Pages of the document in the publication.}

  \item{year}{Year when the document was published.}

  \item{url}{URL of the document.}
}
\value{
  New element.
}
\description{
  Create a citation element that represents a document
  published in a journal. This is a convenience wrapper for
  \code{newCitation}.
}
\author{
  Nils Gehlenborg \email{nils@hms.harvard.edu}
}

