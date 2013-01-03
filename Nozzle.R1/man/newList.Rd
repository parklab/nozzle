\name{newList}
\alias{newList}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  ~~function to do ... ~~
}
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
newList(..., isNumbered = FALSE, protection = PROTECTION.PUBLIC)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{isNumbered}{
%%     ~~Describe \code{isNumbered} here~~
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
function (..., isNumbered = FALSE, protection = PROTECTION.PUBLIC) 
{
    element <- .newElement(.ELEMENT.LIST, protection = protection)
    element$isNumbered <- isNumbered
    if (missing(...)) {
        return(element)
    }
    args <- list(...)
    for (i in 1:length(args)) {
        if (args[[i]]$type == .ELEMENT.PARAGRAPH || args[[i]]$type == 
            .ELEMENT.LIST || args[[i]]$type == .ELEMENT.RESULT) {
            element$elements[[length(element$elements) + 1]] <- args[[i]]
        }
        else {
            stop("Report elements of type ", args[[i]]$element$type, 
                " can not be added to a list.")
        }
    }
    return(element)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
