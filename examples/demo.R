# A comprehensive overview of the Nozzle API.
# 
# Author: Nils Gehlenborg (nils@hms.harvard.edu)
###############################################################################

require( "Nozzle.R1" );

#===================================================================================================
# Report 1
# A report that showcases all elements that can be included in a Nozzle report.
#===================================================================================================

report1 <- newReport( "Nozzle Demo Report 1" );


# --- Data ---

# create some plots and write them to files
# ...

#

figureFile <- "figures/image1.jpg";
figureFileHighRes <- "figures/image1_highres.jpg";

tableDataFile <- "files/table_file.txt";
tableData <- read.table( tableDataFile, sep="\t", skip=1, nrows=10, header=TRUE );
tableData[,2] <- as.numeric( tableData[,2] );

gisticDataFile <- "files/scores_.conf_level.99.gistic.txt";
gisticData <- read.table( gisticDataFile, sep="\t", nrows=100, header=TRUE );


# --- References ---

# create some references (even though they are included at the end of the report the need to be created
# first so they can be referenced in other elements)
simpleCitation <- newCitation( authors="Nils Gehlenborg", title="Nozzle.R1 Package", year="2013", url="https://github.com/parklab/Nozzle" );
webCitation <- newCitation( title="The Cancer Genome Atlas Website", url="http://tcga.cancer.gov/" );
fullCitation <- newCitation( authors="Nils Gehlenborg", title="Nozzle: a report generation toolkit for data analysis pipelines", publication="Yet Another Bioinformatics Journal", issue="1", number="2", pages="3-4", year="2013", url="http://www.google.com" );

report1 <- addToReferences( report1, simpleCitation, webCitation, fullCitation );


# --- Overview ---

report1 <- addToIntroduction( report1,
				newParagraph( "Nozzle is an R Package to generate reports for high-throughput data analysis pipelines based on\
					HTML, CSS and JavaScript. However, ", asEmph( "to use " ), "Nozzle, no knowledge of\
					these technologies is required." ) ); 

report1 <- addToSummary( report1,
				newParagraph( "A simple API that enables developers to design efficient reports quickly." ) );


# --- Results ---

# create a figure and make it available for exporting
figure1 <- newFigure( figureFile, fileHighRes=figureFileHighRes, exportId="FIGURE_1",
				"An example for a figure. Everything that is shown in the figure should be explained\
				in the caption. The figure needs to have axis labels and a legend." );

figure2 <- newFigure( figureFile,
				"An example for a figure without a link to a high-res file." );
				
# create a table and make it available for exporting				
table1 <- newTable( tableData, file=tableDataFile, significantDigits=0,	exportId="TABLE_1", 			
				"A small table. All ", asParameter( "parameters" ), " shown in the columns\
				of the table need to be explained in the caption." );

mySignificantDigits <- 4;
table3 <- newTable( tableData, significantDigits=mySignificantDigits,
				"A small table without a link to a file. The values in this table have been trimmed to ", mySignificantDigits, " significant digits." );

# to get an empty table with a link to the full table file just pass the colum names
table4 <- newTable( colnames( tableData ), file=tableDataFile,
				"A small table without content but a link to the full table." );
						
table5 <- newTable( gisticData, significantDigits=mySignificantDigits, file=gisticDataFile,
				"A long table (GISTIC 2 output). The values in this table have been trimmed to ", mySignificantDigits, " significant digits." );


paragraph1 <- newParagraph( "Nozzle supports a range of different formatting styles: ",
				asStrong( "strong" ), "; ", 
				asEmph( "emph" ), "; ",
				asParameter( "parameter" ), " = ",
				asValue( "value" ), "; ",
				asFilename( "filename" ), "; ",
				asCode( "code" ), "; ", exportId="LIST_FORMAT" );
				
list <- newList( newParagraph( "Nozzle also provides lists." ),
				newParagraph( "They can even be nested." ),
				newList( isNumbered=TRUE, newParagraph( "They may contain other lists." ),
					newParagraph( "Or selected other elements." ),
					newParagraph( "Numbered." )  ),
				newParagraph( "Or unnumbered." )  );				
			
paragraph2 <- newParagraph( "The Nozzle package ", asReference( simpleCitation ), " also supports referencing of figures, tables and\
					references ", asReference( webCitation ), asReference( fullCitation ), " that are part of the report. For instance, developers can\
					refer to a figure, such as ", asReference( figure1 ), ", or to a table, such\
					as ", asReference( table1 ), "." );					
					
paragraphPublic <- newParagraph( "Nozzle reports may also contain results with different levels\
					of protection. For instance, this paragraph is labeled ",
					asLink( "\'PUBLIC\'", url="nozzle1_public.html" ), " and will be\
					included in all reports. However, the next paragraph is labeled ",
					asLink( "\'GROUP\'", url="nozzle1_group.html" ), " and will\
					only be included in reports for members of the research group. The paragraph after \
					the next is even more restricted and labeled ",
					asLink( "\'PRIVATE\'", url="nozzle1_private.html" ), ", which means that it\
					will only show up in internal reports. ", asStrong( "Please note that if you\
					are viewing the public version or the group version of the report you might not\
					see any paragraphs or only one paragraph after this one." ), protection=PROTECTION.PUBLIC );

paragraphGroup <- newParagraph( "This paragraph is protected and will only be included in reports\
					for members of the research group.", protection=PROTECTION.GROUP );

paragraphPrivate <- newParagraph( "This is a private paragraph. Hardly anyone gets to see this.",
					protection=PROTECTION.PRIVATE );
					
result1 <- newResult( asParameter( "A" ), " = ", asValue( "1" ), isSignificant=TRUE );
result1 <- addTo( result1,
		  	 addTo( newSection( "My Significant Result" ),
				addTo( newSubSection( "My Significant Subresult" ),
					addTo( newSubSubSection( "My Signficant SubSubresult" ),
						newParagraph( "This is a paragraph related to the significant result of A = 1.\
							Results may contain all sorts of section, figures, tables, list and so on.\
							But no further results/supplementary information." )
					)
				),
				newFigure( "figures/image2.jpg", fileHighRes="figures/image2_highres.jpg",
					"Symmetry. By Kokorono: ", asLink( url="http://www.flickr.com/photos/kokorono/5422006034" ) )
			 )
		 );

result2 <- newResult( asParameter( "B" ), " = ", asValue( "1234" ), isSignificant=round( runif(1) ) );
result2 <- addTo( result2,
		  	 addTo( newSection( "My Rocking Result" ),			
				newParagraph( "This is a paragraph related to the rocking result of A = 53030.\
					Results may contain all sorts of section, figures, tables, list and so on.\
					But no more results, please!" ),
				newFigure( "figures/image1.jpg", fileHighRes="figures/image1_highres.jpg",
					"Anothr pictur from Flickr." ),
				table5					
			 )
		 );
		 
result3 <- newResult( asParameter( "C" ), " = ", asValue( "Oh no!" ), isSignificant=FALSE );
					
paragraph3 <- newParagraph( "A particularly fun aspect of Nozzle is how it handles results and\
					summaries of results. For instance, we have found that ", asSummary( result1 ),
					", which is totally an amazing result. It is ", if ( result1$isSignificant )  { "totally" } else { "not" }, " significant." );
					
list2 <- newList( newParagraph( "This is another list." ),
				newParagraph( "It contains a result: ", asSummary( result2 ) ),
				newParagraph( "And an empty result: ", asSummary( result3 ) ),
				newParagraph( "That's nice!" )  );				

table2 <- newTable( tableData, file=tableDataFile,				
				"Another small table. This table has result summaries associated with it. All ",
				asParameter( "parameters" ), " shown in the columns of the table need to be explained in the caption." );

for ( i in 1:dim( tableData )[1] )
{
	if ( i %% 2 == 0 )
	{	
		result1 <- addTo( newResult( "", isSignificant=( tableData[i,4] < 0.0001 ) ),
			addTo( newSection( "Result ", i ), newParagraph( "This is a paragraph related to ", tableData[i,1], "." ) ) );
	}
	else
	{
		result1 <- newResult( "", isSignificant=( tableData[i,4] < 0.0001 ) );
	}
	table2 <- addTo( table2, result1, row=i, column=4 );
}

report1 <- addToResults( report1,
				addTo( newSubSection( "Nozzle Figure" ), figure1, figure2 ),
				addTo( newSubSection( "Nozzle Table" ), table1, table4, table3, table5 ), 
				addTo( newSubSection( "Nozzle Text" ), paragraph1, list, paragraph2, paragraphPublic,
							paragraphGroup, paragraphPrivate ),
				addTo( newSubSection( "Nozzle Results" ), addTo( newSubSubSection( "Subsubsection!" ),
				newParagraph( "Text in a subsubsection! But the next paragraph belongs to the \"Nozzle Results\" subsection." ) ), paragraph3, list2, table2 ) ); 


result4 <- newResult( asParameter( "D" ), " = ", asValue( "E" ), isSignificant=TRUE );
result4 <- addTo( result4, newParagraph( "This is some result stuff!" ) );

report1 <- addToMeta( report1,
				addTo( newSubSection( "Nozzle Figure" ), figure1, figure2 ),
				addTo( newSubSection( "Nozzle Table" ), table1, table4, table3, table5 ), 
				addTo( newSubSection( "Nozzle Text" ), paragraph1, list, paragraph2, paragraphPublic,
							paragraphGroup, paragraphPrivate ),
				addTo( addTo( newSubSection( "Nozzle Results" ), newParagraph( "A result: ", asSummary( result4 ), ", yay!" ) ) ) ); 

				
# --- Methods ---

method1 <- addTo( newSubSection( "Really Cool Method", exportId="METHOD_COOL" ),
				newParagraph( "A typical method description consists of one or two paragraphs of\
					text describing the method, followed by a list of method parameters and their\
					values for the present run." ),
				newParameterList( asParameter( "param alpha" ), asValue( "Bet" ),
					asParameter( "param beta" ), asValue( "Carotene" ),
					asParameter( "param gamma" ), asValue( "rays" )) );

method2 <- addTo( newSubSection( "Pretty Fast Method" ), 
				newParagraph( "A typical method description consists of one or two paragraphs of\
					text describing the method, followed by a list of method parameters and their\
					values for the present run." ),
				newParameterList( asParameter( "n" ), asValue( "x" ),
					asParameter( "Q" ), asValue( "1034" ),
					asParameter( "T" ), asValue( "4.4" )) );

report1 <- addToMethods( report1, method1, method2 );

report1 <- addToInput( report1, 
				newParagraph( "This section should list the files that were used as input." ),
				newParameterList( asParameter( "methylation file" ),
					asFilename( "/path/to/this/great/file" ),
					asParameter( "gene expression file" ),
					asFilename( "/path/to/gene/expression/file" ) ) );				


# link this report to other reports that will be accessible through the forward/backward buttons in the menu
report1 <- setNextReport( report1, "nozzle2.html", "Demo 2" );
report1 <- setPreviousReport( report1, "nozzle4.html", "Demo 4" );

# set report maintainer information
report1 <- setMaintainerName( report1, "Nils Gehlenborg" );
report1 <- setMaintainerEmail( report1, "nils@hms.harvard.edu" );
report1 <- setMaintainerAffiliation( report1, "Harvard Medical School" );

# set the copyright notice for this report
report1 <- setCopyright( report1, owner="Nils Gehlenborg", year=2013, statement="All rights reserved.", url="http://www.github.com/parklab/Nozzle" ); 

# set a Google Analytics id (need to be set up correctly for the server from which the report will be served)
report1 <- setGoogleAnalyticsId( report1, "UA-27373989-1" );

# set contact information for error reports
report1 <- setContactInformation( report1, email="nils@hms.harvard.edu", subject="Problem with Nozzle Demo Report", message="Hello!\n\nThis is a default message.\nReplace this with instructions for readers.", label="Report a Problem" );

# set name and version of the software that created the report
report1 <- setSoftwareName( report1, "Nozzle Demo Script" );
report1 <- setSoftwareVersion( report1, "Version ", date() );

# create meta info section with information from the report
report1 <- addToMeta( report1,
				addTo( newSubSection( "Generation Information" ), newParameterList( "Renderer Name", getRendererName( report1 ), "Software Name", getSoftwareName( report1 ) ) ) ); 


#===================================================================================================
# Report 2
# A custom report that reuses some elements created for Report 1 and custom styling.
#===================================================================================================

report2 <- newCustomReport( "Nozzle Demo Report 2" );
report2 <- setNextReport( report2, "nozzle3.html", "Demo 3" );
report2 <- setPreviousReport( report2, "nozzle1.html", "Demo 1" );

report2 <- addTo( report2, addTo( newSection( "My Introduction" ), newParagraph( "Hello World! This is a paragraph of text!" ) ) );
report2 <- addTo( report2, addTo( newSection( "My Methods" ), method2 ) );

report2 <- addTo( report2, addTo( newSection( "My Results", class="results" ),
				addTo( newSubSection( "Nozzle Figure" ), figure1, figure2 ),
				addTo( newSubSection( "Nozzle Table" ), table1, table4, table3, table5 ), 
				addTo( newSubSection( "Nozzle Text" ), paragraph1, list, paragraph2, paragraphPublic,
							paragraphGroup, paragraphPrivate ),
				addTo( addTo( newSubSection( "Nozzle Results" ), newParagraph( "A result: ", asSummary( result4 ), ", yay!" ) ) ) ) ); 

report2 <- addTo( report2, addTo( newSection( "My Bibliography" ), simpleCitation, webCitation, fullCitation ) );

# set a copyright message without URL
report2 <- setCopyright( report2, owner="Nils Gehlenborg", year=2013, statement="All rights reserved." ); 

# set contact information for error reports (no "label" provided, "Contact" will be used as a default)
report2 <- setContactInformation( report2, email="nils@hms.harvard.edu", subject="Problem with Nozzle Report", message="Hello World!\n\nThis is Nils!\n--End of Story--" );

# set a custom CSS file (for display in the browser - a separate CSS file can be supplied to printing)
report2 <- setCustomScreenCss( report2, "demo.css" );


#===================================================================================================
# Report 3
# An extremely basic report.
#===================================================================================================

report3 <- newReport( "Nozzle Demo Report 3" );
report3 <- setNextReport( report3, "nozzle4.html", "Demo 4" );
report3 <- setPreviousReport( report3, "nozzle2.html", "Demo 2" );

report3 <- addToResults( report3, addTo( newSubSection( "My SubSection" ), newParagraph( "My paragraph." ) ) );
report3 <- setCopyright( report3, owner="Nils Gehlenborg", year=2013 ); 

writeReport( report3, filename="nozzle3", level=PROTECTION.PRIVATE );


# --- HTML and RData file generation for reports 1 through 3 ---

writeReport( report1, filename="nozzle1_public", level=PROTECTION.PUBLIC );
writeReport( report1, filename="nozzle1_group", level=PROTECTION.GROUP );
writeReport( report1, filename="nozzle1_private", level=PROTECTION.PRIVATE );

# write a "debug" development version that uses external JS for rapid development
writeReport( report1, filename="nozzle1", debug=TRUE, level=PROTECTION.PRIVATE,
	debugJavaScript="/Users/nils/Projects/Firehose/Reports/Nozzle\ Library/Nozzle.R1/inst/js/nozzle.js" );

writeReport( report2, filename="nozzle2", debug=TRUE, level=PROTECTION.PRIVATE,
	debugJavaScript="/Users/nils/Projects/Firehose/Reports/Nozzle\ Library/Nozzle.R1/inst/js/nozzle.js" );

# clean up the R workspace - we are going to experiment with exported elements	
rm( list=ls() );


#===================================================================================================
# Report 4
# This report is assembled from elements exported by Report 1.
#===================================================================================================

report4 <- newReport( "Nozzle Demo Report 4" );

# load Report 1, this will create a variable "report" in the workspace
load( "nozzle1.RData" );

# print list of elements exported by Report 1 for demonstration purposes
getExportedElementIds( report )

# retrieve an element from Report 1
updatedElement = getExportedElement( report, "FIGURE_1" );

# check if the element is figure
if ( isFigure( updatedElement ) )
{
	# if necessary modify the file path for the figure image (this would actually break image in the report)
	# updatedElement <- setFigureFile( updatedElement, paste( "some/file/path/", getFigureFile( updatedElement ), collapse="", sep="" ) )
}

# check if the element is a table 
if ( isTable( updatedElement ) )
{
	# do something
}

# export more elements from Report 1 and add them to Report 4
report4 <- addToResults( report4, addTo( newSubSection( "Test 123 with Figure!" ), updatedElement, getExportedElement( report, "TABLE_1" ), getExportedElement( report, "FIGURE_1" ) ) );
report4 <- addToMethods( report4, addTo( getExportedElement( report, "METHOD_COOL" ), getExportedElement( report, "LIST_FORMAT" ) ) );

# set up navigation
report4 <- setNextReport( report4, "nozzle1.html", "Demo 1" );
report4 <- setPreviousReport( report4, "nozzle3.html", "Demo3" );

# write HTML and RData fie for Report 4
writeReport( report4, filename="nozzle4", level=PROTECTION.PRIVATE );
