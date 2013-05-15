# Nozzle: a Report Generation Toolkit for Data Analysis Pipelines
#
# Nils Gehlenborg (nils@hms.harvard.edu) 
# Harvard Medical School, Center for Biomedical Informatics
# Broad Institute, Cancer Program
#
# Copyright (c) 2011-2013. All rights reserved.
#
# TODO: add default state (open/closed) for sections (per default all will be closed in custom reports)


#' Provides a high-level API to generate HTML reports with dynamic user interface elements. 
#'
#' \tabular{ll}{
#' Package: \tab Nozzle.R1\cr
#' Type: \tab Package\cr
#' Version: \tab 1.1-1\cr
#' Date: \tab 2013-05-15\cr
#' License: \tab LGPL (>= 2)\cr
#' LazyLoad: \tab yes\cr
#' }
#'
#' Nozzle was designed to facilitate summarization and rapid browsing of complex results in data 
#' analysis pipelines where multiple analyses are performed frequently on big data sets.
#' 
#' @name Nozzle.R1-package
#' @aliases nozzle
#' @docType package
#' @title Nozzle: a Report Generation Toolkit for Data Analysis Pipelines
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
#' @references
#' \url{http://www.github.com/parklab/Nozzle},
#' \url{http://gdac.broadinstitute.org/nozzle}
#' @note The "R1" in the "Nozzle.R1" package name stands for "revision 1" of the Nozzle R API. All versions of the Nozzle.R1 package 
#' will be backwards-compatible and able to render reports generated with earlier versions of the package.
#' When backwards-compatibility of the API can no longer maintained the package name will change to "Nozzle.R2".
#' @keywords package
NULL


# --- global variables ----------------------------------------------------------------------------

.nozzleEnv <- new.env();

.PACKAGE.VERSION <- "1.1-0";

.ELEMENT.REPORT <- "_report_";
.ELEMENT.SECTION <- "_section_";
.ELEMENT.SUBSECTION <- "_subsection_";
.ELEMENT.SUBSUBSECTION <- "_subsubsection_";
.ELEMENT.HTML <- "_html_";
.ELEMENT.PARAGRAPH <- "_paragraph_";
.ELEMENT.LIST <- "_list_";
.ELEMENT.PARAMETERLIST <- "_list_";
.ELEMENT.TABLE <- "_table_";
.ELEMENT.FIGURE <- "_figure_";
.ELEMENT.CITATION <- "_citation_";
.ELEMENT.RESULT <- "_result_";

.SEVERITY.LOG <- 0;
.SEVERITY.WARNING <- 1;
.SEVERITY.ERROR <- 2;

# names for popout windows
.POPOUT.FIGURE.WINDOW <- "nozzle_popout";
.POPOUT.TABLE.WINDOW <- "nozzle_popout";

#' Default filename for reports.
#' @export
DEFAULT.REPORT.FILENAME <- "nozzle";

#' Name of entities that are labeled as signficiant.
#' @export
DEFAULT.SIGNIFICANT.ENTITY <- "statistically significant findings";


# location relative to inst diretory of package
.NOZZLE.JAVASCRIPT.PATH <- "js";
.NOZZLE.JAVASCRIPT.FILE <- "nozzle.js";
.NOZZLE.JAVASCRIPT.MIN.FILE <- "nozzle.min.js";

.NOZZLE.JQUERY.MIN.FILE <- "jquery-1.5.1.min.js";
.NOZZLE.TABLESORTER.MIN.FILE <- "jquery.tablesorter.min.js";

.NOZZLE.GOOGLEANALYTICS.FILE <- "google-analytics.js";
.NOZZLE.GOOGLEANALYTICS.VARIABLE <- "GOOGLE_ANALYTICS_ID";

.NOZZLE.CSS.PATH <- "css";
.NOZZLE.CSS.FILE <- "nozzle.css";
.NOZZLE.CSS.MIN.FILE <- "nozzle.min.css";
.NOZZLE.CSS.PRINT.FILE <- "nozzle.print.css";
.NOZZLE.CSS.PRINT.MIN.FILE <- "nozzle.print.min.css";

.NOZZLE.CREDITS <- "Made with Nozzle";
.NOZZLE.URL <- "http://www.github.com/parklab/Nozzle";


#' Default number of significant digits to be used to trim numeric columns in tables.
#' @export
TABLE.SIGNIFICANT.DIGITS <- 2;


#' Public visibility. 
#' @export
PROTECTION.PUBLIC <- 0;

#' Group visibility.
#' @export
PROTECTION.TCGA <- 5; # TCGA is an alias for GROUP

#' Group visibility.
#' @export
PROTECTION.GROUP <- 5;

#' Private visibility.
#' @export
PROTECTION.PRIVATE <- 10;


#' Logo position.
#' @export
LOGO.TOP.LEFT <- 1;

#' Logo position.
#' @export
LOGO.TOP.CENTER <- 2;

#' Logo position.
#' @export
LOGO.TOP.RIGHT <- 4;

#' Logo position.
#' @export
LOGO.BOTTOM.LEFT <- 8;

#' Logo position.
#' @export
LOGO.BOTTOM.CENTER <- 16;

#' Logo position.
#' @export
LOGO.BOTTOM.RIGHT <- 32;


#' Image type.
#' @export
IMAGE.TYPE.RASTER <- 0;

#' Image type.
#' @export
IMAGE.TYPE.SVG <- 1;

#' Image type.
#' @export
IMAGE.TYPE.PDF <- 2;


#' Section class.
#' @export
SECTION.CLASS.RESULTS <- "results";

#' Section class.
#' @export
SECTION.CLASS.META <- "meta";


#' Output type.
#' @export
HTML.REPORT <- "html_standalone";

#' Output type.
#' @export
HTML.FRAGMENT <- "html_fragment";

#' Output type.
#' @export
RDATA.REPORT <- "rdata";


#' Default DOI resolver URL.
#' @export
DEFAULT.DOI.RESOLVER <- "http://dx.doi.org"


.REFERENCE.STRING <- "#'REF#'";

.onLoad <- function( libname, pkgname )
{
	.initEnvCounter( ".FIGURE.COUNTER" );
	.initEnvCounter( ".TABLE.COUNTER" );
	.initEnvCounter( ".FIGURE.SUPPLEMENTARY.COUNTER" );
	.initEnvCounter( ".TABLE.SUPPLEMENTARY.COUNTER" );
	.initEnvCounter( ".CITATION.COUNTER" );
	.initEnvCounter( ".RESULT.COUNTER" ); # counter for non-empty results (assigned upon result writing)
	
	.initEnvCounter( ".ELEMENT.ID" );
	.initEnvCounter( ".RESULT.ID" ); # ids also for empty results (assigned upon result creation)
	
	.setGlobalReportId( "" );
	
	# TODO: check if files exist
	assign( "cssCode", readLines( file.path( system.file( .NOZZLE.CSS.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.CSS.FILE), warn=FALSE ), envir=.nozzleEnv );
	assign( "cssPrintCode", readLines( file.path( system.file( .NOZZLE.CSS.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.CSS.PRINT.FILE), warn=FALSE ), envir=.nozzleEnv );
	assign( "javaScriptCode", readLines( file.path( system.file( .NOZZLE.JAVASCRIPT.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.JAVASCRIPT.FILE ), warn=FALSE ), envir=.nozzleEnv );	
	assign( "cssMinCode", readLines( file.path( system.file( .NOZZLE.CSS.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.CSS.MIN.FILE ), warn=FALSE ), envir=.nozzleEnv );
	assign( "cssPrintMinCode", readLines( file.path( system.file( .NOZZLE.CSS.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.CSS.PRINT.MIN.FILE ), warn=FALSE ), envir=.nozzleEnv );
	assign( "javaScriptMinCode", readLines( file.path( system.file( .NOZZLE.JAVASCRIPT.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.JAVASCRIPT.MIN.FILE ), warn=FALSE ), envir=.nozzleEnv );	
	
	assign( "jQueryMinCode", readLines( file.path( system.file( .NOZZLE.JAVASCRIPT.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.JQUERY.MIN.FILE ), warn=FALSE ), envir=.nozzleEnv );	
	assign( "jQueryTableSorterMinCode", readLines( file.path( system.file( .NOZZLE.JAVASCRIPT.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.TABLESORTER.MIN.FILE ), warn=FALSE ), envir=.nozzleEnv );	
	
	assign( "googleAnalyticsCode", readLines( file.path( system.file( .NOZZLE.JAVASCRIPT.PATH, package=pkgname, lib.loc=libname ), .NOZZLE.GOOGLEANALYTICS.FILE ), warn=FALSE ), envir=.nozzleEnv );	
	
	assign( ".PACKAGE", pkgname, envir=.nozzleEnv );
}



# --- utility functions ----------------------------------------------------------------------------

.updateEnvCounter <- function( counter, increment=1, environment=.nozzleEnv )
{
	assign( counter, get( counter, envir=.nozzleEnv ) + increment, envir=environment );
	
	return ( get( counter, envir=environment )  );
}

.initEnvCounter <- function( counter, environment=.nozzleEnv )
{
	assign( counter, 0, envir=environment );
}

.getNextElementId <- function()
{
	return ( .updateEnvCounter( ".ELEMENT.ID" ) );
}


.setGlobalReportId <- function( id, environment=.nozzleEnv )
{
	assign( ".REPORT.ID", id, envir=environment );	
}


.getGlobalReportId <- function( environment=.nozzleEnv )
{
	return ( get( ".REPORT.ID", environment ) );	
}


.getPackageVersion <- function( environment=.nozzleEnv )
{
	return ( .concat( get( ".PACKAGE", environment ), "_", .PACKAGE.VERSION ) );	
	
	# set lib.loc!
	#return ( .concat( get( ".PACKAGE", environment ), " ", packageVersion( get( ".PACKAGE", environment ), lib.loc=??? ) ) );	
}


.initNumbers <- function()
{
	.initEnvCounter( ".FIGURE.COUNTER" );
	.initEnvCounter( ".TABLE.COUNTER" );
	.initEnvCounter( ".FIGURE.SUPPLEMENT.COUNTER" );
	.initEnvCounter( ".TABLE.SUPPLEMENT.COUNTER" );
	.initEnvCounter( ".CITATION.COUNTER" );
	.initEnvCounter( ".RESULT.COUNTER" );
}


.getNextFigureNumber <- function()
{
	return ( .updateEnvCounter( ".FIGURE.COUNTER" ) );
}

.getNextTableNumber <- function()
{
	return ( .updateEnvCounter( ".TABLE.COUNTER" ) );
}

# supplementary figure numbers are negative
.getNextSupplementFigureNumber <- function()
{
	return ( .updateEnvCounter( ".FIGURE.SUPPLEMENT.COUNTER", increment=-1 ) );
}

# supplementary table numbers are negative
.getNextSupplementTableNumber <- function()
{
	return ( .updateEnvCounter( ".TABLE.SUPPLEMENT.COUNTER", increment=-1 ) );
}


.getNextCitationNumber <- function()
{
	return ( .updateEnvCounter( ".CITATION.COUNTER" ) );
}

.getNextResultId <- function()
{
	return ( .updateEnvCounter( ".RESULT.ID" ) );
}

.getNextResultNumber <- function()
{
	return ( .updateEnvCounter( ".RESULT.COUNTER" ) );
}


.newReportId <- function()
{
	# inspired by http://www.broofa.com/Tools/Math.uuid.js
	# creates an almost RFC 4122-compliant version 4 UUID (see Note 1 below)
	# Note 1: since this UUID is going to be part of a JavaScript function name dashes are replaced with underscores
	# Note 2: this is written for convenience, not performance
	# Note 3: the "R" at position 1 is required to make the id a valid HTML id
	
	template <- unlist( strsplit( "Rxxxxxxxx_xxxx_4xxx_yxxx_xxxxxxxxxxxx", "" ) );
	hex <- unlist( strsplit( "0123456789ABCDEF", "" ) );
	
	result <- unlist( lapply( template, function( c ) {	
						r <- floor( runif( n=1, min=1, max=16 ) );
						v <- 0;
						
						if ( c == "x" )
						{
							v <- r;
						}
						else if ( c == "y" )
						{
							v <- ( r %% 4 ) + 8;
						}
						else
						{
							return ( c );
						}
						
						return ( hex[v] );
					}) );
	
	return ( paste( result, sep="", collapse="" ) );
}


.removeProtectedElements <- function( element, level )
{
	if ( element$protection > level )
	{
		return ( NULL );
	}
	
	if ( length( element$elements ) > 0 )
	{	
		retainedElements <- list();
		
		for ( i in 1:length( element$elements ) )
		{
			result <- .removeProtectedElements( element$elements[[i]], level );
			
			if ( !is.null( result ) )
			{
				retainedElements[[length( retainedElements ) + 1]] <- result;
			}						
		}
		
		element$elements <- retainedElements;
	}
	
	return ( element );
}


.updateNumberedElements <- function( element, supplement=FALSE )
{
	if ( element$type == .ELEMENT.FIGURE )
	{
		if ( !supplement )
		{
			element$number <- .getNextFigureNumber();
		}
		else
		{
			element$number <- .getNextSupplementFigureNumber();		
		}
	}
	
	if ( element$type == .ELEMENT.TABLE )
	{
		if ( !supplement )
		{
			element$number <- .getNextTableNumber();
		}
		else
		{
			element$number <- .getNextSupplementTableNumber();		
		}
	}
	
	if ( element$type == .ELEMENT.CITATION )
	{
		element$number <- .getNextCitationNumber();
	}
	
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			if ( !supplement && ( element$type == .ELEMENT.RESULT ) )
			{
				supplement <- TRUE;
			}
			
			element$elements[[i]] <- .updateNumberedElements( element$elements[[i]], supplement=supplement );
		}
	}
	
	return ( element );
}


.countSignificantResults <- function( element )
{
	counter <- 0;
	
	if ( element$type == .ELEMENT.RESULT )
	{
		if ( element$isSignificant == TRUE )
		{
			counter <- counter + 1;
		}
	}
	
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			counter <- counter + .countSignificantResults( element$elements[[i]] );
		}
	}
	
	return ( counter );
}


.getReference <- function( referenceId, element )
{
	if ( element$id == referenceId )
	{
		if ( element$type == .ELEMENT.CITATION )
		{
			return ( .concat( "[", element$number, "]" ) );		
		}
		
		return ( .concat( element$niceType, " ", element$number ) );
	}
	
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			result <- .getReference( referenceId, element$elements[[i]] );
			
			if ( !is.null( result ) )
			{
				return ( result );
			}				
		}
	}
	
	return ( NULL );
}


.updateReferences <- function( element, report )
{
	if ( !is.null( element$text ) )
	{
		if ( is.list( element$text ) )
		{
			updatedText = "";
			
			if ( length( element$text ) > 0 )
			{
				for ( i in 1:length( element$text ) )
				{
					if ( is.list( element$text[[i]] ) || is.null( element$text[[i]] ) || is.na( element$text[[i]] ) )
					{
						next();
					}
					
					if ( substr( element$text[[i]], 0, nchar( .REFERENCE.STRING ) ) == .REFERENCE.STRING )
					{
						referenceId <- substr( element$text[[i]], nchar( .REFERENCE.STRING ) + 1, nchar( element$text[[i]] ) );
						referenceText <- .getReference( referenceId, report );
						
						if ( is.null( referenceText ) )
						{
							stop( paste( "Element", referenceId, "is referenced but not included in the report." ) );
						}
						
						updatedText <- paste( updatedText, referenceText, sep="" );
					}
					else
					{
						updatedText <-paste( updatedText, element$text[[i]], sep="" );
					}								
				}			
			}
			
			element$text <- updatedText;
		}
	}
	
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			element$elements[[i]] <- .updateReferences( element$elements[[i]], report );
		}
	}		
	
	return ( element );
}


.updateResults <- function( element, report )
{
	# keeps track of all results that are encountered in this element
	resultList <- list();
	
	if ( !is.null( element$text ) )
	{
		if ( is.list( element$text ) )
		{
			updatedList <- list();
			j <- 1;
			
			if ( length( element$text ) > 0 )
			{
				for ( i in 1:length( element$text ) )
				{
					if ( is.list( element$text[[i]] ) )
					{
						# TODO: check if this is really of type result!!!!
						result <- element$text[[i]];
						
						if ( result$isSignificant == TRUE )
						{					
							if ( length( result$elements ) == 0 )
							{								
								updatedList[[j]] <- .tag( "span", class=c( "result", "significant", "noevidence" ) );
							}
							else
							{
								updatedList[[j]] <- .tag( "span", id=.concat( "resultid_", result$resultId ), class=c( "result", "significant" ) );
							}							
						}
						else
						{
							if ( length( result$elements ) == 0 )
							{
								updatedList[[j]] <- .tag( "span", class=c( "result", "noevidence" ) );
							}
							else
							{
								updatedList[[j]] <- .tag( "span", id=.concat( "resultid_", result$resultId ), class=c( "result" ) );
							}
						}
						j <- j + 1;
						
						result <- .updateReferences( result, report );
						
						updatedList[[j]] <- result$title;
						j <- j + 1;
						
						updatedList[[j]] <- .tag( "/span" );
						j <- j + 1;	
						
						# the result should be added to the parent
						# add the result linked from the result summary to this element:
						resultList[[length( resultList ) + 1]] <- result;
					}
					else
					{
						updatedList[[j]] <-element$text[[i]];
						j <- j + 1;
					}				
				}			
			}
			
			element$text <- updatedList;
		}
	}
	
	if ( length( element$elements ) > 0 )
	{	
		updatedElements <- list();
		
		for ( i in 1:length( element$elements ) )
		{
			update <- .updateResults( element$elements[[i]], report );
			
			updatedElements[[length( updatedElements ) + 1]] <- update$element;
			
			# if results were found in the element they will be inserted after the element into the report tree
			if ( length( update$results ) > 0 )
			{
				for ( r in 1:length( update$results ) )
				{
					updatedElements[[length( updatedElements ) + 1]] <- update$results[[r]];
				}
			}
		}
		
		# replace old elements with updated list
		element$elements <- updatedElements;
	}		
	
	return ( list( element=element, results=resultList ) );
}


.log <- function( ..., severity=.SEVERITY.LOG )
{			
	message <- .concat( ... );
	
	if ( severity == .SEVERITY.LOG )
	{
		message( "Log: ", message, "\n" );
	}
	
	if ( severity == .SEVERITY.WARNING )
	{
		warning( message );
	}
	
	if ( severity == .SEVERITY.ERROR )
	{
		stop( message );
	}
}


# --- element constructors -------------------------------------------------------------------------

.newElement <- function( elementType, title=NULL, text=NULL, niceType=NULL, domId=NULL, class=NULL, exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- list( type = elementType );
	element$elements <- list();
	element$protection <- protection;
	
	element$id <- .getNextElementId();
	
	if ( !missing( title ) )
	{
		element$title <- title;
	}
	
	if ( !missing( text ) )
	{	
		element$text <- text;
	}
	
	if ( !missing( niceType ) )
	{	
		element$niceType <- niceType;
	}
	
	if ( !missing( domId ) )
	{
		element$domId <- domId;
	}
	
	if ( !missing( class ) )
	{
		element$class <- class;
	}
	
	if ( !missing( exportId ) )
	{
		element$exportId <- exportId;
	}
	else
	{
		element$exportId = NULL;
	}
	
	
	return ( element );
}


#' Create a new report with pre-defined sections Overview/Introduction, Overview/Summary, Results, Methods & Data/Input, Methods & Data/References and Meta Data. 
#' @param ... One or more strings that will be concatenated into the report title.
#' @param version Version number. Not in use.
#' @export
#' @return A new report element. 
#' 
#' @author Nils Gehlenborg (nils@@hms.harvard.edu)
newReport <- function( ..., version=0 )
{
	if ( !missing( ... ) )
	{
		element <- .newGeneralReport( ..., version=version );
	}
	else
	{
		element <- .newGeneralReport( "Nozzle Report", version=version );
	}
	
	overview <- newSection( "Overview" );
	overview$domId <- "overview";
	
	introduction <- newSubSection( "Introduction" );
	introduction$domId <- "introduction";
	
	summary <- newSubSection( "Summary" );
	summary$domId  <- "summary";
	
	results <- newSection( "Results", class="results" );
	results$domId  <- "results";
	
	methods <- newSection( "Methods & Data" );
	methods$domId <- "methods";	
	
	input <- newSubSection( "Input" );
	input$domId <- "input";
	
	references <- newSubSection( "References" )
	references$domId <- "references";
	
	meta <- newSection( "Meta Information", class="meta" )
	meta$domId <- "meta";		
	
	# If a new predefined section is added here a ".hasPredefinedXXXSection" function needs to be added below as well as an an "addToXXX" function.
	
	element$predefined <- list();
	element$predefined$overviewId <- overview$id;
	element$predefined$introductionId <- introduction$id;
	element$predefined$summaryId <- summary$id;
	element$predefined$resultsId <- results$id;
	element$predefined$methodsId <- methods$id;
	element$predefined$inputId <- input$id;
	element$predefined$referencesId <- references$id;
	element$predefined$metaId <- meta$id;
	
	element <- addTo( parent=element, addTo( parent=overview, introduction, summary ) );
	element <- addTo( parent=element, results );
	element <- addTo( parent=element, addTo( parent=methods, input, references ) );
	element <- addTo( parent=element, meta );
}


.hasPredefinedOverviewSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "overviewId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedSummarySection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "summaryId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedIntroductionSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "introductionId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedResultsSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "resultsId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedInputSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "inputId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedReferencesSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "referencesId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedMethodsSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "methodsId" %in% names( report$predefined ) ) ) );
}


.hasPredefinedMetaSection <- function( report )
{
	return ( ( is.list( report$predefined ) && ( "metaId" %in% names( report$predefined ) ) ) );
}


#' Create a new custom report without pre-defined sections.
#' @param ... One or more strings that will be concatenated into the report title.
#' @param version Version number. Not in use.
#' @export
#' @return A new report element. 
#' 
#' @author Nils Gehlenborg (nils@@hms.harvard.edu)
newCustomReport <- function( ..., version=0 )
{
	if ( !missing( ... ) )
	{
		element <- .newGeneralReport( ..., version=version );
	}
	else
	{
		element <- .newGeneralReport( "Nozzle Custom Report", version=version );
	}	
}


.newGeneralReport <- function( ..., version=0 )
{
	element <- .newElement( .ELEMENT.REPORT, .concat( ... ) );
	
	element$subTitle <- NA;
	
	element$meta <- list();
	
	# report version
	element$meta$version <- version;
	
	# report creator software
	element$meta$creator$name <- .getPackageVersion();
	element$meta$renderer$name <- element$meta$creator$name;
	
	# report creation date
	element$meta$creator$date <- date();		
	element$meta$renderer$date <- element$meta$creator$date;
	
	# maintainer details
	element$meta$maintainer$name <- NA;
	element$meta$maintainer$email <- NA;
	element$meta$maintainer$affiliation <- NA;
	
	# DOI resolver URL
	setDoiResolver( element, DEFAULT.DOI.RESOLVER );
	
	# report navigation: parent, prev, next
	element$navigation <- list();
	
	element$navigation$parentUrl <- NA;
	element$navigation$parentName <- NA;
	
	element$navigation$nextUrl <- NA;
	element$navigation$nextName <- NA;
	
	element$navigation$previousUrl <- NA;
	element$navigation$previousName <- NA;
		
	return ( element );
}


#' Set the URL and title of the "next" report after \code{report}. This will be accessible through the utility menu. 
#' @param report Report object.
#' @param url URL of the next report.
#' @param ... One or more strings that will be concatenated to form the title of the next report.
#' @export
#' @return Updated report element.
#' 
#' @author nils
setNextReport <- function( report, url, ... )
{
	if ( is.null( report$navigation ) )
	{
		report$navigation <- list();
	}
	
	report$navigation$nextUrl <- url;
	report$navigation$nextName <- .concat( ... );	
	
	return ( report );
}


#' Set the URL and title of the "previous" report before \code{report}. This will be accessible through the utility menu.
#' @param report Report object.
#' @param url URL of the next report.
#' @param ... One or more strings that will be concatenated to form the title of the previous report.
#' @export
#' @return Updated report element.
#' 
#' @author nils
setPreviousReport <- function( report, url, ... )
{
	if ( is.null( report$navigation ) )
	{
		report$navigation <- list();
	}
	
	report$navigation$previousUrl <- url;
	report$navigation$previousName <- .concat( ... );	
	
	return ( report );
}


#' Set the URL and title of the "parent" report above \code{report}. This will be accessible through the utility menu. 
#' @param report Report object.
#' @param url URL of the next report.
#' @param ... One or more strings that will be concatenated to form the title of the parent report.
#' @export
#' @return Updated report element.
#' 
#' @author nils
setParentReport <- function( report, url, ... )
{
	if ( is.null( report$navigation ) )
	{
		report$navigation <- list();
	}
	
	report$navigation$parentUrl <- url;
	report$navigation$parentName <- .concat( ... );	
	
	return ( report );
}


#' Get the title of \code{report}.
#' @param report Report element.
#' @export
#' @return Title of \code{report}
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getReportTitle <- function( report )
{
	if ( is.null( report$title ) )
	{
		return ( NA );
	}
	
	return ( report$title );
}


#' Set the title of \code{report}.
#' @param report Report element. 
#' @param ... One or more strings that will be concatenated to form the title of the report.
#' @export
#' @return Updated report element or NA if \code{report} has no title element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setReportTitle <- function( report, ... )
{
	if ( !is.null( report$title ) )
	{
		report$title <- .concat( ... );
		
		return ( report );
	}
	
	return ( NA );
}


#' Get the subtitle of \code{report}.
#' @param report Report element.
#' @export
#' @return SubTitle of \code{report}
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getReportSubTitle <- function( report )
{
	if ( is.null( report$subTitle ) )
	{
		return ( NA );
	}
	
	return ( report$subTitle );
}


#' Set the subtitle of \code{report}.
#' @param report Report element. 
#' @param ... One or more strings that will be concatenated to form the subtitle of the report.
#' @export
#' @return Updated report element or NA if \code{report} has no subtitle element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setReportSubTitle <- function( report, ... )
{
	if ( !is.null( report$subTitle ) )
	{
		report$subTitle <- .concat( ... );
		
		return ( report );
	}
	
	return ( NA );
}



#' Get the ID (a UUID) of \code{report}.
#' @param report Report element.
#' @export
#' @return ID of \code{report} or NA.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getReportId <- function( report )
{
	if ( is.null( report$reportId ) )
	{
		return ( NA );
	}
	
	return ( report$reportId );
}


#' Get name and version of the Nozzle package that was used to render \code{report}.
#' @param report Report element.
#' @export
#' @return Name and version of the Nozzle package that rendered \code{report} or NA.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getRendererName <- function( report )
{
	if ( is.null( report$meta$renderer ) || is.atomic( report$meta$renderer ) )
	{
		return ( NA );
	}
	
	if ( is.null( report$meta$renderer$name ) )
	{
		return ( NA );
	}
	
	return ( report$meta$renderer$name );
}


#' Get date when \code{report} was rendered.
#' @param report Report element.
#' @export
#' @return Date when \code{report} was rendered or NA.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getRendererDate <- function( report )
{
	if ( is.null( report$meta$renderer ) || is.atomic( report$meta$renderer ) )
	{
		return ( NA );
	}
	
	if ( is.null( report$meta$renderer$date ) )
	{
		return ( NA );
	}
	
	return ( report$meta$renderer$date );
}


#' Get name and version of the Nozzle package that was used to create \code{report}.
#' @param report Report element.
#' @export
#' @return Name and version of the Nozzle package that created \code{report} or NA.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCreatorName <- function( report )
{
	if ( is.null( report$meta$creator ) || is.atomic( report$meta$creator ) )
	{
		return ( NA );
	}
	
	if ( is.null( report$meta$creator$name ) )
	{
		return ( NA );
	}
	
	return ( report$meta$creator$name );
}


#' Get date when \code{report} was created.
#' @param report Report element.
#' @export
#' @return Date when \code{report} was created or NA.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCreatorDate <- function( report )
{
	if ( is.null( report$meta$creator ) || is.atomic( report$meta$creator ) )
	{
		return ( NA );
	}
	
	if ( is.null( report$meta$creator$date ) )
	{
		return ( NA );
	}
	
	return ( report$meta$creator$date );
}


#' Set the name of the software that used Nozzle to generate \code{report}, e.g. "My Report Generator Script".
#' @param report Report element. 
#' @param ... One or more strings that will be concatenated to form the name of the software.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setSoftwareName <- function( report, ... )
{
	if ( is.null( report$meta$software ) )
	{
		report$meta$software <- list();
	}
	
	report$meta$software$name <- .concat( ... );	
	
	return ( report );
}


#' Get the name of the software that used Nozzle to generate \code{report}.
#' @param report Report element. 
#' @export
#' @return Name of the software that used Nozzle to generate \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getSoftwareName <- function( report )
{
	if ( is.null( report$meta$software ) )
	{
		return ( NA );
	}
	
	if ( is.null( report$meta$software$name ) )
	{
		return ( NA );
	}
	
	return ( report$meta$software$name );
}


#' Set the name of the software that used Nozzle to generate \code{report}, e.g. "Version 1.2".
#' @param report Report element. 
#' @param ... One or more strings that will be concatenated to form the version of the software.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setSoftwareVersion <- function( report, ... )
{
	if ( is.null( report$meta$software ) )
	{
		report$meta$software <- list();
	}
	
	report$meta$software$version <- .concat( ... );	
	
	return ( report );
}


#' Get the version of the software that used Nozzle to generate \code{report}.
#' @param report Report element. 
#' @export
#' @return Version of the software that used Nozzle to generate \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getSoftwareVersion <- function( report )
{
	if ( is.null( report$meta$software ) )
	{
		return ( NA );
	}
	
	if ( is.null( report$meta$software$version ) )
	{
		return ( NA );
	}
	
	return ( report$meta$software$version );
}


#' Set a logo file for one of six positions (three at the top, three at the bottom) in \code{report}, e.g. an institute logo.
#' @param report Report element. 
#' @param filename Path or URL to the logo file (relative) to the final location of the report HTML file.
#' @param position One of LOGO.TOP.LEFT, LOGO.TOP.CENTER, LOGO.TOP.RIGHT, LOGO.BOTTOM.LEFT, LOGO.BOTTOM.CENTER, LOGO.BOTTOM.RIGHT. 
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setLogo <- function( report, filename, position )
{
	if ( is.null( report$meta$logo ) )
	{
		report$meta$logo <- list();
	}
	
	# top logos
	if ( position == LOGO.TOP.LEFT )
	{	
		report$meta$logo$topleft <- filename;	
	}
	
	if ( position == LOGO.TOP.CENTER )
	{	
		report$meta$logo$topcenter <- filename;	
	}
	
	if ( position == LOGO.TOP.RIGHT )
	{	
		report$meta$logo$topright <- filename;	
	}
	
	# bottom logos
	if ( position == LOGO.BOTTOM.LEFT )
	{	
		report$meta$logo$bottomleft <- filename;	
	}
	
	if ( position == LOGO.BOTTOM.CENTER )
	{	
		report$meta$logo$bottomcenter <- filename;	
	}
	
	if ( position == LOGO.BOTTOM.RIGHT )
	{	
		report$meta$logo$bottomright <- filename;	
	}
	
	return ( report );
}


#' Get logo file for one of six positions (three at the top, three at the bottom) in \code{report}.
#' @param report Report element. 
#' @param position One of LOGO.TOP.LEFT, LOGO.TOP.CENTER, LOGO.TOP.RIGHT, LOGO.BOTTOM.LEFT, LOGO.BOTTOM.CENTER, LOGO.BOTTOM.RIGHT. 
#' @export
#' @return Path or URL to the logo file at \code{position}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getLogo <- function( report, position )
{
	if ( is.null( report$meta$logo ) )
	{
		return ( NA );
	}
	
	# top logos
	if ( position == LOGO.TOP.LEFT )
	{	
		if ( is.null( report$meta$logo$topleft ) )
		{
			return ( NA );
		}
		
		return ( report$meta$logo$topleft )
	}
	
	if ( position == LOGO.TOP.CENTER )
	{	
		if ( is.null( report$meta$logo$topcenter ) )
		{
			return ( NA );
		}
		
		return ( report$meta$logo$topcenter )
	}
	
	if ( position == LOGO.TOP.RIGHT )
	{	
		if ( is.null( report$meta$logo$topright ) )
		{
			return ( NA );
		}
		
		return ( report$meta$logo$topright )
	}
	
	# bottom logos
	if ( position == LOGO.BOTTOM.LEFT )
	{	
		if ( is.null( report$meta$logo$bottomleft ) )
		{
			return ( NA );
		}
		
		return ( report$meta$logo$bottomleft )
	}
	
	if ( position == LOGO.BOTTOM.CENTER )
	{	
		if ( is.null( report$meta$logo$bottomcenter ) )
		{
			return ( NA );
		}
		
		return ( report$meta$logo$bottomcenter )
	}
	
	if ( position == LOGO.BOTTOM.RIGHT )
	{	
		if ( is.null( report$meta$logo$bottomright ) )
		{
			return ( NA );
		}
		
		return ( report$meta$logo$bottomright )
	}
		
	return ( NA );
}


#' Set name of maintainer of \code{report}.
#' @param report Report element.
#' @param ... One or more strings that will be concatenated to form the name of the maintainer.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setMaintainerName <- function( report, ... )
{
	if ( is.null( report$meta$maintainer ) )
	{
		report$meta$maintainer <- list();
	}
	
	report$meta$maintainer$name <- .concat( ... );	
	
	return ( report );
}


#' Get name of maintainer of \code{report}.
#' @param report Report element.
#' @export
#' @return Name of the maintainer.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getMaintainerName <- function( report )
{
	if ( is.null( report$meta$maintainer$name ) )
	{
		return ( NA );
	}
	
	return ( report$meta$maintainer$name );
}


#' Set email address of maintainer of \code{report}.
#' @param report Report element.
#' @param ... One or more strings that will be concatenated to form the email address of the maintainer.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setMaintainerEmail <- function( report, ... )
{
	if ( is.null( report$meta$maintainer ) )
	{
		report$meta$maintainer <- list();
	}
	
	report$meta$maintainer$email <- .concat( ... );	
	
	return ( report );
}


#' Get email address of maintainer of \code{report}.
#' @param report Report element.
#' @export
#' @return Email address of the maintainer.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getMaintainerEmail <- function( report )
{
	if ( is.null( report$meta$maintainer$email ) )
	{
		return ( NA );
	}
	
	return ( report$meta$maintainer$email );
}


#' Set affiliation of maintainer of \code{report}.
#' @param report Report element.
#' @param ... One or more strings that will be concatenated to form the affiliation of the maintainer.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setMaintainerAffiliation <- function( report, ... )
{
	if ( is.null( report$meta$maintainer ) )
	{
		report$meta$maintainer <- list();
	}
	
	report$meta$maintainer$affiliation <- .concat( ... );	
	
	return ( report );
}


#' Get affiliation of maintainer of \code{report}.
#' @param report Report element.
#' @export
#' @return Affiliation of the maintainer.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getMaintainerAffiliation <- function( report )
{
	if ( is.null( report$meta$maintainer$affiliation ) )
	{
		return ( NA );
	}
	
	return ( report$meta$maintainer$affiliation );
}


#' Set copyright messsage for \code{report}.
#' @param report Report element.
#' @param owner Copyright owner, e.g. "The President and Fellows of Harvard College".
#' @param year Copyright year, e.g. "2012" or "2011-2013".
#' @param statement Copyright statement, e.g. "All rights reserved.".
#' @param url A URL that will be linked to the copyright owner.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setCopyright <- function( report, owner, year, statement=NA, url=NA )
{
	if ( is.null( report$meta$copyright ) )
	{
		report$meta$copyright <- list();
	}
	
	report$meta$copyright$owner <- owner;	
	report$meta$copyright$year <- year;		
	report$meta$copyright$statement <- statement;
	report$meta$copyright$url <- url;		
	
	return ( report );
}


#' Set contact information for \code{report}. This is used to create a "contact" button in the top right corner of the report, e.g. to collect feedback about the report.
#' @param report Report element.
#' @param email Email address of the recipient of contact emails. 
#' @param subject Subject of the email to be sent.
#' @param message Message used to pre-populate the email body.
#' @param label Label for the button, e.g. "Contact Us". 
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setContactInformation <- function( report, email, subject, message, label=NA )
{
	if ( is.null( report$meta$contact ) )
	{
		report$meta$contact <- list();
	}
	
	report$meta$contact$label <- label;	
	report$meta$contact$email <- email;	
	report$meta$contact$subject <- subject;	
	report$meta$contact$message <- gsub( "\n", "%0A", message ); # line breaks will break the Javascript code
	
	return ( report );
}


#' Get contact email address for \code{report}.
#' @param report Report element.
#' @export
#' @return Contact email address.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getContactInformationEmail <- function( report )
{
	if ( is.null( report$meta$contact$email ) )
	{
		return ( NA );
	}
	
	return ( report$meta$contact$email );
}


#' Get contact email subject line for \code{report}.
#' @param report Report element.
#' @export
#' @return Contact email subject line.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getContactInformationSubject <- function( report )
{
	if ( is.null( report$meta$contact$subject ) )
	{
		return ( NA );
	}
	
	return ( report$meta$contact$subject );
}


#' Get contact email default message for \code{report}.
#' @param report Report element.
#' @export
#' @return Contact email default message.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getContactInformationMessage <- function( report )
{
	if ( is.null( report$meta$contact$message ) )
	{
		return ( NA );
	}
	
	return ( report$meta$contact$message );
}


#' Get label for contact button for \code{report}.
#' @param report Report element.
#' @export
#' @return Contact email button label.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getContactInformationLabel <- function( report )
{
	if ( is.null( report$meta$contact$label ) )
	{
		return ( NA );
	}
	
	return ( report$meta$contact$label );
}


#' Get name of the copyright owner for \code{report}.
#' @param report Report element.
#' @export
#' @return Name of the copyright owner.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCopyrightOwner <- function( report )
{
	if ( is.null( report$meta$copyright$owner ) )
	{
		return ( NA );
	}
	
	return ( report$meta$copyright$owner );
}


#' Get copyright year \code{report}.
#' @param report Report element.
#' @export
#' @return Copyright year.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCopyrightYear <- function( report )
{
	if ( is.null( report$meta$copyright$year ) )
	{
		return ( NA );
	}
	
	return ( report$meta$copyright$year );
}


#' Get copyright URL for \code{report}, which is linked to the copyright statement.
#' @param report Report element.
#' @export
#' @return Copyright URL.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCopyrightUrl <- function( report )
{
	if ( is.null( report$meta$copyright$url) )
	{
		return ( NA );
	}
	
	return ( report$meta$copyright$url );
}


#' Get copyright statement for \code{report}. This text is linked to the copyright URL.
#' @param report Report element.
#' @export
#' @return Text of the c	opyright statement.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCopyrightStatement <- function( report )
{
	if ( is.null( report$meta$copyright$statement ) )
	{
		return ( NA );
	}
	
	return ( report$meta$copyright$statement );
}


#' Set name of entities that are called out as significant, e.g. "gene". This is currently not being used and might become obsolete in future versions of Nozzle.
#' @param report Report element.
#' @param ... List of strings that will be concatenated to form the name of the entities. 
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setSignificantEntity <- function( report, ... )
{
	report$meta$significantEntity <- .concat( ... );
	
	return ( report );
}


#' Get name of entities that are called out as significant, e.g. "gene". This is currently not being used and might become obsolete in future versions of Nozzle.
#' @param report Report element.
#' @export
#' @return Name of entities called out as significant.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getSignificantEntity <- function( report )
{
	if ( is.null( report$meta$significantEntity ) )
	{            
		return ( DEFAULT.SIGNIFICANT.ENTITY );
	}
	
	return ( report$meta$significantEntity );
}


#' Set the DOI (document object identifier, http://www.doi.org) for \code{report}. A warning will be emitted if the report has been assigned a DOI before.
#' @param report Report element.
#' @param doi The document object identifier. 
#' @export
#' @return Updated report element.
#' @note A document object identifer must have been created before this is called.
#' @references \url{http://www.doi.org}
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoi <- function( report, doi )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}
	
	if ( !is.null( report$meta$doi$identifier ) )
	{
		warning( "This report has already been assigned a DOI (", report$meta$doi$identifier ,"), which will be overwritten. Each report should only be assigned a single DOI." );
	}
	
	report$meta$doi$identifier <- doi;		
	
	return ( report );
}


#' Get the DOI (document object identifier, http://www.doi.org) for \code{report}.
#' @param report Report element.
#' @export
#' @return Document object identifier (DOI) for \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoi <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$identifier ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$identifier );
}


#' Set the DOI meta data creator for \code{report}.
#' @param report Report element.
#' @param creator Name of the report creator/author. 
#' @export
#' @return Updated report element.
#' @note This should match the meta data stored for the DOI.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoiCreator <- function( report, creator )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}
		
	report$meta$doi$creator <- creator;		
	
	return ( report );
}


#' Get the DOI creator for \code{report}.
#' @param report Report element.
#' @export
#' @return Creator associated with the DOI of the report \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoiCreator <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$creator ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$creator );
}


#' Set the DOI meta data title for \code{report}.
#' @param report Report element.
#' @param title Title of the report. 
#' @export
#' @return Updated report element.
#' @note This should match the meta data stored for the DOI.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoiTitle <- function( report, title )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}	
	
	report$meta$doi$title <- title;		
	
	return ( report );
}


#' Get the DOI title for \code{report}.
#' @param report Report element.
#' @export
#' @return Title associated with the DOI of the report \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoiTitle <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$title ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$title );
}


#' Set the DOI meta data publisher for \code{report}.
#' @param report Report element.
#' @param publisher Publisher of the report. 
#' @export
#' @return Updated report element.
#' @note This should match the meta data stored for the DOI.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoiPublisher <- function( report, publisher )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}	
	
	report$meta$doi$publisher <- publisher;		
	
	return ( report );
}


#' Get the DOI publisher for \code{report}.
#' @param report Report element.
#' @export
#' @return Publisher associated with the DOI of the report \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoiPublisher <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$publisher ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$publisher );
}


#' Set the DOI meta data year for \code{report}.
#' @param report Report element.
#' @param year Publication year of the report. 
#' @export
#' @return Updated report element.
#' @note This should match the meta data stored for the DOI.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoiYear <- function( report, year )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}	
	
	report$meta$doi$year <- year;		
	
	return ( report );
}


#' Get the DOI year for \code{report}.
#' @param report Report element.
#' @export
#' @return Publication year associated with the DOI of the report \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoiYear <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$year ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$year );
}



#' Set the DOI meta data version for \code{report}.
#' @param report Report element.
#' @param version Version of the report. 
#' @export
#' @return Updated report element.
#' @note This should match the meta data stored for the DOI.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoiVersion <- function( report, version )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}	
	
	report$meta$doi$version <- version;		
	
	return ( report );
}


#' Get the DOI version for \code{report}.
#' @param report Report element.
#' @export
#' @return Version associated with the DOI of the report \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoiVersion <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$version ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$version );
}



#' Set the DOI resolver URL (e.g. http://dx.doi.org) for \code{report}. The URL must not end with a slash!
#' @param report Report element.
#' @param url The resolver URL (without a trailing slash). The default is "http://dx.doi.org". 
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setDoiResolver <- function( report, url )
{
	if ( is.null( report$meta$doi ) )
	{
		report$meta$doi <- list();
	}	
	
	report$meta$doi$resolver <- url;		
	
	return ( report );
}


#' Get the DOI resolver URL (e.g. http://dx.doi.org) for \code{report}.
#' @param report Report element.
#' @export
#' @return Document object identifier (DOI) resolver URL for \code{report}.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getDoiResolver <- function( report )
{
	if ( is.null( report$meta$doi ) )
	{
		return ( NA );
	}	
	
	if ( is.null( report$meta$doi$resolver ) )
	{
		return ( NA );
	}
	
	return ( report$meta$doi$resolver );
}


#' Set the Google Analytics tracking ID to be embedded in this report ("web property id", usually starts with "UA-").
#' @param report Report element.
#' @param id Web property ID for the Google Analytics tracking account. 
#' @export
#' @return Updated report element.
#' @note A (free) Google Analytics account is required.
#' @references \url{http://www.google.com/analytics}
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setGoogleAnalyticsId <- function( report, id )
{
	report$meta$googleAnalyticsId <- id;	
	
	return ( report );
}


#' Get Google Analytics tracking ID for \code{report}.
#' @param report Report element.
#' @export
#' @return Google Analytics Tracking ID or NA if not set.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getGoogleAnalyticsId <- function( report )
{
	if ( is.null( report$meta$googleAnalyticsId ) )
	{
		return ( NA );
	}
	
	return ( report$meta$googleAnalyticsId );
}


#' Set the path or URL of the CSS file to be used to overwrite the default screen (not: print) style sheet. Can be relative or absolute.
#' @param report Report element.
#' @param cssFile URL or a relative or absolute path to a CSS file. 
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setCustomScreenCss <- function( report, cssFile )
{
	report$customScreenCss <- cssFile	
	
	return ( report );
}


#' Get the path or URL of the CSS file to be used to overwrite the default screen (not: print) style sheet. 
#' @param report Report element.
#' @export
#' @return Path or URL of CSS file. Can be relative or absolute.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCustomScreenCss <- function( report )
{
	if ( is.null( report$customScreenCss ) )
	{
		return ( NA );
	}
	
	return ( report$customScreenCss );
}


#' Set the path or URL of the CSS file to be used to overwrite the default print (not: screen) style sheet. Can be relative or absolute.
#' @param report Report element.
#' @param cssFile URL or a relative or absolute path to a CSS file. 
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setCustomPrintCss <- function( report, cssFile )
{
	report$customPrintCss <- cssFile	
	
	return ( report );
}


#' Get the path or URL of the CSS file to be used to overwrite the default print (not: screen) style sheet. 
#' @param report Report element.
#' @export
#' @return Path or URL of CSS file. Can be relative or absolute.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getCustomPrintCss <- function( report )
{
	if ( is.null( report$customPrintCss ) )
	{
		return ( NA );
	}
	
	return ( report$customPrintCss );
}


.addToElementById <- function( element, id, ... )
{	
	# this function will always return the element if successful or not
	# test first with .getElementById (see below) if the element exists
	
	if ( element$id == id )
	{
		element <- addTo( parent=element, ... );
	}
	
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			element$elements[[i]] <- .addToElementById( element$elements[[i]], id, ... );
		}
	}
	
	return ( element );	
}

.getElementById <- function( element, id )
{	
	if ( element$id == id )
	{
		return ( element );
	}
	
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			result <- .getElementById( element$elements[[i]], id );
			
			if ( !is.null( result ) )
			{
				return ( result );
			}
		}
	}
	
	return ( NULL );	
}

# removes element the given id from the tree using breadth-first search
.removeElementById <- function( element, id )
{	
	if ( length( element$elements ) > 0 )
	{	
		newElements <- list();
		
		for ( i in 1:length( element$elements ) )
		{
			if ( element$elements[[i]]$id != id )
			{
				newElements[[length( newElements ) + 1]] <- element$elements[[i]];								
			}
		}
		
		element$elements <- newElements;
		
		if ( length( element$elements ) > 0 )
		{			
			for ( i in 1:length( element$elements ) )
			{
				element$elements[[i]] <- .removeElementById( element$elements[[i]], id );
			}		
		}
	}
	
	return ( element );	
}


#' Get an exported element from a report. This can be used to generate aggregate reports. This is an experimental feature of Nozzle and may not lead to the expected results. 
#' @param report The source report.
#' @param exportId The ID of the exported element. \code{getExportedElementIds} returns a list of exported element IDs.  
#' @export
#' @return The exported report element or NULL if the ID does not exist in \code{report}.
#' @note Elements containing references should not be exported since references cannot be resolved in the target report. Relative paths in exported elements may have to be adjusted manually if the target report will be located in a different directory.  
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getExportedElement <- function( report, exportId )
{	
	if ( !is.null( report$exportId ) && ( report$exportId == exportId ) )
	{
		return ( report );
	}
	
	if ( length( report$elements ) > 0 )
	{	
		for ( i in 1:length( report$elements ) )
		{
			result <- getExportedElement( report$elements[[i]], exportId );
			
			if ( !is.null( result ) )
			{
				return ( result );
			}
		}
	}
	
	return ( NULL );	
}


#' Get the IDs of exported elements from \code{report}. This is an experimental feature of Nozzle and may not lead to the expected results. 
#' @param report The source report.
#' @export
#' @return The IDs of exported report elements or NULL.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getExportedElementIds <- function( report )
{	
	if ( !is.null( report$exportId ) )
	{
		return( report$exportId );
	}
	
	elementIds <- NULL;	
	
	if ( length( report$elements ) > 0 )
	{	
		for ( i in 1:length( report$elements ) )
		{
			elementIds <- c( elementIds, getExportedElementIds( report$elements[[i]] ) );			
		}
	}
	
	return ( unique( elementIds ) );	
}


#' Add elements to the "Results" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the results section. Often these are subsection elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToResults <- function( report, ... )
{
	if ( .hasPredefinedResultsSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$resultsId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined results section. Is this a custom report?" );
}


#' Add elements to the "Methds & Data" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the methods section. Often these are subsection elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToMethods <- function( report, ... )
{
	if ( .hasPredefinedMethodsSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$methodsId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined methods section. Is this a custom report?" );
}



#' Add elements to the "Overview" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the overview section. Often these are subsection elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToOverview <- function( report, ... )
{
	if ( .hasPredefinedOverviewSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$overviewId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined overview section. Is this a custom report?" );
}


#' Add elements to the "Introduction" subsection in the "Overview" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the introduction section. Often these are paragraph elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToIntroduction <- function( report, ... )
{
	if ( .hasPredefinedIntroductionSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$introductionId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined introduction section. Is this a custom report?" );
}


#' Add elements to the "Summary" subsection in the "Overview" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the overview section. Often these are paragraph elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToSummary <- function( report, ... )
{
	if ( .hasPredefinedSummarySection( report ) )
	{
		return ( .addToElementById( report, report$predefined$summaryId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined summary section. Is this a custom report?" );
}


#' Add elements to the "Input" subsection in the "Methods & Data" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the input section. Often these are paragraph elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToInput <- function( report, ... )
{
	if ( .hasPredefinedInputSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$inputId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined input section. Is this a custom report?" );
}


#' Add elements to the "References" subsection in the "Methods & Data" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the references section. These should be citation elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToReferences <- function( report, ... )
{
	if ( .hasPredefinedReferencesSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$referencesId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined references section. Is this a custom report?" );
}


#' Add elements to the "Meta" section of a standard report.
#' @param report Report element. 
#' @param ... Elements that will be added to the references section. These may be any elements.
#' @export
#' @return Updated report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addToMeta <- function( report, ... )
{
	if ( .hasPredefinedMetaSection( report ) )
	{
		return ( .addToElementById( report, report$predefined$metaId, ... ) ); 
	}
	
	stop( "This report does not contain a predefined meta information section. Is this a custom report?" );
}


#' Create a new section element.
#' @param ... Strings that will be concatenated to form the section title. 
#' @param class If set to SECTION.CLASS.RESULTS, results can be reported in this section. If set to SECTION.CLASS.META the section will be a meta data section. 
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newSection <- function( ..., class="", exportId=NULL, protection=PROTECTION.PUBLIC )
{
	return ( .newElement( .ELEMENT.SECTION, .concat( ... ), class=class, exportId=exportId, protection=protection ) );
}


#' Create a new subsection element.
#' @param ... Strings that will be concatenated to form the subsection title. 
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newSubSection <- function( ..., exportId=NULL, protection=PROTECTION.PUBLIC )
{
	return ( .newElement( .ELEMENT.SUBSECTION, .concat( ... ), exportId=exportId, protection=protection ) );
}


#' Create a new subsubsection element.
#' @param ... Strings that will be concatenated to form the subsubsection title. 
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newSubSubSection <- function( ..., exportId=NULL, protection=PROTECTION.PUBLIC )
{
	return ( .newElement( .ELEMENT.SUBSUBSECTION, .concat( ... ), exportId=exportId, protection=protection ) );
}


.writeSection <- function ( element, file, level="" )
{
	if ( is.null( element$domId ) )
	{	
		.write( .tag( "div", class=.concat( level, "section", " ", element$class ) ), file );
	}
	else
	{
		.write( .tag( "div", class=.concat( level, "section", " ", element$class ), id=element$domId ), file );
	}
	
	.write( .tag( "div", class="sectionheader" ), file );
	.write( element$title, file );
	.write( .tag( "/div" ), file );
	
	.write( .tag( "div", class="sectionbody" ), file );
	.writeElements( element, file );
	.write( .tag( "/div" ), file );
	
	.write( .tag( "/div" ), file );	
}


#' Create a new list element.
#' @param ... Elements of type paragraph, list or result that will form the items in the list.
#' @param isNumbered If set to FALSE, the list will be unordered with bullet points. If set to TRUE, the list will be numbered with arabic numerals.  
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP or PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newList <- function( ..., isNumbered=FALSE, exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- .newElement( .ELEMENT.LIST, exportId=exportId, protection=protection );
	
	element$isNumbered <- isNumbered;
	
	if ( missing( ... ) )
	{
		return ( element );
	}	
	
	args <- list( ... );
	
	# TODO: run the same checks in "addTo"
	for ( i in 1:length( args ) )
	{
		if ( args[[i]]$type == .ELEMENT.PARAGRAPH ||
				args[[i]]$type == .ELEMENT.LIST ||
				args[[i]]$type == .ELEMENT.RESULT )
		{
			element$elements[[length( element$elements ) + 1]] <- args[[i]];
		}
		else
		{
			stop( "Report elements of type ", args[[i]]$element$type, " can not be added to a list." );
		}
	}
	
	return ( element );
}

.writeList <- function( element, file )
{
	if ( element$isNumbered == TRUE )
	{
		.write( .tag( "ol" ), file );	
	}
	else
	{
		.write( .tag( "ul" ), file );			
	}
	
	for ( i in 1:length( element$elements ) )
	{
		if ( ( element$elements[[i]]$type != .ELEMENT.LIST ) && ( element$elements[[i]]$type != .ELEMENT.RESULT ) )
		{
			.write( .tag( "li" ), file );		
			.writeElement( element$elements[[i]], file );		
			.write( .tag( "/li" ), file );
		}
		else
		{		
			.writeElement( element$elements[[i]], file );		
		}
	}
	
	if ( element$isNumbered == TRUE )
	{
		.write( .tag( "/ol" ), file );	
	}	
	else
	{
		.write( .tag( "/ul" ), file );			
	}
}


#' Create a new list element.
#' @param file Path or URL to the image file. Paths can be absolute or relative.
#' @param ... Strings that will be concatenated to form the figure caption. 
#' @param fileHighRes Path or URL to a high-resolution or vector-based version of the image file. Paths can be absolute or relative.
#' @param type Currenlty only IMAGE.TYPE.RASTER is allowed.
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newFigure <- function( file, ..., fileHighRes=NA, type=IMAGE.TYPE.RASTER, exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- .newElement( .ELEMENT.FIGURE, niceType="Figure", exportId=exportId, protection=protection );
	
	element$imageFilename <- file;
	element$imageFilenameHighRes <- fileHighRes;
	element$imageType <- type;
	
	element$text <- list( ... );
	
	return ( element );
}


#' Test if \code{element} is a figure element.
#' @param element Element to test. 
#' @export
#' @return TRUE if the element is a figure, FALSE otherwise.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
isFigure <- function( element )
{
	return ( element$type == .ELEMENT.FIGURE );
}


#' Get path or URL of image file associated with a figure element.
#' @param element Figure element.
#' @export
#' @return Path or URL of the image file or NA if \code{element} is not a figure.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getFigureFile <- function( element )
{
	if ( isFigure( element ) )
	{
		return ( element$imageFilename );
	}
	
	return ( NA );
}


#' Set path or URL of image file associated with a figure element. Paths can relative or absolute.
#' @param element A figure element. 
#' @param file Path or URL of the image file.
#' @export
#' @return Updated figure element or NA is \code{element} is not a figure.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setFigureFile <- function( element, file )
{
	if ( isFigure( element ) )
	{
		element$imageFilename <- file;
		
		return ( element );
	}
	
	return ( NA );
}


#' Get path or URL of high-resolution of vector-based image file associated with a figure element.
#' @param element Figure element.
#' @export
#' @return Path or URL of the image file or NA if \code{element} is not a figure.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getFigureFileHighRes <- function( element )
{
	if ( isFigure( element ) )
	{
		return ( element$imageFilenameHighRes );
	}
	
	return ( NA );
}


#' Set path or URL of high-resolution or vector-based image file associated with a figure element. Paths can be relative or absolute.
#' @param element A figure element. 
#' @param file Path or URL of the image file.
#' @export
#' @return Updated figure element or NA is \code{element} is not a figure.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
setFigureFileHighRes <- function( element, file )
{
	if ( isFigure( element ) )
	{
		element$imageFilenameHighRes <- file;
		
		return ( element );
	}
	
	return ( NA );
}


.writeFigure <- function ( element, file )
{
	figureNumber <- element$number;
	
	# supplementary figure?
	if ( figureNumber < 0 )
	{
		figureNumber <- .concat( "S", abs( figureNumber ) );
	}
	
	.write( .tag( "div", class="figure", id=.concat( "figure_", figureNumber ) ), file );
	
	.write(	.tag( "div", class="caption" ), file );
	.write( .tag( "p" ), file );
	
	# "Figure 1. " ...
	.write( asStrong( element$niceType, "&nbsp;", figureNumber, ".&nbsp;" ), file );
	
	if ( !is.na( element$imageFilenameHighRes ) )
	{
		.write( "\n", .tag( "a", class="download", other=.concat( "href=\"", element$imageFilenameHighRes , "\"" ) ), "Get High-res Image", .tag( "/a" ), "\n", file );	
	}
	.write( element$text, file );
	.write( .tag( "/p" ), file );
	.write( .tag( "/div" ), file ); # caption
	
	.write( .tag( "div", class="image" ), file );
	
	
	if ( ( element$imageType == IMAGE.TYPE.RASTER ) || ( is.null( element$imageType ) ) )
	{
		.write( .tag( "img", other=.concat( "src=\"", element$imageFilename, "\"/" ) ), file );
	}
	else if ( element$imageType == IMAGE.TYPE.SVG )
	{
		.write( .tag( "object", other=.concat( "data=\"", element$imageFilename, "\" type=\"image/svg+xml\"" ) ), file );
		.write( .tag( "/object" ), file );
	}
	else
	{
		stop( "Unknown image type selected in newFigure()." );
	}		
	
	.write( .tag( "/div" ), file ); # image
	
	.write( .tag( "/div" ), file ); # figure
}


#' Create new table element. 
#' @param table A matrix or data frame containing the table data. Column names will be extracted and used as column headers.  
#' @param ... Strings that will be concatenated to form the table caption. 
#' @param file Path or URL to a file containing the full table. It is recommend to only show a relevant subset of all results in the report itself to increase readability.
#' @param significantDigits Number of significant digits used to trim all numeric columns. The default is \code{TABLE.SIGNIFICANT.DIGITS}. 
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newTable <- function( table, ..., file=NA, significantDigits=TABLE.SIGNIFICANT.DIGITS, exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- .newElement( .ELEMENT.TABLE, niceType="Table", exportId=exportId, protection=protection );
	
	element$table <- table;
	element$tableSignificantDigits <- significantDigits;
	element$tableFilename <- file;
	
	element$resultList <- list();
	
	if ( !is.null( dim( table ) ) )
	{
		element$resultIndices <- array( dim=dim( table ) );	
	}
	
	element$text <- list( ... );
	
	return ( element );
}


#' Test if \code{element} is a table element.
#' @param element Element to test.
#' @export
#' @return TRUE if the element is a table, FALSE otherwise.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
isTable <- function( element )
{
	return ( element$type == .ELEMENT.TABLE );
}


#' Get path or URL of file associatd with table element.
#' @param element Table element.
#' @export
#' @return Path or URL.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getTableFile <- function( element )
{
	if ( isTable( element ) )
	{
		return ( element$tableFilename );
	}
	
	return ( NA );
}


#' Set path or URL of file associatd with table element.
#' @param element Table element.
#' @param file Path or URL to file.
#' @export
#' @return Updated element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}

setTableFile <- function( element, file )
{
	if ( isTable( element ) )
	{
		element$tableFilename <- file;
		
		return ( element );
	}
	
	return ( NA );
}


.trimTable <- function( table, significantDigits=3 )
{
	if ( significantDigits <= 0 )
	{
		return ( table );
	}
	
	for( c in 1:dim( table )[2] )
	{		
		# if this column is numeric ...
		if ( is.numeric( table[,c] ) == TRUE )
		{			
			# if there are entries with decimal digits ...
			if ( any( trunc( table[,c] ) != table[,c], na.rm=TRUE ) )
			{
				# trim to significant digits
				table[,c] <- signif( table[,c], digits=significantDigits );
			}
			else
			{
				# add separators between every block of 3 digits
				# PROBLEM: TableSorter doesn't sort these numbers correctly
				#table[,c] <- format( table[,c], big.mark=",", scientific=FALSE );
			}
		}
	}
	
	return ( table );
}


.writeTable <- function ( element, file )
{	
	tableNumber <- element$number;
	
	# supplementary table?
	if ( tableNumber < 0 )
	{
		tableNumber <- .concat( "S", abs( tableNumber ) );
	}
	
	.write( .tag( "div", class="table", id=.concat( "table_", tableNumber ) ), file );
	
	.write(	.tag( "div", class="caption" ), file );
	.write( .tag( "p" ), file );
	
	# "Table 1. " ...
	.write( asStrong( element$niceType, "&nbsp;", tableNumber, ".&nbsp;" ), file );
	
	if ( !is.na( element$tableFilename ) )
	{
		.write( "\n", .tag( "a", class="download", other=.concat( "href=\"", element$tableFilename, "\"" ) ), "Get Full Table", .tag( "/a" ), "\n", file );	
	}
	
	.write( element$text, file );
	.write( .tag( "/p" ), file );
	.write( .tag( "/div" ), file ); # caption
	
	# write table only if a matrix/data frame has been supplied
	if ( is.null( dim( element$table ) ) )	
	{
		.write( .tag( "table", class="resulttable tablesorter sortabletable" ), file );
		
		# --- table header ---
		
		.write( .tag( "thead" ), file );
		.write( .tag( "tr" ), file );
		
		# write column names
		for( c in 1:length( element$table ) )
		{
			.write( .tag( "th" ), file );
			.write( element$table[c], file );
			.write( .tag( "/th" ), file );
		}
		
		.write( .tag( "/tr" ), file );
		.write( .tag( "/thead" ), file );		
		
		.write( .tag( "tbody" ), file );
		.write( .tag( "tr" ), file );
		.write( .tag( "td", other=.concat( "colspan=\"", length( element$table ), "\" align=\"center\"" ) ), file );
		.write( .tag( "a", other=.concat( "href=\"", element$tableFilename, "\"" ) ), "Get Full Table", .tag( "/a" ), file );		
		.write( .tag( "/td" ), file );
		.write( .tag( "/tr" ), file );
		.write( .tag( "/tbody" ), file );
		
		.write( .tag( "/table" ), file ); # resultstable			
	}
	else
	{
		# TODO: make sure that the resulttable class is attached to these tables
		#.write( .tag( "table", id=.concat( "sortable_table_", element$number ), class="tablesorter" ), file );
		#.write( .tag( "table", id=.concat( "sortable_table_", element$number ), class="resulttable tablesorter" ), file );
		.write( .tag( "table", class="resulttable tablesorter sortabletable" ), file );
		
		# --- table header ---
		
		.write( .tag( "thead" ), file );
		.write( .tag( "tr" ), file );
		
		# write column names
		for( c in 1:dim( element$table )[2] )
		{
			.write( .tag( "th" ), file );
			.write( colnames( element$table )[c], file );
			.write( .tag( "/th" ), file );
		}
		
		.write( .tag( "/tr" ), file );
		.write( .tag( "/thead" ), file );
		
		
		# --- table body ---
		
		# copy original table and perform trimming to significant digits	
		trimmedTable <- 0;
		
		if ( is.null( ( element$tableSignificantDigits ) ) )
		{
			trimmedTable <- .trimTable( element$table, TABLE.SIGNIFICANT.DIGITS );
		}
		else
		{	
			if ( is.na( element$tableSignificantDigits ) )
			{	
				trimmedTable <- .trimTable( element$table, TABLE.SIGNIFICANT.DIGITS );
			}
			else
			{
				trimmedTable <- .trimTable( element$table, element$tableSignificantDigits );
			}
		}
		
		.write( .tag( "tbody" ), file );
		
		for( r in 1:dim( element$table )[1] )
		{
			.write( .tag( "tr" ), file );
			
			for( c in 1:dim( element$table )[2] )
			{
				.write( .tag( "td" ), file );
				
				resultIndex <- element$resultIndices[r,c];
				
				if ( !is.na( resultIndex ) )
				{
					result <- element$resultList[[resultIndex]];
					
					if ( result$isSignificant )
					{					
						if ( length( result$elements ) == 0 )
						{
							#.write( .tag( "span", class=c( "result", "significant", "noevidence" ), id=.concat( "resultid_", result$resultId, "_", result$resultNumber ) ), file );
							.write( .tag( "span", class=c( "result", "significant", "noevidence" ) ), file );
						}
						else
						{	
							.write( .tag( "span", class=c( "result", "significant" ), id=.concat( "resultid_", result$resultId ) ), file );						
						}
					}
					else
					{
						if ( length( result$elements ) == 0 )
						{
							#.write( .tag( "span", class=c( "result", "noevidence" ), id=.concat( "resultid_", result$resultId, "_", result$resultNumber ) ), file );
							.write( .tag( "span", class=c( "result", "noevidence" ) ), file );
						}
						else
						{
							.write( .tag( "span", class=c( "result" ), id=.concat( "resultid_", result$resultId ) ), file );
						}
					}
				}
				
				#.write( as.character( element$table[r,c] ), file );
				#.write( as.character( trimmedTable[r,c] ), file );
				.write( format( trimmedTable[r,c], scientific=1 ), file );
				
				if ( !is.na( resultIndex ) )
				{
					.write( .tag( "/span" ), file );
				}
				
				.write( .tag( "/td" ), file );						
			}		
			
			.write( .tag( "/tr" ), file );
		}
		
		.write( .tag( "/tbody" ), file );
		
		.write( .tag( "/table" ), file ); # resultstable	
	}
	
	.write( .tag( "/div" ), file ); # table	
	
	# write all elements, i.e. results only in this case
	.writeElements( element, file );																		
}



#' Create a citation element. 
#' @param authors Names of authors.
#' @param title Title of the document.
#' @param publication Name of the publication where the document appeared.
#' @param issue Issue of the publication.
#' @param number Number of the publication.
#' @param pages Pages of the document in the publication.
#' @param year Year when the document was published.
#' @param url URL of the document.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newCitation <- function( authors="", title, publication="", issue="", number="", pages="", year="", url="" )
{
	element <- .newElement( .ELEMENT.CITATION, niceType="Citation" );
	
	element$authors <- authors;
	element$year <- year;
	element$title <- title;
	element$publication <- publication;
	element$publicationIssue <- issue;
	element$publicationNumber <- number;
	element$pages <- pages;
	element$url <- url;	
	
	return ( element );
}


#' Create a citation element that represents a document published in a journal. This is a convenience wrapper for \code{newCitation}. 
#' @param authors Names of authors.
#' @param title Title of the document.
#' @param publication Name of the publication where the document appeared.
#' @param issue Issue of the publication.
#' @param number Number of the publication.
#' @param pages Pages of the document in the publication.
#' @param year Year when the document was published.
#' @param url URL of the document.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newJournalCitation <- function( authors, title, publication, issue, number, pages, year, url="" )
{
	return ( newCitation( authors=authors, title=title, publication=publication, issue=issue, number=number, pages=pages, year=year, url=url ) );
}


#' Create a citation element that represents a document published online. This is a convenience wrapper for \code{newCitation}. 
#' @param authors Names of authors.
#' @param title Title of the document.
#' @param url URL of the document.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newWebCitation <- function( authors, title, url )
{
	return ( newCitation( authors=authors, title=title, url=url ) );
}


.writeCitation <- function( element, file )
{
	.write( .tag( "div", class="reference", id=.concat( "reference_", element$number ) ), file );
	
	.write( "[", element$number, "] ", nobreak=TRUE, file );
	
	if ( element$authors != "" )
	{
		.write( element$authors, ", ", nobreak=TRUE, file );
	}
	
	if ( element$title != "" ) # only required field
	{
		.write( asLink( url=element$url, element$title ), nobreak=TRUE, file );
	}
	
	if ( element$publication != "" )
	{
		.write( ", ", asEmph( element$publication ), nobreak=TRUE, file );
	}
	
	if ( element$publication != "" && element$publicationIssue != "" )
	{
		.write( " ", asStrong( element$publicationIssue ), nobreak=TRUE, file );
	}
	
	if ( element$publication != "" && element$publicationIssue != "" && element$publicationNumber != "" )
	{
		.write( "(", element$publicationNumber, ")", nobreak=TRUE, file );
	}
	
	if ( element$pages != "" )
	{
		.write( ":", element$pages, nobreak=TRUE, file );
	}
	
	if ( element$year != "" )
	{
		.write( " (",element$year, ")", nobreak=TRUE, file );
	}
	
	.write( .tag( "/div" ), file ); # reference	
}


#' Create a new paragraph element.
#' @param ... Strings that will be concatenated to form the text of the paragraph. 
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newParagraph <- function( ..., exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- .newElement( .ELEMENT.PARAGRAPH, exportId=exportId, protection=protection );
	
	element$text <- list( ... );
	
	return ( element );
}


#' Create a new freeform HTML element. THIS MUST BE USED WITH EXTRAORDINARTY CARE!
#' @param ... Strings that will be concatenated to form the HTML content that will be wrapped into a \code{div} element.
#' @param style CSS to be applied to the \code{div} element.  
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newHtml <- function( ..., style=NULL, exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- .newElement( .ELEMENT.HTML, exportId=exportId, protection=protection );
	
	element$text <- list( ... );	
	element$style <- style;
	
	return ( element );
}



#' Create a new parameter list element. A parameter list is an unnumbered list of the form param_1 = value_1, ..., param_n = value_n where param_i is formated as a parameter and value_i is formatted as a value.
#' @param ... 2n strings that will be concatenated to form the parameter-value pairs. Strings at positions 1, ..., 2n - 1 will be treated as parameters 1 through n and strings at positions 2, ..., 2n will be treated as values 1 through n.
#' @param separator String to be used to separate parameters and values. Whitespace characters need to be supplied if required.    
#' @param exportId Unique string to identify this element. Used to retrieve the element using \code{getExportedElement}. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newParameterList <- function( ..., separator=" = ", exportId=NULL, protection=PROTECTION.PUBLIC )
{
	element <- newList( isNumbered=FALSE, exportId=exportId, protection=protection );
	
	args <- list( ... );
	
	# if the only argument passed is a list then use it as the list of arguments
	if ( ( length( args ) == 1 ) && ( is.list( args[[1]] ) ) )
	{
		args <- args[[1]];
	}
	
	if ( length( args ) < 2 )
	{
		stop( "At least one parameter-value pair has to be provided to parameter list." );
	}
	
	if ( length( args ) %% 2 != 0 )
	{
		stop( "Number of elements in parameter list is not multiple of 2." );
	}
	
	j <- 1;
	
	for ( i in 1:(length( args )/2) )
	{
		element <- addTo( parent=element, newParagraph( args[[j]], separator, args[[j+1]] ) );
		
		j <- j + 2;
	}
	
	return ( element );
}


.writeParagraph <- function ( element, file )
{
	.write( .tag( "p" ), file );
	.write( element$text, file );
	
	.writeElements( element, file );	
	
	.write( .tag( "/p" ), file );	
}


.writeHtml <- function ( element, file )
{
	.write( .tag( .concat( "div class=\"freeform\" style=\"", element$style,"\"" ) ), file );
	.write( element$text, file );
	
	.writeElements( element, file );	
	
	.write( .tag( "/div" ), file );	
}



#' Create a new result element.
#' @param ... One or more strings that will be concatenated to form the text associated with the result (often just a scalar or single string).
#' @param isSignificant If TRUE, the result will be declared signficant. 
#' @param protection Procection level. One of PROTECTION.PUBLIC, PROTECTION.GROUP, PROTECTION.PRIVATE.
#' @export
#' @return New element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
newResult <- function( ..., isSignificant=FALSE, protection=PROTECTION.PUBLIC )
{
	element <- .newElement( .ELEMENT.RESULT, .concat( ... ), protection=protection );
	
	element$resultId <- .getNextResultId();
	element$isSignificant <- isSignificant;
	
	return ( element );
}


.writeResult <- function ( element, file )
{
	# only write non-empty results
	if ( length( element$elements ) > 0 )
	{		
		.write( .tag( "div", class="evidence", id=.concat( "evidenceid_", element$resultId ) ), file );
		
		.writeElements( element, file );
		
		.write( .tag( "/div" ), file );		
	}	
}


.writeTopLogos <- function ( report, file )
{
	# quit if there are no logos to be added
	if ( is.na( getLogo( report, LOGO.TOP.LEFT ) ) &&
			is.na( getLogo( report, LOGO.TOP.CENTER ) ) &&
			is.na( getLogo( report, LOGO.TOP.RIGHT ) ) )
	{
		return ();
	}
	
	# write top logos
	.write( .tag( "div", class="logo" ), file );
	.write( .tag( "div", class="top" ), file );
	
	.write( .tag( "div", class="left" ), file );
	if ( !is.na( getLogo( report, LOGO.TOP.LEFT ) ) )
	{	
		.write( .tag( "img", other=.concat( "src=\"", getLogo( report, LOGO.TOP.LEFT ), "\"/" ) ), file );
	}
	.write( .tag( "/div" ), file );
	
	.write( .tag( "div", class="center" ), file );
	if ( !is.na( getLogo( report, LOGO.TOP.CENTER ) ) )
	{	
		.write( .tag( "img", other=.concat( "src=\"", getLogo( report, LOGO.TOP.CENTER ), "\"/" ) ), file );
	}
	.write( .tag( "/div" ), file );
	
	.write( .tag( "div", class="right" ), file );
	if ( !is.na( getLogo( report, LOGO.TOP.RIGHT ) ) )
	{	
		.write( .tag( "img", other=.concat( "src=\"", getLogo( report, LOGO.TOP.RIGHT ), "\"/" ) ), file );
	}
	.write( .tag( "/div" ), file );
	
	.write( .tag( "/div" ), file );	
	.write( .tag( "/div" ), file );
}


.writeBottomLogos <- function ( report, file )
{
	# quit if there are no logos to be added
	if ( is.na( getLogo( report, LOGO.BOTTOM.LEFT ) ) &&
			is.na( getLogo( report, LOGO.BOTTOM.CENTER ) ) &&
			is.na( getLogo( report, LOGO.BOTTOM.RIGHT ) ) )
	{
		return ();
	}
	
	
	# write bottom logos
	.write( .tag( "div", class="logo" ), file );
	.write( .tag( "div", class="bottom" ), file );
	
	.write( .tag( "div", class="left" ), file );
	if ( !is.na( getLogo( report, LOGO.BOTTOM.LEFT ) ) )
	{	
		.write( .tag( "img", other=.concat( "src=\"", getLogo( report, LOGO.BOTTOM.LEFT ), "\"/" ) ), file );
	}
	.write( .tag( "/div" ), file );
	
	.write( .tag( "div", class="center" ), file );
	if ( !is.na( getLogo( report, LOGO.BOTTOM.CENTER ) ) )
	{	
		.write( .tag( "img", other=.concat( "src=\"", getLogo( report, LOGO.BOTTOM.CENTER ), "\"/" ) ), file );
	}
	.write( .tag( "/div" ), file );
	
	.write( .tag( "div", class="right" ), file );
	if ( !is.na( getLogo( report, LOGO.BOTTOM.RIGHT ) ) )
	{	
		.write( .tag( "img", other=.concat( "src=\"", getLogo( report, LOGO.BOTTOM.RIGHT ), "\"/" ) ), file );
	}
	.write( .tag( "/div" ), file );
	
	.write( .tag( "/div" ), file );	
	.write( .tag( "/div" ), file );
}


#' Add child elements to a parent element.
#' @param parent Parent element.
#' @param ... One or more child elements.
#' @param row If parent element is a table row and column indices must be provided to add supplementary results to cell in the table.
#' @param column If parent element is a table row and column indices must be provided to add supplementary results to cell in the table.
#' @export
#' @return Updated parent element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
addTo <- function( parent, ..., row=NA, column=NA )
{
	args <- list( ... );
	
	if ( parent$type == .ELEMENT.TABLE )
	{
		if ( !missing( row ) && !missing( column ) )
		{			
			if ( length( args ) == 1 )
			{
				if ( args[[1]]$type == .ELEMENT.RESULT )
				{
					parent <- .addResult( table=parent, row=row, column=column, result=args[[1]] );
					
					return ( parent );
				}
			}
		}
	}
	
	
	if ( length( args ) > 0 )
	{
		for ( i in 1:length( args ) )
		{
			parent$elements[[length( parent$elements ) + 1]] <- args[[i]];	
		}	
	}
	
	return ( parent );
}


.addResult <- function( table, row, column, result )
{
	# !!! do not change the order of the following two lines!!!
	table$resultList[[length( table$resultList ) + 1]] <- result;	
	table$resultIndices[row,column] = length( table$resultList );
	
	# add result right after table
	table$elements[[length( table$elements ) + 1]] <- result;	
	
	return ( table );
}


#' Reference a citation, figure or table element.
#' @param element Citation, figure or table element. 
#' @export
#' @return A reference string for the referenced element that will be resolved when the report is written to file and rendered to HTML.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asReference <- function( element )
{
	# TODO: create link if requested
	# TODO: check for type!
	return ( paste( .REFERENCE.STRING, element$id, sep="" ) );
}


#' Include a result in text. This is a legacy method and provided only for backwards compatibility.
#' @param result The result element.
#' @export
#' @return The result element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asSummary <- function( result )
{
	return ( result );
}


#' Format text as a hyperlink.
#' @param url URL to be for the link.
#' @param ... One or more strings that will be concatenated to form the text of the link.
#' @export
#' @return A hyperlink.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asLink <- function( url, ... )
{
	# TODO: open link in new window if requested		
	
	args <- list( ... );
	
	if ( missing( url ) && length( args ) == 0 )
	{
		stop( "Unable to create link without URL or link text." );
	}	
	
	if ( url == "" || missing( url ) )
	{
		return ( .concat( args ) );	# just print text but do not create a link
	}
	
	if ( length( args ) == 0 )
	{
		args <- url; # print URL as link text
	}
	
	return ( .concat( .tag( "a", other=.concat( "href=\"", url, "\"" ) ), args, .tag( "/a" ) ) );
}


#asIdentifier <- function( label, class=NA, column=NA, row=NA )
#{
#	if ( missing( class ) && missing( label ) )
#	{
#		stop( "Unable to create identifier without class or label." );
#	}	
#	
#	if ( missing( class ) )
#	{
#		return ( label ); # just print text
#	}
#	
#	return ( .concat( "<span class=\"identifier ", class, "\">", label, "</span>" ) );
#}


#' Format text with strong emphasis (usually resulting in text set in bold).
#' @param ... One or more strings that will be concatenated.
#' @export
#' @return Text with strong emphasis.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asStrong <- function( ... )
{
	return ( .concat( .tag( "strong" ), ..., .tag( "/strong" ) ) );
}


#' Format text with emphasis (usually resulting in text set in italics).
#' @param ... One or more strings that will be concatenated.
#' @export
#' @return Text with emphasis.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asEmph <- function( ... )
{
	return ( .concat( .tag( "em" ), ..., .tag( "/em" ) ) );
}


#' Format text as parameter.
#' @param ... One or more strings that will be concatenated.
#' @export
#' @return Text formatted as a parameter.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asParameter <- function( ... )
{
	return ( .concat( .tag( "span", class="parameter" ), ..., .tag( "/span" ) ) );
}


#' Format text as value.
#' @param ... One or more strings that will be concatenated.
#' @export
#' @return Text formatted as a value.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asValue <- function( ... )
{
	return ( .concat( .tag( "span", class="value" ), ..., .tag( "/span" ) ) );
}


#' Format text as filename.
#' @param ... One or more strings that will be concatenated.
#' @export
#' @return Text formatted as a filename.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asFilename <- function( ... )
{
	return ( .concat( .tag( "span", class="filename" ), ..., .tag( "/span" ) ) );
}


#' Format text as code.
#' @param ... One or more strings that will be concatenated.
#' @export
#' @return Text formatted as a code.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
asCode <- function( ... )
{
	return ( .concat( .tag( "span", class="code" ), ..., .tag( "/span" ) ) );
}


.concat <- function( ... )
{
	if ( length( list( ... ) ) == 0 )
	{
		return ( "" );
	}
	
	return ( paste( ..., sep="" ) );
}


# helper function: writes a line of html code
.write <- function( ..., nobreak=FALSE, file )
{
	if ( missing( file ) )
	{
		args <- list( ... );
		file <- args[[length( args )]];
		args[[length( args )]] <- "";
	}  
	
	# string to be written to file
	string <- paste( args, sep="" );
	
	# if the report is supposed to be used as a fragment, all ids have to be made unique
	# scan text for this pattern "< ...id="xyz" ...>"  
	# replace with "< ...id="xyz_REPORTID" ...>"
	# sed s/"\(<.*\)id=\"\([A-Za-z][A-Za-z0-9_\.-\:]*\)\"\(.*>\)"/\\1id=\\2_TEXT\\3/g demo.html      
	if ( .getGlobalReportId() != "" )
	{
		string <- gsub( "(<.*)id=\"([A-Za-z][A-Za-z0-9_\\.-\\:]*)\"(.*>)", .concat( "\\1id=\"\\2_", .getGlobalReportId(), "\"\\3" ), string );  
	}	 
	
	if ( nobreak )
	{  
		cat( string, file=file, sep="" );
	}
	else
	{
		cat( string, "\n", file=file, sep="" );
	}
}


.tag <- function( tag, id=NA, class=NA, other=NA )
{
	idString <- "";
	classString <- "";
	otherString <- "";
	
	if ( !missing( id ) )
	{
		idString <- .concat( " id=\"", id, "\"" );	
	}
	
	if ( !missing( class ) )
	{
		classString <- .concat( " class=\"", paste( class, sep=" ", collapse=" " ), "\"" );	
	}
	
	if ( !missing( other ) )
	{
		otherString <- .concat( " ", other );
	}
	
	return ( .concat( "<", tag, classString, idString, otherString, ">" ) );
}

.comment <- function( ... )
{
	return ( .concat( "<!-- ", ..., " -->" ) );
}



.writeElement <- function( element, file )
{
	if ( element$type == .ELEMENT.PARAGRAPH )
	{
		.writeParagraph( element, file );
	}
	
	if ( element$type == .ELEMENT.HTML )
	{
		.writeHtml( element, file );
	}
	
	if ( element$type == .ELEMENT.SECTION )
	{
		.writeSection( element, file, "" );
	}
	
	if ( element$type == .ELEMENT.SUBSECTION )
	{
		.writeSection( element, file, "sub" );
	}
	
	if ( element$type == .ELEMENT.SUBSUBSECTION )
	{
		.writeSection( element, file, "subsub" );
	}
	
	if ( element$type == .ELEMENT.LIST )
	{
		.writeList( element, file );
	}
	
	if ( element$type == .ELEMENT.FIGURE )
	{
		.writeFigure( element, file );
	}
	
	if ( element$type == .ELEMENT.TABLE )
	{
		.writeTable( element, file );
	}
	
	if ( element$type == .ELEMENT.CITATION )
	{
		.writeCitation( element, file );
	}
	
	if ( element$type == .ELEMENT.RESULT )
	{
		.writeResult( element, file );
	}
}


.writeElements <- function( element, file )
{
	if ( length( element$elements ) > 0 )
	{	
		for ( i in 1:length( element$elements ) )
		{
			.writeElement( element$elements[[i]], file );
		}
	}
}





#' Get the first element of the "Summary" subsection in the "Overview" section in a standard report.
#' @param report The report.
#' @export
#' @return A report element.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getSummary <- function( report )
{
	.initNumbers();
	
	return ( .updateReferences( .updateNumberedElements( .getElementById( report, report$predefined$summaryId ) ), report=report )$elements ); 	
}


#' Get the total number of significant results in \code{report}.
#' @param report The report. 
#' @export
#' @return Number of signficiant results.
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
getSignificantResultsCount <- function( report )
{
	return ( .countSignificantResults( report ) );
}


#' Write \code{report} to file.
#' @param report The report to be written.
#' @param filename Name of the output file without file extension.
#' @param debug If TRUE, external CSS (\code{debugCss}) and JavaScript (\code{debugJavaScript}) can be supplied. 
#' @param output A list of output formats. Any combination of HTML.REPORT and RDATA.REPORT is allowed. 
#' @param credits If TRUE, a note and a link will be included at the bottom of the report to indicate that it was created with Nozzle.   
#' @param level The protection level of the report. If set to PROTECTION.PUBLIC only elements with protection level PROTECTION.PUBLIC (default) will be included in the report. If set to PROTECTION.GROUP, then all elements with protection level PROTECTION.PUBLIC and PROTECTION.GROUP will be included. If set to PROTECTION.PRIVATE all elements will be included.  
#' @param debugCss A path or URL to a CSS file that should be used instead of the built-in CSS. Only used if \code{debug} is TRUE. 
#' @param debugJavaScript A path or URL to a JavaScript file that should be used instead of the built-in JavaScript. Only used if \code{debug} is TRUE.
#' @export 
#' 
#' @author Nils Gehlenborg \email{nils@@hms.harvard.edu}
writeReport <- function( report, filename=DEFAULT.REPORT.FILENAME, debug=FALSE, output=c( HTML.REPORT, RDATA.REPORT ), credits=TRUE, level=PROTECTION.PUBLIC, debugCss=NA, debugJavaScript=NA )
{	
	# check if input and references contain any reports, if not, remove those sections		
	
	if ( is.list( report$predefined ) && ( "referencesId" %in% names( report$predefined ) ) )
	{	
		references <- .getElementById( report, report$predefined$referencesId );	
		
		if ( !is.null( references ) )
		{		
			# remove reference section
			report <- .removeElementById( report, references$id );
			
			if ( length( references$elements ) > 0 )
			{
				# there are some references, insert them at the end of the methods section
				report <- addToMethods( report, references );
			}					
		}
	}
	
	if ( is.list( report$predefined ) && ( "inputId" %in% names( report$predefined ) ) )	{	
		input <- .getElementById( report, report$predefined$inputId );
		
		if ( !is.null( input ) )
		{
			if ( length( input$elements ) == 0 )
			{
				# no input, remove the empty section
				report <- .removeElementById( report, input$id );
			}
		}
	}
	
	if ( is.list( report$predefined ) && ( "metaId" %in% names( report$predefined ) ) )
	{	
		meta <- .getElementById( report, report$predefined$metaId );
		
		if ( !is.null( meta ) )
		{
			if ( length( meta$elements ) == 0 )
			{
				# no meta information, remove the empty section
				report <- .removeElementById( report, meta$id );
			}
		}
	}	
	
	# --- additional meta information --- #
	
	# assign report id
	report$reportId <- .newReportId();
	
	# assign date of report writing (if doesn't exist yet)
	if ( is.null( report$meta$createDate ) )
	{
		report$meta$createDate <- date();
	}	
	
	# write as requested output types	
	if ( RDATA.REPORT %in% output )
	{		
		save( report, file=.concat( filename, ".RData" ) );		
	}
	
	if ( HTML.REPORT %in% output )
	{
		.writeGeneralReport( report, .concat( filename, ".html" ), debug, HTML.REPORT, FALSE, credits=credits, level=level, debugCss=debugCss, debugJavaScript=debugJavaScript );		
	}
	
	if ( HTML.FRAGMENT %in% output )
	{
		warning( "HTML fragments are no longer supported in Nozzle version 0.3.0 or later." );
		#.writeGeneralReport( report, .concat( filename, ".html" ), debug, HTML.FRAGMENT, FALSE, level=level, debugCss=debugCss, debugJavaScript=debugJavaScript );
	}	
}


.writeGeneralReport <- function( report, filename, debug=FALSE, output=HTML.REPORT, append=FALSE, credits=TRUE, level=PROTECTION.PUBLIC, debugCss=NA, debugJavaScript=NA )
{
	# initialize counters for all numbered objects (figures, tables, references, etc.)
	.initNumbers();
	
	report <- .removeProtectedElements( report, level );
	
	# extract result elements (e.g. from paragraphs) and insert into the report tree
	report <- .updateResults( report, report=report )$element; # if there are results directly in the report they will be ignored
	report <- .updateNumberedElements( report );
	report <- .updateReferences( report, report=report );
	
	file <- NA;
	
	if ( append )
	{
		file <- file( filename, "a" );
	}
	else
	{
		file <- file( filename, "w" );
	}
	
	# write file header if in debug mode or if writing standalone report
	if ( output == HTML.REPORT )
	{
		.write( "<!DOCTYPE html>", file );
		
		.write( .tag( "html" ), file );
		
		.write( .tag( "head" ), file );
		
		# write report title
		.write( .tag( "title" ), file );
		.write( report$title, file );
		if ( "subTitle" %in% names( report ) && !is.null( report$subTitle ) && !is.na( report$subTitle ) ) 
		{
			.write( " - ", report$subTitle, file );		
		}							
		.write( .tag( "/title" ), file );					
		
		# embedded Google Analytics JavaScript if a Google Analytics id has been provided (should be last before </head>)(
		if ( !is.na( getGoogleAnalyticsId( report ) ) )
		{
			.write( "<script type=\"text/javascript\">", file );
			.write( paste( gsub( .NOZZLE.GOOGLEANALYTICS.VARIABLE, getGoogleAnalyticsId( report ), get( "googleAnalyticsCode", envir=.nozzleEnv ) ), collapse="\n" ), file );
			.write( "</script>", file );	
		}		
		
		.write( .tag( "/head" ), file );
		
		.write( .tag( "body" ), file );
		
		# insert mask to make report loading appear more gracefully
		# the mask covers the view and hides possible ugly artefacts that might appear during loading before
		# all divs have been resized to their correct size
		.write( "<div style=\"display: none\" id=\"mask\">&nbsp;</div>", file );
		.write( "<script type=\"text/javascript\">", file );		
		.write( "document.getElementById(\"mask\").style.display = \"block\";", file );
		.write( "</script>", file );			
	}	
	
	.write( .tag( "div", class="report", id=report$reportId ), file );
	
	.write( .comment( "Nozzle Report Id = ", report$reportId ), file );
	.write( .comment( "Nozzle Report Version = ", report$meta$version ), file );
	
	.write( .comment( "Nozzle Report Create Package = ", getCreatorName( report ) ), file );
	.write( .comment( "Nozzle Report Create Date = ", getCreatorDate( report ) ), file );
	
	report$meta$renderer$name <- .getPackageVersion();
	report$meta$renderer$date <- date();
	
	.write( .comment( "Nozzle Report Render Package = ", getRendererName( report ) ), file );
	.write( .comment( "Nozzle Report Render Date = ", getRendererDate( report ) ), file );
	
	# add further meta information
	report$meta$reportTitle <- report$title;
	report$meta$reportId <- report$reportId;
	
	
	# insert Nozzle CSS
	if ( debug )
	{
		if ( is.na( debugCss ) )
		{
			.write( .tag( "style media=\"screen\"" ), file );	
			.write( paste( get( "cssCode", envir=.nozzleEnv ), collapse="\n" ), file );
			.write( .tag( "/style" ), file );
			
			.write( .tag( "style media=\"print\"" ), file );	
			.write( paste( get( "cssPrintCode", envir=.nozzleEnv ), collapse="\n" ), file );
			.write( .tag( "/style" ), file );
		}
		else
		{
			.write( "<link type=\"text/css\" rel=\"stylesheet\" href=\"", debugCss, "\">", file );
		}
	}
	else
	{
		.write( .tag( "style media=\"screen\"" ), file );	
		.write( paste( get( "cssMinCode", envir=.nozzleEnv ), collapse="\n" ), file );	
		.write( .tag( "/style" ), file );
		
		.write( .tag( "style media=\"print\"" ), file );	
		.write( paste( get( "cssPrintMinCode", envir=.nozzleEnv ), collapse="\n" ), file );
		.write( .tag( "/style" ), file );		
	}
	
	if ( !is.na( getCustomScreenCss( report ) ) )
	{
		.write( "<link type=\"text/css\" rel=\"stylesheet\" media=\"screen\" href=\"", getCustomScreenCss( report ), "\">", file );
	}
	
	if ( !is.na( getCustomPrintCss( report ) ) )
	{
		.write( "<link type=\"text/css\" rel=\"stylesheet\" media=\"print\" href=\"", getCustomPrintCss( report ), "\">", file );
	}	
	
	# embedded jQuery JavaScript (only in standalone)
	if ( output == HTML.REPORT )
	{
		#.write( "<script type=\"text/javascript\" src=\"https://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js\"></script>", file );
		.write( "<script type=\"text/javascript\">", file );
		.write( paste( get( "jQueryMinCode", envir=.nozzleEnv ), collapse="\n" ), file );	
		.write( "</script>", file );	
	}
	
	# embedded TableSorter JavaScript
	.write( "<script type=\"text/javascript\">", file );
	if ( debug )
	{
		.write( paste( get( "jQueryTableSorterMinCode", envir=.nozzleEnv ), collapse="\n" ), file );
	}
	else
	{
		.write( paste( get( "jQueryTableSorterMinCode", envir=.nozzleEnv ), collapse="\n" ), file );	
	}
	.write( "</script>", file );	
	
	
	# embedded Nozzle JavaScript
	if ( debug )
	{
		if ( is.na( debugJavaScript ) )
		{
			.write( "<script type=\"text/javascript\">", file );
			.write( paste( get( "javaScriptCode", envir=.nozzleEnv ), collapse="\n" ), file );
			.write( "</script>", file );	
		}
		else
		{
			.write( "<script type=\"text/javascript\" src=\"", debugJavaScript ,"\"></script>", file );			
		}
	}
	else
	{
		.write( "<script type=\"text/javascript\">", file );
		.write( paste( get( "javaScriptMinCode", envir=.nozzleEnv ), collapse="\n" ), file );	
		.write( "</script>", file );	
	}
	
	
	if ( ( output == HTML.REPORT ) || ( append == TRUE ) )
	{
		.write( "<script type=\"text/javascript\">$(document).ready( function() { initNozzle( \"", report$reportId, "\", $ ); });</script>", file );
	}
	else
	{
		# warning!
	}
	
	
	# === REPORT META BEGIN ===	
	
	.write( "<script type=\"text/javascript\">", file );
	.writeJsonElement( "nozzleMeta", report$meta, file );
	.writeJsonElement( "nozzleNavigation", report$navigation, file );
	.write( "</script>", file );	
	
	# === REPORT META END ===	
	
	
	# === REPORT CONTENT BEGIN ====
	
	.write( .tag( "div", class="frame" ), file );	
	.write( .tag( "div", class="main" ), file );
	
	# set global report id if this is being written as a fragment
	# if set to anything else but "", .write will attach this to all ids in HTML tags
	.setGlobalReportId( report$reportId );

	# write top logos
	.writeTopLogos( report, file );
	
	# write title
	.write( .tag( "div", class="title" ), report$title, .tag( "/div" ), file );
	
	if ( !is.null( report$subTitle ) && !is.na( report$subTitle ) ) 
	{
		.write( .tag( "div", class="subtitle" ), report$subTitle, .tag( "/div" ), file );
	}	
	
	# write maintainer info
	.writeMaintainerInformation( report, file );
	
	# write DOI info
	.writeDoiCitationInformation( report, file );			
	
	
	# write content	
	if ( length( report$elements ) > 0 )
	{	
		for ( i in 1:length( report$elements ) )
		{
			.writeElement( report$elements[[i]], file );		
		}
	}
	
	# write copyright info
	if ( !is.na( getCopyrightOwner( report ) ) )
	{
		.write( .tag( "div", class="copyright" ), file );
		.write( .tag( "span", class="notice" ), file );
		
		.write( "Copyright &copy; ", getCopyrightYear( report ), file );
		
		.write( .tag( "span", class="owner" ), file );
		if ( !is.na( getCopyrightUrl( report ) ) )
		{
			.write( asLink( getCopyrightOwner( report ), url=getCopyrightUrl( report ) ), ".", file );
		}
		else
		{
			.write( getCopyrightOwner( report ), ".", file );
		}
		.write( .tag( "/span" ), file );
		
		if ( !is.na( getCopyrightStatement( report ) ) )
		{
			.write( getCopyrightStatement( report ), file );
		}
		
		.write( .tag( "/span" ), file );		
		.write( .tag( "/div" ), file );		
	}
		
	# write bottom logos
	.writeBottomLogos( report, file );	
	
	
	# write credits (something like "MADE WITH NOZZLE")
	if ( credits )
	{
		.write( .tag( "div", class="credits" ), file );
		.write( .tag( "span", class="notice" ), file );
		
		.write( asLink( .NOZZLE.CREDITS, url=.NOZZLE.URL ), file );
		
		.write( .tag( "/span" ), file );		
		.write( .tag( "/div" ), file );		
	}
	
	
	.write( .tag( "/div" ), file ); # main
	.write( .tag( "/div" ), file ); # frame				
	.write( .tag( "/div" ), file ); # report
	
	# === REPORT CONTENT END ====
	
	
	# write file footer if in debug mode or standalone report
	if ( output == HTML.REPORT )
	{	
		.write( .tag( "/body" ), file );
		
		.write( .tag( "/html" ), file );	
	}
	
	
	# reset global report id if this is being written as a fragment to avoid conflicts with other reports
	.setGlobalReportId( "" );
	
	close( file );
}


# writes a meta entry into the header into file unless the value is NA with write.na == FALSE
.writeMetaInformation <- function( attribute, value, file, write.na=FALSE )
{
	if ( !is.na( value ) || write.na )
	{
		.write( .tag( "meta", other=.concat( "attr=\"", attribute, "\" value=\"", value, "\"" ) ), file );
		.write( .tag( "/meta" ), file );
	}
}


.writeMaintainerInformation <- function( report, file, cssClass="maintainer" )
{
	# write maintainer information	
	if ( !is.na( getMaintainerName( report ) ) )
	{
		.write( .tag( "div", class=cssClass ), file );
		
		if ( !is.na( getMaintainerEmail( report ) ) )
		{
			.write( "<i>Maintained by</i> ", .tag( "span", class="name" ), asLink( url=.concat( "mailto:", getMaintainerEmail( report ) ), getMaintainerName( report ) ), .tag( "/span" ), file );
		}
		else
		{
			.write( "<i>Maintained by</i> ", .tag( "span", class="name" ), getMaintainerName( report ), .tag( "/span" ), file );
		}
		
		if ( !is.na( getMaintainerAffiliation( report ) ) )
		{
			.write( " (", .tag( "span", class="affiliation" ), getMaintainerAffiliation( report ), .tag( "/span" ), ")", file );
		}
		
		.write( .tag( "/div" ), file );
	}
}


.writeDoiCitationInformation <- function( report, file, cssClass="citation" )
{
	# write DOI and citation info
	if ( !is.na( getDoi( report ) ) )
	{
		.write( .tag( "div", class=cssClass ), file );
		
		doiResolver <- getDoiResolver( report );
		if ( is.na( doiResolver ) )
		{
			doiResolver <- DEFAULT.DOI.RESOLVER;
		}
		
		.write( "<i>Cite as</i> ", file );
		
		if ( !is.na( getDoiCreator( report ) ) )
		{
			.write( .concat( getDoiCreator( report ), "" ), file );			
		}
		
		if ( !is.na( getDoiYear( report ) ) )
		{
			.write( .concat( " (", getDoiYear( report ), "): " ), file );			
		}
		
		if ( !is.na( getDoiTitle( report ) ) )
		{
			.write( .concat( "", getDoiTitle( report ), ". " ), file );			
		}
		
		if ( !is.na( getDoiVersion( report ) ) )
		{
			.write( .concat( getDoiVersion( report ), ". " ), file );			
		}		
		
		if ( !is.na( getDoiPublisher( report ) ) )
		{
			.write( .concat( getDoiPublisher( report ), ". " ), file );			
		}
		
		.write( asLink( url=.concat( doiResolver, "/", getDoi( report ) ), .concat( "doi:", getDoi( report ) ) ), file )
				
		.write( .tag( "/div" ), file );		
	}
}


#===================================================================================================
# functions to write R lists a JSON objects
#===================================================================================================

.writeJsonElement <- function( jsVariable, element, file )
{
	.write( "var ", jsVariable, " = {", file );
	
	.writeJsonList( NA, element, file, indent=3 );
	
	.write( "};", file );		
}


.writeJsonNumeric <- function( name, value, file, indent=0 )
{
	if ( length( value ) == 1 )
	{
		.write( .createIndent( indent ), "\"", name, "\": ", value, file, nobreak=T );
	}
	else
	{
		.write( .createIndent( indent ), "\"", name, "\": [", paste( value, collapse=", " ), "]", file, nobreak=T );	
	}
}


.writeJsonCharacter <- function( name, value, file, indent=0 )
{
	if ( length( value ) == 1 )
	{
		.write( .createIndent( indent ), "\"", name, "\": ", "\"", value, "\"", file, nobreak=T );
	}
	else
	{
		.write( .createIndent( indent ), "\"", name, "\": [", paste( paste( "\"", value, "\"", sep="" ), collapse=", " ), "]", file, nobreak=T );	
	}
}


.writeJsonNull <- function( name, file, indent=0 )
{
	.write( .createIndent( indent ), "\"", name, "\": ", "null", file, nobreak=T );
}


.writeJsonList <- function( name, element, file, indent=0 )
{
	if ( !is.na( name ) )
	{
		.write( .createIndent( indent ), "\"", name, "\": {", file );
	}
	
	# get names	
	listNames <- names( element );
	
	# iterate over names and write out values
	if ( length( listNames ) > 0 )
	{	
		for ( i in 1:length( listNames ) )
		{
			value <- element[[listNames[i]]];
			
			if ( is.list( value ) )
			{
				.writeJsonList( listNames[i], value, file, indent=indent+3 ); 
			}
			else if ( is.na( value ) )
			{
				.writeJsonNull( listNames[i], file, indent=indent+3 ); 
			}
			else if ( is.numeric( value ) )
			{
				.writeJsonNumeric( listNames[i], value, file, indent=indent+3 );
			}
			else		
			{
				.writeJsonCharacter( listNames[i], value, file, indent=indent+3 );		
			}
			
			if ( i < length( listNames ) )
			{
				.write( ",", file );
			}
			else
			{
				.write( "\n", file, nobreak=T );
			}
		}
	}
	
	# closing braces
	if ( !is.na( name ) )
	{
		.write( .createIndent( indent ), "}", file, nobreak=T );
	}
}

.createIndent <- function( indent, character=" " )
{
	return( paste( rep( character, indent ), collapse="" ) );
}
