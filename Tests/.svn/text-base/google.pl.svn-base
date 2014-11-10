#!/usr/bin/perl

use strict;
use warnings;
use CGI qw(:standard start_div end_div);
use CGI::Carp qw(fatalsToBrowser);

#use Mofa::View;
use lib('../');
use Mofa::Debuging;
use Mofa::Controller;
use Mofa::Model::Point;
use Mofa::Model::MeetingPt;

my $area = get_position();

my $px          = param('x');
my $py          = param('y');
my $name        = param('name');
my $description = param('description');

my $street = param('street');
my $nr     = param('nr');
my $city   = param('city');
my $zip    = param('zip');
my $state  = param('state');

my $erg              = undef;
my $datenbankeintrag = undef;
my @geocode          = ();
my @descs            = ();

if ( defined($px) and defined($py) and not( $px eq '' or $py eq '' ) ) {
    $erg = $area->contains( Mofa::Model::Point->new( { x => $px, y => $py } ) );
    if ( defined($name) and not $name eq '' ) {
        my $eintrag = Mofa::Model::MeetingPt->new(
            {   x           => $px,
                y           => $py,
                name        => $name,
                description => $description,
                street      => $street,
                nr          => $nr,
                zip         => $zip,
                city        => $city,
                state       => $state
            }
        );
        my $idx = $eintrag->add();
        if ( not defined($idx) ) { $idx = -42; }
        my $ans = Mofa::Model::MeetingPt->get( $eintrag->{id} );
        $datenbankeintrag = "Trage "
            . join( ' // ', map { $eintrag->{$_} } $eintrag->fields() )
            . " in Datenbank ein.<br>Er hat Index Nr.: $idx <br> "
            . join( ' // ', map { $ans->{$_} } $ans->fields() );
    }
    if (   ( defined($street) and not $street eq '' )
        or ( defined($city)  and not $city  eq '' )
        or ( defined($zip)   and not $zip   eq '' )
        or ( defined($state) and not $state eq '' ) )
    {
        if ( not defined($state) or $state eq '' ) { $state = 'DE'; }
        @geocode = geocode( $street, $nr, $city, $zip, $state );
        eval { ( $px, $py ) = $geocode[0]->ll(); };
        for (@geocode) {
            push @descs, $_->{description};
        }
    }
}
else {
    if ( $area->{error} ) { die( $area->{ans} . "\n" . $area->{msg} ); }
}

my @polygon = $area->asPolygon(0.2);
my ( $ax, $ay ) = $area->ll();

my $i       = 0;
my $jscript = '   var streets = [];
   var nrs = [];
   var citys = [];
   var zips = [];
   var states = [];
   var xs = [];
   var ys = [];
   var map;
   var area;
function getArea() {
    var pts = [];
';
while ( $i < int(@polygon) ) {
    $jscript .= '    pts.push(new GLatLng('
        . join( ',', $polygon[$i]->ll() ) . "));\n";
    $i++;
}
$jscript .= '    return pts;
}
function load() {
  if (GBrowserIsCompatible()) {
    map = new GMap2(document.getElementById("map"));
    map.addControl(new GLargeMapControl());
    map.addControl(new GMapTypeControl());
    
    var pt = new GLatLng('
    . ( defined($px) ? $px : $ax ) . ', '
    . ( defined($py) ? $py : $ay ) . ');
    map.setCenter(pt, 13);
    map.addOverlay(new GMarker(pt));
    area = new GPolyline(getArea());
    map.addOverlay(area);
';
foreach my $geo (@geocode) {
    my ( $gx, $gy ) = $geo->ll();
    $jscript .= '    streets.push("' . $geo->{street} . '");
    nrs.push("' . $geo->{nr} . '");      
    citys.push("' . $geo->{city} . '");      
    zips.push("' . $geo->{zip} . '");      
    xs.push("' . $gx . '");      
    ys.push("' . $gy . '");      
    states.push("' . $geo->{state} . '");
';
}
$jscript .= '    GEvent.addListener(map, "click", function(marker, point) {
      if (! marker){
        map.clearOverlays();
        map.addOverlay(area);
        map.addOverlay(new GMarker(point));
        document.getElementById("x").value = point.y;
        document.getElementById("y").value = point.x;
        map.panTo(point);
      }
    });
  }
}
function change_loc() {
    var i = document.getElementById("description").selectedIndex;
    document.getElementById("street").value=streets[i];
    document.getElementById("nr").value=nrs[i];
    document.getElementById("city").value=citys[i];
    document.getElementById("zip").value=zips[i]; 
    document.getElementById("state").value=states[i];        
    document.getElementById("x").value = xs[i];
    document.getElementById("y").value = ys[i];
    map.clearOverlays();
    map.addOverlay(area);
    var pt = new GLatLng(xs[i],ys[i]);
    map.addOverlay(new GMarker(pt));
    map.panTo(pt);
}';

print(
    header(),
    start_html(
        -script => [
            {   -src => 'http://maps.google.com/maps?file=api&v=2&key='
                    . $Mofa::Controller::key
            },
            $jscript
        ],
        -title    => 'Treffpunkt einfuegen',
        -onload   => 'load()',
        -onunload => 'GUnload()'
    ),
    start_form( { -action => 'google.pl' } ),
    div( { -id => 'message' } ),
    start_div(
        {   -id    => 'input',
            -style =>
                'float:right; width: 25%; height:33em; background:#F0F0F0; padding:1%; margin:1%;'
        }
    ),
    table(
        Tr( td('X-Koordinate'),
            td( input(
                    {   -id    => 'x',
                        -name  => 'x',
                        -value => ( defined($px) ? $px : $ax )
                    }
                )
            )
        ),
        Tr( td('Y-Koordinate'),
            td( input(
                    {   -id    => 'y',
                        -name  => 'y',
                        -value => ( defined($py) ? $py : $ay )
                    }
                )
            )
        ),
        Tr( td('Name'), td( input( { -id => 'name', -name => 'name' } ) ) ),
        Tr( td('Beschreibung'),
            td( popup_menu(
                    {   -id       => 'description',
                        -name     => 'description',
                        -onchange => 'change_loc()',
                        -values   => \@descs
                    }
                )
            )
        ),
        Tr( td('Straße'),
            td( input(
                    {   -id    => 'street',
                        -name  => 'street',
                        -value => $geocode[0]->{street}
                    }
                )
            )
        ),
        Tr( td('Hausnr'),
            td( input(
                    {   -id    => 'nr',
                        -name  => 'nr',
                        -value => $geocode[0]->{nr}
                    }
                )
            )
        ),
        Tr( td('Stadt'),
            td( input(
                    {   -id    => 'city',
                        -name  => 'city',
                        -value => $geocode[0]->{city}
                    }
                )
            )
        ),
        Tr( td('PLZ'),
            td( input(
                    {   -id    => 'zip',
                        -name  => 'zip',
                        -value => $geocode[0]->{zip}
                    }
                ),
            )
        ),
        Tr( td('Staat'),
            td( input(
                    {   -id    => 'state',
                        -name  => 'state',
                        -value => $geocode[0]->{state}
                    }
                )
            )
        ),
        Tr( td($erg), td( submit() ) )
    ),
    '<textarea name="test" cols="38" rows="15">'
);
if ( defined( $geocode[0]->{ans} ) ) { print( $geocode[0]->{ans} ); }
else { print $area->{ans}; }
print(
    '</textarea>', br(), $datenbankeintrag,
    end_div(),
    end_form(),

    div( { -id => 'map', -style => 'width: 70%; height: 35em;' } ),
    end_html()
);

