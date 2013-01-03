\name{writeReport}
\alias{writeReport}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
writeReport
}
\description{
A concise (1-5 lines) description of what the function does. ~~
}
\usage{
writeReport(report, filename = DEFAULT.REPORT.FILENAME, debug = FALSE, level = PROTECTION.PUBLIC)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{report}{
%%     ~~Describe \code{report} here~~
}
  \item{filename}{
%%     ~~Describe \code{filename} here~~
}
  \item{debug}{
%%     ~~Describe \code{debug} here~~
}
  \item{level}{
%%     ~~Describe \code{level} here~~
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
function (report, filename = DEFAULT.REPORT.FILENAME, debug = FALSE, 
    level = PROTECTION.PUBLIC) 
{
    references <- .getElementById(report, report$predefined$referencesId)
    input <- .getElementById(report, report$predefined$inputId)
    if (!is.null(references)) {
        report <- .removeElementById(report, references$id)
        if (length(references$elements) > 0) {
            report <- addToMethods(report, references)
        }
    }
    if (!is.null(input)) {
        if (length(input$elements) == 0) {
            str(input)
            report <- .removeElementById(report, input$id)
        }
    }
    .writeGeneralReport(report, filename, debug, level)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
