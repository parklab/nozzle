\name{newTable}
\alias{newTable}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
 ~~function to do ... ~~
}
\description{
 ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
newTable(table, ..., file = NA, protection = PROTECTION.PUBLIC)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{table}{
%%     ~~Describe \code{table} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{file}{
%%     ~~Describe \code{file} here~~
}
  \item{protection}{
%%     ~~Describe \code{protection} here~~
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
function (table, ..., file = NA, protection = PROTECTION.PUBLIC) 
{
    element <- .newElement(.ELEMENT.TABLE, niceType = "Table", 
        protection = protection)
    element$table <- table
    element$tableFilename <- file
    element$resultList <- list()
    element$resultIndices <- array(dim = dim(table))
    element$text <- list(...)
    return(element)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
