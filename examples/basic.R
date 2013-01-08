# A very basic report to introduce the Nozzle API.
# 
# Author: Nils Gehlenborg (nils@hms.harvard.edu)
###############################################################################

require( Nozzle.R1 )

# Phase 1: create report elements
r <- newCustomReport( "My Report" );
s <- newSection( "My Section" );
ss1 <- newSection( "My Subsection 1" );
ss2 <- newSection( "My Subsection 2" );
t <- newTable( iris[45:55,], "Iris data." ); # w/ caption
p <- newParagraph( "Some sample text." );

# Phase 2: assemble report structure bottom-up
ss1 <- addTo( ss1, t ); # parent, child_1, ..., child_n 
ss2 <- addTo( ss2, p );
s <- addTo( s, ss1, ss2 );
r <- addTo( r, s );

# Phase 3: render report to file
writeReport( r, filename="reports/my_report" ); # w/o extension