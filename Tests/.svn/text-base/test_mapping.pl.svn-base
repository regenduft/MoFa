#!/usr/bin/perl

use strict;
use warnings;
use CGI::Ajax;
use CGI::Pretty qw(:standard);
use CGI::Carp qw(fatalsToBrowser);

use lib('..');
use Mofa::Controller;
use Mofa::Model::Point;
use Mofa::Model::MeetingPt;
use Mofa::Model::Person;
use Mofa::Model::Offer;
use Mofa::Model::Request;

my $cgi = new CGI;
my $pjx = new CGI::Ajax(
    'get_offer'   => sub { return get_lift( 'Mofa::Model::Offer',   @_ ); },
    'get_request' => sub { return get_lift( 'Mofa::Model::Request', @_ ); },
    'get_dist'    => sub { return get_dist(@_); }
);
$pjx->JSDEBUG(2);

# print (header(), show_html());
print $pjx->build_html( $cgi, \&show_html );

sub get_dist {
    my ( $offer_id, $request_id ) = @_;
    $offer_id =~ m/(\d*)\:.*/;
    my $offer   = Mofa::Model::Offer->get($1);
    my $request = Mofa::Model::Request->get($request_id);
    my ( $detour1, $time1, $url1 )
        = Mofa::Controller::street_dist( $offer->start(), $request->start() );
    my ( $detour2, $time2, $url2 )
        = Mofa::Controller::street_dist( $request->start(),
        $request->destination() );
    my ( $detour3, $time3, $url3 )
        = Mofa::Controller::street_dist( $request->destination(),
        $offer->destination() );
    my ( $detour4, $time4, $url4 )
        = Mofa::Controller::street_dist( $offer->start(),
        $offer->destination() );
    my $detour = $detour1 + $detour2 + $detour3 - $detour4;
    my $time   = $time1 + $time2 + $time3 - $time4;
    return
        "$detour1 + $detour2 + $detour3 - $detour4 = $detour;   $time1 + $time2 + $time3 - $time4 = $time"
        . "\n\n$url1\n\n$url2\n\n$url3\n\n$url4\n";
}

sub get_lift {
    my $class = shift;
    my $id    = shift;
    if ( not defined($id) or $id < 0 ) {
        return ( 'null', 48.5, 7.5, 'null', 48.5, 7.5 );
    }
    my $ans = $class->get($id);
    my ( $ix, $iy, $ax, $ay ) = Mofa::Controller::calc_box($ans);
    my $min = Mofa::Model::Point->new( { utm_x => $ix, utm_y => $iy } );
    my $max = Mofa::Model::Point->new( { utm_x => $ax, utm_y => $ay } );
    my @ans = (
        $ans->start()->{name} . ' - '
            . join( '; ', $ans->start()->ll(), $min->ll() ),
        $ans->start()->ll(),
        $ans->destination()->{name} . ' - '
            . join( '; ', $ans->destination()->ll(), $max->ll() ),
        $ans->destination()->ll(),
        $min->ll(),
        $max->ll()
    );

    my @touch = eval { Mofa::Controller::mapping_search($ans) };
    if ( scalar(@touch) < 1 ) { $ans[0] = $@; return @ans; }
    foreach my $touch ( @touch ) {
        my $start = $touch->offer()->start;
        my $dest = $touch->offer()->destination;
        my $bla = eval {
            $touch->offer->id . ": "
                . $touch->detour . "  ("
                . $start->description() . " -> "
                . $dest->description() . ")";
        };
        if ( not defined($bla) ) { $bla = $@; }
        push( @ans, $bla, $start->ll(), $dest->ll() );
    }

    return @ans;

}

sub change_map {
    my ( $prefix, $id ) = @_;
    if ( $id < 0 or $id eq '-1' ) {
        return ( $prefix, '', '', '', '', '', 48.5, 7.5, '', -1 );
    }

    my $geo = Mofa::Model::MeetingPt->get($id);
    return ( $prefix, $geo->{description}, $geo->{street}, $geo->{nr},
        $geo->{city}, $geo->{zip}, $geo->ll(),
        $geo->{state} . ' // ' . $geo->{region} . ' // ' . $geo->{district},
        $id );
}

sub show_html {

    return (
        join(
            "\n",
            start_html(
                -script => [
                    {   -src =>
                            'http://maps.google.com/maps?file=api&v=2&key='
                            . $Mofa::Controller::key
                    },
                    jscript_map()
                ],
                -title    => 'Mapping testen',
                -onload   => 'load()',
                -onunload => 'GUnload()'
            ),
            start_form( { -action => 'google_add_lift.pl' } ),
            div({   -id    => 'map',
                    -style =>
                        'float:left;border-width:1px;border-style:solid;width: 42em; height: 30em;'
                },
                br()
            ),
            div({   -style =>
                        'float:left;border-width:1px;border-style:solid;width:15em; background:#F0F0F0; padding:0.5em; margin-left:0.5em; margin-bottom:0.5em;'
                },
                table(
                    Tr( td('Offer'),
                        td( popup_menu(
                                {   -id       => 'offer_id',
                                    -name     => 'offer_id',
                                    -onchange =>
                                        'get_offer([\'offer_id\'], [change_lift] )',
                                    -values => [
                                        -1,
                                        eval { @{ Mofa::Model::Offer->get_ids() } }
                                    ]
                                }
                            )
                        ),
                    ),
                    Tr( td('Request'),
                        td( popup_menu(
                                {   -id       => 'request_id',
                                    -name     => 'request_id',
                                    -onchange =>
                                        'get_request([\'request_id\'], [change_lift] )',
                                    -values => [
                                        -1,
                                        eval { @{ Mofa::Model::Request->get_ids() } }
                                    ]
                                }
                            )
                        )
                    )
                )
            ),
            div({   -style =>
                        'float:left;border-width:1px;border-style:solid;width:49em; background:#F0F0F0; padding:0.5em; margin-top:0.5em;'
                },
                input(
                    {   -id    => 'debug1',
                        -name  => 'debug1',
                        -style => 'width:99%;'
                    }
                ),
                input(
                    {   -id    => 'debug2',
                        -name  => 'debug2',
                        -style => 'width:99%;'
                    }
                ),
                scrolling_list(
                    {   -id       => 'bla',
                        -name     => 'bla',
                        -size     => 6,
                        -style    => 'width:100%;',
                        -onchange =>
                            'get_dist([\'bla\', \'request_id\'], [\'blubb\'] )',

                    }
                ),
                textarea(
                    {   -id    => 'blubb',
                        -name  => 'blubb',
                        -style => 'width:100%;height:10em;'
                    }
                )
            ),
            end_form(),
            end_html()
        )
    );
}

sub jscript_map {
    my $i       = 0;
    my $jscript = 'var map;
function hinzu (liste, text, wert) {
  var Eintrag = document.createElement("option");
  Eintrag.text = text;
  Eintrag.value = wert;
  var FolgendeOption = null;
  if (document.all)
    FolgendeOption = liste.length;
  liste.add(Eintrag, FolgendeOption);
}
function change_lift() {
    document.getElementById("debug1").value=arguments[0];
    document.getElementById("debug2").value=arguments[3];   
   var liste = document.getElementById("bla");
   liste.value=null;
   var i = liste.length;
   while ( i > 0 ) {
     i--;
     liste.options[i]=null;
     liste.remove(i);
   }
    map.clearOverlays();
    var start = new GLatLng(arguments[1], arguments[2]);
    map.addOverlay(new GMarker(start));
    var dest = new GLatLng(arguments[4], arguments[5]);
    map.addOverlay(new GMarker(dest));
    var lift = new GPolyline([start,dest],"#ff0000");
    var boxpts = [];
    boxpts.push(new GLatLng(arguments[6], arguments[7]));
    boxpts.push(new GLatLng(arguments[8], arguments[7]));
    boxpts.push(new GLatLng(arguments[8], arguments[9]));
    boxpts.push(new GLatLng(arguments[6], arguments[9]));
    boxpts.push(new GLatLng(arguments[6], arguments[7]));
    map.addOverlay(new GPolyline(boxpts,"#ffff00"));
    map.addOverlay(lift);
    map.setCenter(start);
    var i = 10;
    while (arguments.length > i){
    	hinzu(liste, arguments[i], arguments[i]);
    	map.addOverlay(new GPolyline([new GLatLng(arguments[i+1], arguments[i+2]), new GLatLng(arguments[i+3], arguments[i+4])]));
    	i = i + 5;
    }
}
function load() {
  if (GBrowserIsCompatible()) {
    var pt = new GLatLng(48.5, 7.5);
    map = new GMap2(document.getElementById("map"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    map.setCenter(pt, 12);
    GEvent.addListener(map, "click", function(marker, point) {
      if (! marker){
        map.panTo(point);
      }
    });
  }
}';
}
