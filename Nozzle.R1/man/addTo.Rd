\name{addTo}
\alias{addTo}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
 ~~function to do ... ~~
}
\description{
 ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
addTo(parent, ..., row = NA, column = NA)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{parent}{
%%     ~~Describe \code{parent} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{row}{
%%     ~~Describe \code{row} here~~
}
  \item{column}{
%%     ~~Describe \code{column} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (parent, ..., row = NA, column = NA) 
{
    args <- list(...)
    if (parent$type == .ELEMENT.TABLE) {
        if (!missing(row) && !missing(column)) {
            if (length(args) == 1) {
                if (args[[1]]$type == .ELEMENT.RESULT) {
                  parent <- .addResult(table = parent, row = row, 
                    column = column, result = args[[1]])
                  return(parent)
                }
            }
        }
    }
    if (length(args) > 0) {
        for (i in 1:length(args)) {
            parent$elements[[length(parent$elements) + 1]] <- args[[i]]
        }
    }
    return(parent)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
