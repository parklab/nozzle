\name{newReport}
\alias{newReport}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
  ~~function to do ... ~~
}
\description{
  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
newReport(...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
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
function (...) 
{
    element <- .newGeneralReport(...)
    overview <- newSection("Overview")
    overview$domId <- "overview"
    introduction <- newSubSection("Introduction")
    introduction$domId <- "introduction"
    summary <- newSubSection("Summary")
    summary$domId <- "summary"
    results <- newSection("Results")
    results$domId <- "results"
    methods <- newSection("Methods & Data")
    methods$domId <- "methods"
    input <- newSubSection("Input")
    input$domId <- "input"
    references <- newSubSection("References")
    references$domId <- "references"
    element$predefined <- list()
    element$predefined$overviewId <- overview$id
    element$predefined$introductionId <- introduction$id
    element$predefined$summaryId <- summary$id
    element$predefined$resultsId <- results$id
    element$predefined$methodsId <- methods$id
    element$predefined$inputId <- input$id
    element$predefined$referencesId <- references$id
    element <- addTo(parent = element, addTo(parent = overview, 
        introduction, summary))
    element <- addTo(parent = element, results)
    element <- addTo(parent = element, addTo(parent = methods, 
        input, references))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
