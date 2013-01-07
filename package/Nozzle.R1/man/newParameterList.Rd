\name{newParameterList}
\alias{newParameterList}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  ~~function to do ... ~~
}
\description{
~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
newParameterList(..., separator = " = ", protection = PROTECTION.PUBLIC)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
  \item{separator}{
%%     ~~Describe \code{separator} here~~
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
function (..., separator = " = ", protection = PROTECTION.PUBLIC) 
{
    element <- newList(isNumbered = FALSE, protection = protection)
    args <- list(...)
    if (length(args) < 2) {
        stop("At least one parameter-value pair has to be provided to parameter list.")
    }
    if (length(args)\%\%2 != 0) {
        stop("Number of elements in parameter list is not multiple of 2.")
    }
    j <- 1
    for (i in 1:(length(args)/2)) {
        element <- addTo(parent = element, newParagraph(args[[j]], 
            separator, args[[j + 1]]))
        j <- j + 2
    }
    return(element)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
