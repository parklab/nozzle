# Nozzle

Nozzle is an [R package](http://www.r-project.org) that provides an API to generate HTML reports with dynamic user interface elements based on JavaScript and CSS (Cascading Style Sheets). Nozzle was designed to facilitate summarization and rapid browsing of complex results in data analysis pipelines where multiple analyses are performed frequently on big data sets. The package can be applied to any project where user-friendly reports need to be created.

### About the Name

The "R1" in the "Nozzle.R1" package name stands for "revision 1" of the Nozzle R API. All versions of the Nozzle.R1 package will be backwards-compatible and able to render reports generated with earlier versions of the package. When backwards-compatibility of the API can no longer maintained the package name will change to "Nozzle.R2".

# Obtaining and Installing the R package

The package can be downloaded from the main Nozzle site at the [Broad Institute](http://gdac.broadinstitute.org/nozzle). The package has no external dependencies and can be installed by calling the following from the command line:

	R CMD install Nozzle.R1


# Creating a Basic Report

The following code creates a report with one section and two subsections. The first subsection contains a table and the second subsection contains a paragraph of text:

	require( Nozzle.R1 )
	
	# Phase 1: create report elements
	r <- newCustomReport( "My Report" );
	s <- newSection( "My Section" );
	ss1 <- newSection( "My Subsection 1" );
	ss2 <- newSection( "My Subsection 2" );
	f <- newTable( iris[45:55,], "Iris data." ); # w/ caption
	p <- newParagraph( "Some sample text." );
	
	# Phase 2: assemble report structure bottom-up
	ss1 <- addTo( ss1, f ); # parent, child_1, ..., child_n 
	ss2 <- addTo( ss2, p );
	s <- addTo( s, ss1, ss2 );
	r <- addTo( r, s );
	
	# Phase 3: render report to file
	writeReport( r, filename="my_report" ); # w/o extension

Two files called `my_report.html` and `my_report.RData` will be written to the current working directory.

# Building the R package

Nozzle works with R 2.10 or later. Use standard R commands to build the package in the cloned repo directory:

	R CMD check Nozzle.R1
	R CMD build Nozzle.R1


## Updating Documentation

The Nozzle API is documented using the [`roxygen2` R package](http://cran.r-project.org/web/packages/roxygen2/index.html). To rebuild the Rd files in the `man` directory run the following from the R shell (using the cloned repo directory as the working directory):

	library(methods);
	library(utils);
	library(roxygen2);
	roxygenize("Nozzle.R1", copy=FALSE);


## Minifying Files

The JavaScript and CSS code should be compressed before they can be embedded in the HTML report. If you make changes to any file in the `inst` directory you need to download the [YUI compressor] (http://yui.github.com/yuicompressor) and run the following from the command line:

	java -jar Tools/yuicompressor-2.4.2.jar -o Nozzle.R1/inst/js/nozzle.min.js 	Nozzle.R1/inst/js/nozzle.js
	java -jar Tools/yuicompressor-2.4.2.jar -o Nozzle.R1/inst/css/nozzle.print.min.css Nozzle.R1/inst/css/nozzle.print.css
	java -jar Tools/yuicompressor-2.4.2.jar -o Nozzle.R1/inst/css/nozzle.min.css Nozzle.R1/inst/css/nozzle.css


# Author

[Nils Gehlenborg](http://www.gehlenborg.com) ([nils@hms.harvard.edu] (mailto:nils@hms.harvard.edu))