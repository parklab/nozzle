/*
 * Nozzle R Package - JavaScript Library
 *
 * Copyright 2011-2012, Harvard Medical School / Broad Institute
 * Authored and maintained by Nils Gehlenborg (nils@hms.harvard.edu)
 */

$(window).load(function() {  $("#mask").fadeOut() });

function initNozzle( reportId, jquery ) {

	var $ = jquery;
	
	var menuHeight = 25;
	var minHorizontalBorder = 30;
	var maxWidth = 1000;
	var autoWidth = false;
	
	var defaultMainToNoteRatio = 0.5;
	var currentMainToNoteRatio = 0.50;
	var mainToNoteDistance = 20;

	var isNoteVisible = false;
	var visibleNoteId = null;
				
	var getVerticalMargins = function( element ) { 
		return ( parseInt( element.css( "margin-top" ) ) + parseInt( element.css( "margin-bottom" ) ) );
	};

	var getVerticalPadding = function( element ) { 
		return ( parseInt( element.css( "padding-top" ) ) + parseInt( element.css( "padding-bottom" ) ) );
	};

	var getHorizontalMargins = function( element ) { 
		return ( parseInt( element.css( "margin-left" ) ) + parseInt( element.css( "margin-right" ) ) );
	};

	var getHorizontalPadding = function( element ) { 
		return ( parseInt( element.css( "padding-left" ) ) + parseInt( element.css( "padding-right" ) ) );
	};
	
	
	var getFrame = function() {	
		return $( "#" + reportId + " .frame" );
	}

	var getMain = function() {	
		return $( "#" + reportId + " .main" );
	}

	var getReport = function() {	
		return $( "#" + reportId );
	}
	
	var getMenu = function() {	
		return $( "#" + reportId + " .menu" );
	}
	
	var getVisibleNote = function() {
		return $( visibleNoteId );
	}
	
	
	var getCurrentFrameWidth = function() {
		if ( !autoWidth ) {		
			return ( Math.min( $(window).width() - 2*minHorizontalBorder, maxWidth ) );
		}
		else {
			return ( $(window).width() - 2*minHorizontalBorder );
		}
	};

	var getCurrentFrameLeftBorder = function() {
		if ( !autoWidth ) {		
			return ( ($(window).width() - getCurrentFrameWidth() )/2  );
		}
		else {
			return ( minHorizontalBorder  );
		}
	};

	$(document).ready( function() {
		// prefix and postfix to be applied to all relative URLs
		var args = getUrlVars( true ); 		
		applyFilePrefixPostfix( args["prefix"], args["postfix"] );	
	
		getFrame().css( 'height', $(window).height() + "px"  );
		getFrame().css( 'width',  getCurrentFrameWidth() + "px"  );
		getFrame().css( 'left',  getCurrentFrameLeftBorder() + "px"  );		
		
		getMenu().css( "height", menuHeight );
		getMain().css( "top", getMenu().outerHeight( true ) );

		if ( visibleNoteId != null )
		{
			getMain().css( "bottom", computeMainBottom() );
			getVisibleNote().css( "top", computeNoteTop() );
			evidenceToggleButton.css( 'top', computeNoteTop() + "px" );			
		}					
	});

	$(window).resize( function() {
		getFrame().css( 'height', $(window).height() + "px"  );
		getFrame().css( 'width',  getCurrentFrameWidth() + "px"  );
		getFrame().css( 'left',  getCurrentFrameLeftBorder() + "px"  );		

		getMenu().css( "height", menuHeight );
		getMain().css( "top", getMenu().outerHeight( true ) );

		if ( visibleNoteId != null )
		{
			getMain().css( "bottom", computeMainBottom() );
			getVisibleNote().css( "top", computeNoteTop() );
			evidenceToggleButton.css( 'top', computeNoteTop() + "px" );			
		}
	});
	
	
	$( "#" + reportId + " .main" ).scroll( function() {
		//console.log( $( "#" + reportId + " .main" ).scrollTop() );
	});



// Read a page's GET URL variables and return them as an associative array.
function getUrlVars( decode )
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');

    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        
        if ( decode == true ) {
	        vars[hash[0]] = decodeURIComponent( hash[1] );
	    }
	    else {
	        vars[hash[0]] = hash[1];	    
		}	    
	    
    }

    return vars;
}   


// add a prefix and postfix to each img src and href anchor tag that contain a relative path/url
function applyFilePrefixPostfix( prefix, postfix )
{
	// check if both prefix and postfix are not undefined
	if ( prefix == undefined && postfix == undefined ) {
		return 1;
	}
	
	// find all img tags
	var imageTags = $( "img" );
	var anchorTags = $( "a" );
	
	var counter = 0;
	
	imageTags.each( function() { 
			// check if this is a relative URL
			if ( $(this).attr( "src" ) === undefined ) {
				return;
			}						
			
			if ( $(this).attr( "src" ).indexOf( "://" ) === -1 ) {			
				$(this).attr( "src", prefix + $(this).attr( "src" ) + postfix );
				
				console.log( $(this).attr( "src" ) );
								
				counter++;
			}
			
			console.log( $(this).attr( "src" ) );			
		});	

	anchorTags.each( function() { 
			// check if this is a relative URL
			if ( $(this).attr( "href" ) === undefined ) {
				return;
			}			
			
			if ( $(this).attr( "href" ).indexOf( "://" ) === -1 && 
				  $(this).attr( "href" ).indexOf( "mailto:" ) === -1 &&
				  $(this).attr( "href" ) !== "#" ) {
				$(this).attr( "href", prefix + $(this).attr( "href" ) + postfix );

				console.log( $(this).attr( "src" ) );
								
				counter++;
			}
		});	
			
	return 0;
}
    
	
	ToggleMode = {
	    TOGGLE: 0,
	    SHOW: 1,
	    HIDE: 2
	};	
	
	var toggleContents = function( section, animation, mode, target )
	{
		target = target || ".sectionbody";
		
		section.each( function() {
		
			var section = $(this);
			mode = mode || ToggleMode.TOGGLE;					
			
			var button = section.find( ".button.contenttoggle" ).first();
			var body = section.find( target ).first();
			var summarySignificant = section.find( ".summary.significant" ).first();
			
			if ( body.length == 0 )
			{
				body = section;
			}
			
			// get all subsections in this section - if there is only one it will be expanded along with the section
			var subSections = section.find( ".subsection" ).not( ".meta, #" + reportId + " .evidence .section, #" + reportId + " .evidence .subsection, #" + reportId + " subsubsection .sectionheader" );
			
			switch ( mode )
			{
				case ToggleMode.TOGGLE:
					if ( subSections.length == 1 )
					{
						if ( !section.hasClass( "visible" ) )
						{
							toggleContents( subSections, false, ToggleMode.SHOW );
						}
					}
					
					section.toggleClass( "visible" );
					animation ? body.slideToggle( "fast" ) : body.toggle();
					if ( summarySignificant !== undefined )
					{
						summarySignificant.toggleClass( "deactivated" );
					}					
					break;
				case ToggleMode.SHOW:
					if ( subSections.length == 1 )
					{
						toggleContents( subSections, false, ToggleMode.SHOW );
					}
					
					section.addClass( "visible" );
					animation ? body.slideDown( "fast" ) : body.show();
					if ( summarySignificant !== undefined )
					{
						summarySignificant.addClass( "deactivated" );
					}					
					break;
				case ToggleMode.HIDE:
					section.removeClass( "visible" );
					animation ? body.slideUp( "fast" ) : body.hide();
					if ( summarySignificant !== undefined )
					{
						summarySignificant.removeClass( "deactivated" );
					}					
					break;
				
			}
			
			button.text( section.hasClass( "visible" ) ? "-" : "+" );					
			button.attr( "title", section.hasClass( "visible" ) ? "Click to collapse" : "Click to expand" );
		} );					
				
	};
	
	// create button to open/close sections/subsections
	var createContentsToggleButtons = function() {
	
		var sectionheaders = $( "#" + reportId + " .sectionheader" ).not( ".evidence .sectionheader, .subsubsection .sectionheader" );
		
		sectionheaders.prepend( "<span class=\"button contenttoggle\"><a>" + "-" + "</a></span>" );
		sectionheaders.parent().addClass( "visible" );
		
		var buttons = $( "#" + reportId + " .button.contenttoggle" );
		
		buttons.click( function() {
			toggleContents( $(this).parent().parent(), true, ToggleMode.TOGGLE );
		});										
	};


	// remove buttons to open/close sections/subsections (for printing)
	var removeContentsToggleButtons = function() {
	
		$( ".button.contenttoggle" ).remove();
	};

		   			
	var toggleAllContents = function( animation, mode ) {
		   			
		var sections = $( "#" + reportId + " .section, #" + reportId + " .subsection" ).not( "#" + reportId + " .evidence .section, #" + reportId + " .evidence .subsection, #" + reportId + " subsubsection .sectionheader" );
							
		toggleContents( sections, animation, mode );
	}
	
	var createContentsSummaryBar = function() {
	
		// contents summary bar (will contain indicator for significant results if any)
		var sectionheaders = $( ".results .sectionheader" ).not( "#" + reportId + " .evidence .sectionheader, #" + reportId + " .meta .sectionheader, #" + reportId + " .subsubsection .sectionheader" );		
		sectionheaders.append( "<span class=\"bar contentssummary\"></span>" );
	};
	
	
	var toggleWidthStateButton = function() {	
		if ( autoWidth ) {
			$( "#menu_width_state" ).text( "Fixed" );
		}		
		else {
			$( "#menu_width_state" ).text( "Auto" );
		}		
	};
	
	var createNozzleMenu = function() {
	
		var menu = "<div id=\"nozzlemenu\" class=\"menu\"><div class=\"menubar\">";

		if ( nozzleNavigation.parentUrl != null ) {
			menu += "<a href=\"" + nozzleNavigation.parentUrl + "\"><div class=\"menuitem\" id=\"menu_go_parent\" title=\"" + nozzleNavigation.parentName + "\">Up</div></a>";
		}
		else {
			menu += "<div class=\"menuitem deactivated\">Up</div>";
		}
		
		if ( nozzleNavigation.previousUrl != null ) {
			menu += "<a href=\"" + nozzleNavigation.previousUrl + "\"><div class=\"menuitem\" id=\"menu_go_previous\" title=\"" + nozzleNavigation.previousName + "\">&lt;</div></a>";
		}
		else {
			menu += "<div class=\"menuitem deactivated\">&lt;</div>";
		}

		if ( nozzleNavigation.nextUrl != null ) {
			menu += "<a href=\"" + nozzleNavigation.nextUrl + "\"><div class=\"menuitem\" id=\"menu_go_next\" title=\"" + nozzleNavigation.nextName + "\">&gt;</div></a>";
		}
		else {
			menu += "<div class=\"menuitem deactivated\">&gt;</div>";
		}

		menu += "<div class=\"menuitem separator\"></div>";
		
		menu += "<div class=\"menuitem\" id=\"menu_expand_all\">Expand All</div>\
			<div class=\"menuitem\" id=\"menu_collapse_all\">Collapse All</div>\
			<div class=\"menuitem\" id=\"menu_width\">Set&nbsp;<span id=\"menu_width_state\">Auto</span>&nbsp;Width</div>\
			<div class=\"menuitem\" id=\"menu_print_view\">Print</div>";
		
		if ( nozzleMeta.contact != null )
		{		
			menu += "<div class=\"menuitem separator\"></div>";
			
			var label = nozzleMeta.contact.label;
			
			if ( label == null )
			{
				label = "Contact";
			}
			
			menu += "<div class=\"menuitem highlighted\" id=\"menu_report_problem\" title=\"Send an email.\">" + label + "</div>";		
		}

		menu += "</div></div>";

		getFrame().prepend( menu );
		
		$( "#menu_expand_all" ).click( function() {
			toggleAllContents( true, ToggleMode.SHOW );
		});
		
		$( "#menu_collapse_all" ).click( function() {
			toggleAllContents( true, ToggleMode.HIDE );
			reduceAllFigures();
		});

		$( "#menu_width" ).click( function() {		
			autoWidth = !autoWidth;
			toggleWidthStateButton();
			getFrame().animate( { "width": getCurrentFrameWidth() + "px", "left": getCurrentFrameLeftBorder() + "px" }, "slow" );
		});

		$( "#menu_print_view" ).click( function() {
		
			// cover the report with an opaque mask
			$( "#mask" ).fadeIn();
			document.getElementById("mask").style.display = "block";
		
			// remove buttons, menus, and other stuff not required in the printed version
			removeContentsToggleButtons();
			removeEvidenceToggleButtons();			
			$( "#nozzlemenu" ).remove();
			$( "a.download" ).remove();
			
			enlargeAllFigures();		
			
			toggleAllContents( false, ToggleMode.SHOW );			
			
			// add "end note" style numbers next to each supplementary result in the text and 
			// move the supplementary result information to the end of the document and make
			// it visible
			addResultNumbers();
		
			// open the print dialog (the media=print stylesheet will be applied)
			window.print();										
			
			// reload the file (restores report)
			window.location.reload(false);			
		});
		
		if ( nozzleMeta.contact != null )
		{		
			$( "#menu_report_problem" ).click( function() {		
				var subject = nozzleMeta.contact.subject; // "Problem Report for \"" + nozzleMeta.reportTitle + "\" (" + nozzleMeta.reportId + ")";			
				var message = nozzleMeta.contact.message;
				var email = nozzleMeta.contact.email;
				
				var browserDetails = navigator.userAgent;
				var locationDetails = window.location.href;
				var displayDetails = "Not detected."
				
				if (window.screen) {
					displayDetails = 'Current Dimensions: ' + $(window).width() + " x " + $(window).height() + "%0A";
					displayDetails += 'Maximum Dimensions: ' + screen.availWidth + " x " + screen.availHeight + "%0A";
					displayDetails += 'Color Depth: ' + screen.colorDepth;
				}
				
				var softwareName = "NA";
				var softwareVersion = "NA";
				
				if ( nozzleMeta.software != undefined )
				{
					softwareName = nozzleMeta.software.name;
					softwareVersion = nozzleMeta.software.version;
				}
								
				var body = 
					message + "%0A" +
					"%0A" +
					"%0A" +
					"%0A" +
					"== REPORT ======================" + "%0A" +
					"%0A" +
					"URL: " + locationDetails + "%0A" +
					"Title: " + nozzleMeta.reportTitle + "%0A" +
					"Id: " + nozzleMeta.reportId + "%0A" +
					"Creator: " + nozzleMeta.creator.name + "%0A" +
					"Creation Date: " + nozzleMeta.creator.date + "%0A" +
					"Renderer: " + nozzleMeta.renderer.name + "%0A" +
					"Render Date: " + nozzleMeta.renderer.date + "%0A" +
					"Google Analytics: " + nozzleMeta.googleAnalyticsId + "%0A" +
					"%0A" +				
					"%0A" +
					"== SOFTWARE ====================" + "%0A" +
					"%0A" +					
					"Name: " + softwareName + "%0A" +
					"Version: " + softwareVersion + "%0A" +
					"%0A" +				
					"%0A" +
					"== MAINTAINER ==================" + "%0A" +
					"%0A" +
					"Name: " + nozzleMeta.maintainer.name + "%0A" +
					"Affiliation: " + nozzleMeta.maintainer.affiliation + "%0A" +
					"Email: " + nozzleMeta.maintainer.email + "%0A" +					
					"%0A" +				
					"%0A" +
					"== SYSTEM ======================" + "%0A" +				
					"%0A" +
					"System Time: " + (new Date()) + "%0A" +
					"User Agent: " + browserDetails + "%0A" +
					displayDetails + "%0A" +
					"%0A";
				
				window.location = "mailto:" + email + "?subject=" + subject + "&body=" + body;				
			});	
		}
				
		toggleWidthStateButton();		
	};
	
	
	var addResultNumbers = function() {
	
		var nextResultNumber = 1;
		
		$( ".evidence" ).each( function( index ) {
			var resultId = $(this).attr( "id" ).split( '_' )[1];
			
			$( "#resultid_" + resultId + "_" + reportId ).after( "&nbsp;<span class=\"resultnumbersup\">" + nextResultNumber + "</span>" );
			
			$(this).prepend( "<span class=\"resultnumber\">" + nextResultNumber + " - Supplementary Result</span>" );
			$(this).insertBefore( ".copyright" );
			$(this).show();
			
			nextResultNumber++;
		} );	
	}
	
/**
 * Forces a reload of all stylesheets by appending a unique query string
 * to each stylesheet URL.
 */
function reloadStylesheets() {
    var queryString = '?reload=' + new Date().getTime();
    $('link[rel="stylesheet"]').each(function () {
        this.href = this.href.replace(/\?.*|$/, queryString);
    });
}	
	
	
	/** These buttons are used to close the supplementary results.
	 */
	var createEvidenceToggleButtons = function() {
	
		// create button
		var sectionheaders = $( "#" + reportId + " .evidence" );
		
		sectionheaders.prepend( "<span class=\"button evidencetoggle\"><a title=\"Click to hide details\">" + "&times;" + "</a></span>" );
		sectionheaders.addClass( "visible" );
		
		var buttons = $( "#" + reportId + " .evidence .button.evidencetoggle" );
		
		buttons.click( function() {
			toggleContents( getVisibleNote(), false, ToggleMode.HIDE, ".evidence" );
			evidenceToggleButton.appendTo( $( visibleNoteId ) );
			
			var resultId = getVisibleNote().attr( 'id' ).split( '_' )[1];
			$( "#resultid_" + resultId + "_" + reportId ).removeClass( "active" );
			
			var oldScrollTop = $( "#" + reportId + " .main" ).scrollTop();
			
			//console.log( "before: " + $( "#" + reportId + " .main" ).scrollTop() );
			
			
			getMain().animate(
				{
					'bottom': "0px"
				},
				"slow",
				function() {
					isNoteVisible = false;
					visibleNoteId = null;
				});
		});										
	};
	
	// remove evidence toggle buttons
	var removeEvidenceToggleButtons = function() {
		$( ".button.evidencetoggle" ).remove();
	};
	
	
	createContentsToggleButtons();
	createContentsSummaryBar();
	createEvidenceToggleButtons();
	createNozzleMenu();	
		
	$( ".evidence" ).hide();
	
	
	var resultLocationRatio = 0.5;
	
	var computeMainBottom = function() {
		return ( getFrame().height() * (1 - currentMainToNoteRatio ) );
	};

	var computeNoteTop = function() {
		return ( getFrame().height() * currentMainToNoteRatio + mainToNoteDistance );
	};
	
	var evidenceToggleButton;

	var toggleEvidence = function() {
		var resultId = $(this).attr( 'id' ).split( '_' )[1];
		var evidence = $('#evidenceid_' + resultId + "_" + reportId );
		
		// move the evidence out of the main document and embedded directly in frame
		evidence.appendTo( getFrame() );
				
		if ( evidence.length != 0 )
		{
			if ( visibleNoteId != null && visibleNoteId != '#evidenceid_' + resultId + "_" + reportId ) {
				//toggleContents( $( visibleNoteId ), false, ToggleMode.HIDE, ".evidence" );
			}
			
			//$( "#results_" + reportId + " .result" ).not( $(this) ).removeClass( "active" );			
			$( ".result" ).not( $(this) ).removeClass( "active" );			
			$(this).toggleClass( 'active' );
			$(this).attr( "title", $(this).hasClass( "active" ) ? "Click to hide details" : "Click to show details" );

			evidence.css( 'top', computeNoteTop() + "px" );			
			evidence.css( 'bottom',  "0px" );			
									
			var offset = $(this).offset().top;
			var scrollTop = $( "#" + reportId + " .main" ).scrollTop();
			var height = $( "#" + reportId + " .main" ).height();
			
			resultLocationRatio = offset/height;
			scrollTarget = scrollTop + (($(window).height()/2) * (resultLocationRatio));
			
			// working, but loss of focus area 
			if ( !isNoteVisible ) {
				getMain().animate({
						"bottom":  computeMainBottom() + "px",					
					},
					"slow",					
					function() {						
						// move the evidence toggle button out of the main document and embedded directly in frame
						evidenceToggleButton = $( '#evidenceid_' + resultId + "_" + reportId + " .button.evidencetoggle" );
						evidenceToggleButton.css( 'top', computeNoteTop() + "px" );
						evidenceToggleButton.css( 'left', "-23px" );

						evidence.fadeToggle( 'slow', function() { evidenceToggleButton.appendTo( getFrame() ); } );							
						$(this).animate( { scrollTop: scrollTarget }, "slow" );				
						
						isNoteVisible = true;
						visibleNoteId = "#evidenceid_" + resultId + "_" + reportId;
				});
			}
			else
			{
				toggleContents( getVisibleNote(), false, ToggleMode.HIDE, ".evidence" );
				evidenceToggleButton.appendTo( $( visibleNoteId ) );

				if ( visibleNoteId != '#evidenceid_' + resultId + "_" + reportId ) {								
					evidence.fadeToggle( 'slow', function() { evidenceToggleButton.appendTo( getFrame() ); } );							
					visibleNoteId = "#evidenceid_" + resultId + "_" + reportId;

					evidenceToggleButton = $( '#evidenceid_' + resultId + "_" + reportId + " .button.evidencetoggle" );
					evidenceToggleButton.css( 'top', computeNoteTop() + "px" );
					evidenceToggleButton.css( 'left', "-23px" );					
				}
				else
				{
					
					getMain().animate(
						{
							'bottom': 0 + "px"
						},
						"slow",
						function() {
							isNoteVisible = false;
							visibleNoteId = null;
						});
				}
			}
		}
		else
		{
			alert( "No evidence found for result \"" + resultId + "\"." );
		}
							
		return false;
	}				
	

	$( ".result" ).not( ".noevidence" ).click( toggleEvidence );	
					
	var overallSignificantResults = 0;
	
	// find subsections in declared "results" sections that have significant results
	$( ".results .subsection" ).not( ".evidence" ).each( function( index ) {
		var significantResults = 0;
	
		$(this).find( '.result.significant' ).each( function( index ) {
			++significantResults;
		});
				
		if ( significantResults > 0 )
		{
			$(this).addClass( "significant" );			
			$(this).find( ".contentssummary" ).first().append( "<span class=\"summary significant\" title=\"Section contains findings that crossed a statistical threshold.\"></span>" );						
		}
		
		overallSignificantResults += significantResults;
	} );
					
	if ( overallSignificantResults > 0 )
	{	
		$( ".results .sectionheader .contentssummary" ).not( ".subsection .sectionheader .contentssummary" ).html( "<span class=\"summary significant\" title=\"Section contains findings that crossed a statistical threshold.\"></span>" );
	}
	
	var scaleImage = function() {
		var width = $(this).css( 'width' );
		
		if ( width === "200px" )
		{
			$(this).animate( { 'width': "800px" }, "fast" );
			$(this).attr( "title", "Click to reduce" );
		}
		else
		{
			$(this).animate( { 'width': "200px" }, "fast" );
			$(this).attr( "title", "Click to enlarge" );
		}
							
		return false;
	}				
	
	var enlargeAllFigures = function() {
		$( '.figure .image').each( function() { 
			$(this).find( "img" ).css( "width", "800px" );
		});		
	}

	var reduceAllFigures = function() {
		$( '.figure .image').each( function() { 
			$(this).find( "img" ).css( "width", "200px" );
		});		
	}
	
	// make figures "scalable"				
	$( '.figure .image').each( function() { 
		$(this).find( "img" ).css( "width", "200px" );
		$(this).find( "img" ).click( scaleImage );
		$(this).find( "img" ).attr( "title", "Click to enlarge" );
	});	
	
	// add parser through the tablesorter addParser method 
	// from: http://stackoverflow.com/questions/4126206/javascript-parsefloat-1-23e-7-gives-1-23e-7-when-need-0-000000123
	// see also here: http://tablesorter.com/docs/example-parsers.html
	$.tablesorter.addParser({ 
		// set a unique id
		id: 'scientificNotation', 
		is: function(s) { 
			return /[+\-]?(?:0|[1-9]\d*)(?:\.\d*)?(?:[eE][+\-]?\d+)?/.test(s); 
		}, 
		format: function(s) { 
			return $.tablesorter.formatFloat(s);
		}, 
		type: 'numeric' 
	});	

	$.tablesorter.addParser({ 
		// set a unique id
		id: 'bigMark', 
		is: function(s) { 
			return /^[0-9]?[0-9]?[0-9](,[0-9][0-9][0-9])*$/.test(s); 
		}, 
		format: function(s) { 
			return s.replace( /,/gi, "" );
		}, 
		type: 'numeric' 
	});	
	
	// make tables sortable
	$( '.resulttable.tablesorter.sortabletable').each( function() {	
			$( this ).tablesorter();	// debug with: $( this ).tablesorter( { debug: true });
	} );

	var toggleDefaultState = function( animate )	{	
		toggleAllContents( animate, ToggleMode.HIDE );	   			
		toggleContents( $( "#overview_" + reportId + ", #summary_" + reportId ), animate );				
		toggleContents( $( "#results_" + reportId ), animate );				
	};
		
	toggleDefaultState( false );
}
