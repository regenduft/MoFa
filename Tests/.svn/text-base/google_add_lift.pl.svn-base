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

my ( $ax, $ay ) = ( 48.5, 7.5 );
my $area;
eval { $area = get_position(); ( $ax, $ay ) = $area->ll(); };
my @contained_meetingpts
    = eval { Mofa::Model::MeetingPt->get_points_in_area($area) };
my %meetingpts = eval { %{ Mofa::Model::MeetingPt->get_all() } };

#my $pt;
#my $erg = undef;

my $cgi = new CGI;
my $pjx = new CGI::Ajax(
    'geo_code0'   => sub { return geo_code( 0,               @_ ); },
    'geo_code1'   => sub { return geo_code( 1,               @_ ); },
    'geo_code2'   => sub { return geo_code( 2,               @_ ); },
    'change_map0' => sub { return change_map( 0,             @_ ); },
    'change_map1' => sub { return change_map( 1,             @_ ); },
    'change_map2' => sub { return change_map( 2,             @_ ); },
    'add_person'  => sub { return add_person(@_); },
    'get_person'  => sub { return get_person(@_); },
    'get_offer'   => sub { return get_lift( 'Mofa::Model::Offer',   @_ ); },
    'get_request' => sub { return get_lift( 'Mofa::Model::Request', @_ ); }
);
$pjx->JSDEBUG(2);

my $lift_insert_erg;
if ( defined( param('start_time') ) and not param('start_time') eq '' ) {
    $lift_insert_erg = add_lift(
        'NULL',                param('1id'),
        param('0id'),          param('start_time'),
        param('arrival_time'), param('timeAccuracy'),
        param('seats'),        param('fee'),
        param('driver_id'),    param('type')
    );
}

#print (header(), show_html());
print $pjx->build_html( $cgi, \&show_html );

sub add_lift {
    my ($id,          $destination,  $start, $startTime,
        $arrivalTime, $timeAccuracy, $seats, $fee,
        $who,         $type
        )
        = @_;
    my $class = 'Mofa::Model::Offer';
    if ( defined($type) and $type eq 'on' ) { $class = 'Mofa::Model::Request'; }
    my $lift = $class->new(
        {   id           => $id,
            destination  => $destination,
            start        => $start,
            startTime    => $startTime,
            arrivalTime  => $arrivalTime,
            timeAccuracy => $timeAccuracy,
            seats        => $seats,
            fee          => $fee,
            provider     => $who,
            requester    => $who
        }
    );
    return $lift->add();
}

sub get_lift {
    my $class = shift;
    my $id    = shift;
    if ( not defined($id) or $id < 0 ) {
        return ( -1, -1, -1, '', '', '', '', '', -1 );
    }
    my $ans = $class->get($id);
    return (
        $ans->{id},
        $ans->{destination},
        $ans->{start},
        $ans->{startTime},
        $ans->{arrivalTime},
        $ans->{timeAccuracy},
        $ans->{seats},
        $ans->{fee},
        defined( $ans->{requester} ) ? $ans->{requester} : $ans->{provider}
    );

}

sub add_person {
    my ($id,           $password,  $name,       $prename,
        $cellular,     $msisdn,    $bday,       $type,
        $banking_name, $bank_code, $account_nr, $address
        )
        = @_;
    my $entry = Mofa::Model::Person->new(
        {   id           => $id,
            password     => $password,
            name         => $name,
            prename      => $prename,
            cellular     => $cellular,
            msisdn       => $msisdn,
            bday         => $bday,
            type         => $type,
            banking_name => $banking_name,
            bank_code    => $bank_code,
            account_nr   => $account_nr,
            address      => $address
        }
    );
    my $idx = eval { $entry->add() };
    if ( not defined($idx) ) { $idx = -42; }
    my $ans = Mofa::Model::Person->get( $entry->{id} );
    return (
        $ans->{id},        $ans->{password},   $ans->{name},
        $ans->{prename},   $ans->{cellular},   $ans->{msisdn},
        $ans->{bday},      $ans->{type},       $ans->{banking_name},
        $ans->{bank_code}, $ans->{account_nr}, $ans->{address},
        $idx
    );
}

sub get_person {
    my $id = shift;
    if ( not defined($id) or $id < 0 ) {
        return ( '', '', '', '', '', '', '', '', '', '', '', -1 );
    }
    my $ans = Mofa::Model::Person->get($id);
    return (
        $ans->{id},        $ans->{password},   $ans->{name},
        $ans->{prename},   $ans->{cellular},   $ans->{msisdn},
        $ans->{bday},      $ans->{type},       $ans->{banking_name},
        $ans->{bank_code}, $ans->{account_nr}, $ans->{address}
    );
}

sub geo_code {
    my ($prefix, $name, $street, $nr,    $city,
        $zip,    $x,    $y,      $state, $description
        )
        = @_;
    if ( defined($name) and not $name eq '' ) {
        my $entry = Mofa::Model::MeetingPt->new(
            {   x           => $x,
                y           => $y,
                name        => $name,
                description => $description,
                street      => $street,
                nr          => $nr,
                zip         => $zip,
                city        => $city,
                state       => $state
            }
        );
        my $id = $entry->add();
        if ( not defined($id) ) { $id = -42; }
        my $geo;
        if (    ( $id > 0 or $id == -2 or $id == -3 )
            and ( defined( $entry->{id} ) and $entry->{id} > 0 ) )
        {
            $geo = Mofa::Model::MeetingPt->get( $entry->{id} );
        }
        else {
            return (
                $prefix, '', '',
                'id: ' . $id,
                'entry_id: ' . defined( $entry->{id} ) ? $entry->{id} : -42,
                '', $ax, $ay, '', -2
            );
        }
        return (
            $prefix,
            $geo->{description},
            $geo->{street},
            $geo->{nr},
            $geo->{city},
            $geo->{zip},
            $geo->ll(),
            $geo->{state} . ' // '
                . $geo->{region} . ' // '
                . $geo->{district},
            $geo->{id}
        );
    }
    if ( not defined($state) or $state eq '' ) { $state = 'DE'; }
    my @geocode = geocode( $street, $nr, $city, $zip, $state );
    my @res = ($prefix);
    foreach my $geo (@geocode) {
        push( @res,
            $geo->{description},
            $geo->{street},
            $geo->{nr},
            $geo->{city},
            $geo->{zip},
            $geo->ll(),
            $geo->{state} . ' // '
                . $geo->{region} . ' // '
                . $geo->{district},
            -1 );
    }
    return @res;
}

sub change_map {
    my ( $prefix, $id ) = @_;
    if ( $id < 0 or $id eq '-1' ) {
        return ( $prefix, '', '', '', '', '', $ax, $ay, '', -1 );
    }

    my $geo = Mofa::Model::Address->get($id);
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
                    jscript_map($area)
                ],
                -title    => 'Mitfahr-Angebot oder Gesuch eintragen',
                -onload   => 'load()',
                -onunload => 'GUnload()'
            ),
            start_form( { -action => 'google_add_lift.pl' } ),
            div({   -id    => 'input_lift',
                    -style =>
                        'border-width:1px;border-style:solid;float:left;width:21em; background:#F0F0F0; padding:0.5em; margin-right:0.5em;'
                },
                strong('Zeitpunkt, Sitzplätze'),
                table(
                    Tr( td('Startzeit'),
                        td( input(
                                {   -id   => 'start_time',
                                    -name => 'start_time'
                                }
                            )
                        )
                    ),
                    Tr( td('Endzeit'),
                        td( input(
                                {   -id   => 'arrival_time',
                                    -name => 'arrival_time'
                                }
                            )
                        )
                    ),
                    Tr( td('Genauigkeit'),
                        td( input(
                                {   -id   => 'timeAccuracy',
                                    -name => 'timeAccuracy'
                                }
                            )
                        )
                    ),
                    Tr( td('Sitzplätze'),
                        td( input( { -id => 'seats', -name => 'seats' } ) )
                    ),
                    Tr( td('Preis/km'),
                        td( input( { -id => 'fee', -name => 'fee' } ) )
                    ),
                    Tr( td( $lift_insert_erg,
                            checkbox( { -id => 'type', -name => 'type' } )
                        ),
                        td( submit("Mitfahrgelegenheit eintragen") )
                    )
                )
            ),
            div({   -id    => 'input_links',
                    -style =>
                        'border-width:1px;border-style:solid;float:left;width:21em; background:#F0F0F0; padding:0.5em;'
                },
                strong('Start, Ziel, Fahrer'),
                table(
                    Tr( td('Start'),
                        td( popup_menu(
                                {   -id       => '0id',
                                    -name     => '0id',
                                    -style    => 'width:18em',
                                    -onchange =>
                                        'change_map0([\'0id\'], [set_geodata] )',
                                    -values => [
                                        -1,
                                        (   sort {
                                                $meetingpts{$a}
                                                    cmp $meetingpts{$b};
                                                } map {$_->id()} @contained_meetingpts
                                        )
                                    ],
                                    -labels =>
                                        { -1 => 'Bitte wählen', %meetingpts }
                                }
                            )
                        )
                    ),
                    Tr( td('Ziel'),
                        td( popup_menu(
                                {   -id       => '1id',
                                    -name     => '1id',
                                    -style    => 'width:18em',
                                    -onchange =>
                                        'change_map1([\'1id\'], [set_geodata] )',
                                    -values => [
                                        -1,
                                        (   sort {
                                                $meetingpts{$a}
                                                    cmp $meetingpts{$b};
                                                } keys(%meetingpts)
                                        )
                                    ],
                                    -labels =>
                                        { -1 => 'Bitte wählen', %meetingpts }
                                }
                            )
                        )
                    ),
                    Tr( td('Fahrer_id'),
                        td( popup_menu(
                                {   -id       => 'driver_id',
                                    -name     => 'driver_id',
                                    -style    => 'width:18em',
                                    -onchange =>
                                        'get_person([\'driver_id\'], [change_driver] )',
                                    -values => [
                                        -1,
                                        eval { @{ Mofa::Model::Person->get_ids() } }
                                    ]
                                }
                            )
                        )
                    ),
                    Tr( td( { -colspan => 2 }, hr() ) ),
                    Tr( td('Offer_id'),
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
                        )
                    ),
                    Tr( td('Request_id'),
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
            div( { -style => 'clear:left;' } ),
            br(),
            display_map( 0, 'Start' ),
            display_map( 1, 'Ziel' ),
            display_driver(),
            end_form(),
            div( input( { -id => 'debug', -name => 'debug' } ) ),
            end_html()
        )
    );
}

sub display_driver {
    my $prefix = 2;
    return (
        display_map( $prefix, 'Fahrer' ),
        div({   -id    => $prefix . 'person',
                -style =>
                    'border-width:1px;border-style:solid;float:left; width:21em; background:#F0F0F0; padding:0.5em;'
            },
            strong('Fahrer - Name, Login, Kto'),
            table(
                Tr( td('Login'),
                    td( input(
                            {   -id   => $prefix . 'driver_id',
                                -name => $prefix . 'driver_id'
                            }
                        )
                    )
                ),
                Tr( td('Passwort'),
                    td( input(
                            {   -id   => $prefix . 'password',
                                -name => $prefix . 'password'
                            }
                        )
                    )
                ),
                Tr( td('Nachname'),
                    td( input(
                            {   -id   => $prefix . 'surname',
                                -name => $prefix . 'surname'
                            }
                        )
                    )
                ),
                Tr( td('Vorname'),
                    td( input(
                            {   -id   => $prefix . 'prename',
                                -name => $prefix . 'prename'
                            }
                        )
                    )
                ),
                Tr( td('Fahrer_ort'),
                    td( popup_menu(
                            {   -id       => $prefix . 'id',
                                -name     => $prefix . 'id',
                                -style    => 'width:18em',
                                -onchange => 'change_map2([\'' . $prefix
                                    . 'id\'], [set_geodata] )',
                                -values => [
                                    -1,
                                    (   sort {
                                            $meetingpts{$a}
                                                cmp $meetingpts{$b};
                                            } keys(%meetingpts)
                                    )
                                ],
                                -labels =>
                                    { -1 => 'Bitte wählen', %meetingpts }
                            }
                        )
                    )
                ),
                Tr( td('Handynr'),
                    td( input(
                            {   -id   => $prefix . 'cellular',
                                -name => $prefix . 'cellular'
                            }
                        )
                    )
                ),
                Tr( td('Msisdn'),
                    td( input(
                            {   -id   => $prefix . 'msisdn',
                                -name => $prefix . 'msisdn'
                            }
                        )
                    )
                ),
                Tr( td('Positionierbar'),
                    td( checkbox(
                            {   -id   => $prefix . 'positionable',
                                -name => $prefix . 'positionable'
                            }
                        )
                    )
                ),
                Tr( td('Geburtstag'),
                    td( input(
                            {   -id   => $prefix . 'bday',
                                -name => $prefix . 'bady'
                            }
                        )
                    )
                ),
                Tr( td('Typ'),
                    td( input(
                            {   -id   => $prefix . 'type',
                                -name => $prefix . 'type'
                            }
                        )
                    )
                ),
                Tr( td('Kontoinhaber'),
                    td( input(
                            {   -id   => $prefix . 'kto_name',
                                -name => $prefix . 'kto_name'
                            }
                        )
                    )
                ),
                Tr( td('Bankleitzahl'),
                    td( input(
                            {   -id   => $prefix . 'blz',
                                -name => $prefix . 'blz'
                            }
                        )
                    )
                ),
                Tr( td('Kontonummer'),
                    td( input(
                            {   -id   => $prefix . 'kto_nr',
                                -name => $prefix . 'kto_nr'
                            }
                        )
                    )
                ),
                Tr( td( input(
                            { -id => 'driver_added', -style => 'width:8em' }
                        )
                    ),
                    td( a(  {         -href => 'javascript:add_person( [\''
                                    . $prefix
                                    . 'driver_id\', \''
                                    . $prefix
                                    . 'password\', \''
                                    . $prefix
                                    . 'surname\', \''
                                    . $prefix
                                    . 'prename\', \''
                                    . $prefix
                                    . 'cellular\', \''
                                    . $prefix
                                    . 'msisdn\', \''
                                    . $prefix
                                    . 'bday\', \''
                                    . $prefix
                                    . 'type\', \''
                                    . $prefix
                                    . 'kto_name\', \''
                                    . $prefix
                                    . 'blz\', \''
                                    . $prefix
                                    . 'kto_nr\', \''
                                    . $prefix
                                    . 'id\'],' . '[\''
                                    . $prefix
                                    . 'driver_id\', \''
                                    . $prefix
                                    . 'password\', \''
                                    . $prefix
                                    . 'surname\', \''
                                    . $prefix
                                    . 'prename\', \''
                                    . $prefix
                                    . 'cellular\', \''
                                    . $prefix
                                    . 'msisdn\', \''
                                    . $prefix
                                    . 'bday\', \''
                                    . $prefix
                                    . 'type\', \''
                                    . $prefix
                                    . 'kto_name\', \''
                                    . $prefix
                                    . 'blz\', \''
                                    . $prefix
                                    . 'kto_nr\', \''
                                    . $prefix
                                    . 'id\', \'driver_added\'] );'
                            },
                            'Fahrer in DB speichern'
                        )
                    )
                )
            )
        )
    );
}

sub display_map {
    my $prefix = shift();
    my $desc   = shift;
    return (
        div({   -id    => $prefix . 'map',
                -style =>
                    'border-width:1px;border-style:solid;float:left; width:21em; background:#F0F0F0; padding:0.5em; margin-right:0.5em;'
            },
            strong( 'Adresse des ' . $desc ),
            table(
                Tr( td('X_Koordinate'),
                    td( input(
                            {   -id    => $prefix . 'x',
                                -name  => $prefix . 'x',
                                -value => $ax
                            }
                        )
                    )
                ),
                Tr( td('Y_Koordinate'),
                    td( input(
                            {   -id    => $prefix . 'y',
                                -name  => $prefix . 'y',
                                -value => $ay
                            }
                        )
                    )
                ),
                Tr( td('Name'),
                    td( input(
                            {   -id   => $prefix . 'name',
                                -name => $prefix . 'name'
                            }
                        )
                    )
                ),
                Tr( td('Beschreibung'),
                    td( popup_menu(
                            {   -id       => $prefix . 'description',
                                -name     => $prefix . 'description',
                                -style    => 'width:18em',
                                -onchange => 'change_loc(' . $prefix . ')',
                                -onclick  => 'change_loc(' . $prefix . ')',
                            }
                        )
                    )
                ),
                Tr( td('Straße'),
                    td( input(
                            {   -id   => $prefix . 'street',
                                -name => $prefix . 'street'
                            }
                        )
                    )
                ),
                Tr( td('Hausnr'),
                    td( input(
                            {   -id   => $prefix . 'nr',
                                -name => $prefix . 'nr'
                            }
                        )
                    )
                ),
                Tr( td('Stadt'),
                    td( input(
                            {   -id   => $prefix . 'city',
                                -name => $prefix . 'city'
                            }
                        )
                    )
                ),
                Tr( td('PLZ'),
                    td( input(
                            {   -id   => $prefix . 'zip',
                                -name => $prefix . 'zip'
                            }
                        ),
                    )
                ),
                Tr( td('Staat'),
                    td( input(
                            {   -id   => $prefix . 'state',
                                -name => $prefix . 'state'
                            }
                        )
                    )
                ),
                Tr( td(),
                    td( a(  {         -href => 'javascript:geo_code' . $prefix
                                    . '( [\''
                                    . $prefix
                                    . 'name\', \''
                                    . $prefix
                                    . 'street\', \''
                                    . $prefix
                                    . 'nr\', \''
                                    . $prefix
                                    . 'city\', \''
                                    . $prefix
                                    . 'zip\', \''
                                    . $prefix
                                    . 'x\', \''
                                    . $prefix
                                    . 'y\', \''
                                    . $prefix
                                    . 'state\', \''
                                    .

                                    $prefix
                                    . 'description\'], [set_geodata] );'
                            },
                            'Adresse vervollständigen'
                        )
                    )
                )
            )
        ),
        div({   -id    => 'map' . $prefix,
                -style =>
                    'float:left;border-width:1px;border-style:solid;width: 22em; height: 17em;'
            },
            br()
        ),
        div( { -style => 'clear:left;' } ),
        br(),
    );
}

sub jscript_map {
    my $centerpt = shift;
    if ( not defined($centerpt) ) {
        $centerpt = Mofa::Model::Point->new( { y => 7.5, x => 48.5 } );
    }
    my $jscript = '   var streets = [];
   var nrs = [];
   var citys = [];
   var zips = [];
   var states = [];
   var xs = [];
   var ys = [];
   var maps = [];
   var ids = [];
   var area = [];
   var max = 3;
   var ds = 9;
function getArea() {
    var pts = [];
';
    my @polygon;
    eval { @polygon = $area->asPolygon(0.2); };
    my $i = 0;
    while ( $i < scalar(@polygon) ) {
        $jscript .= '    pts.push(new GLatLng('
            . join( ', ', $polygon[$i]->ll() ) . "));\n";
        $i++;
    }
    $jscript .= '    return pts;
}
function change_loc(pre) {
    var prefix = parseInt(pre, 10);
    var i = document.getElementById(prefix + "description").selectedIndex;
    if (i < 0) { i = 0; }
    document.getElementById(prefix + "street").value=streets[i * max + prefix];
    document.getElementById(prefix + "nr").value=nrs[i * max + prefix];
    document.getElementById(prefix + "city").value=citys[i * max + prefix];
    document.getElementById(prefix + "zip").value=zips[i * max + prefix]; 
    document.getElementById(prefix + "state").value=states[i * max + prefix];        
    document.getElementById(prefix + "x").value = xs[i * max + prefix];
    document.getElementById(prefix + "y").value = ys[i * max + prefix];
    document.getElementById(prefix + "id").value = ids[i * max + prefix];
    maps[prefix].clearOverlays();        
    maps[prefix].addOverlay(area[prefix]);
    var pt = new GLatLng(xs[i * max + prefix], ys[i * max + prefix]);
    maps[prefix].addOverlay(new GMarker(pt));
    maps[prefix].panTo(pt);
}
function test () {
  document.getElementById("2name").value = "test";
}
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
	document.getElementById("1id").value=arguments[1]; 
	hinzu(document.getElementById("0id"), arguments[2], arguments[2]);
	document.getElementById("0id").value=arguments[2]; 
	document.getElementById("start_time").value=arguments[3]; 
	document.getElementById("arrival_time").value=arguments[4]; 
	document.getElementById("timeAccuracy").value=arguments[5]; 
	document.getElementById("seats").value=arguments[6]; 
	document.getElementById("fee").value=arguments[7]; 
	document.getElementById("driver_id").value=arguments[8];
	get_person([\'driver_id\'], [change_driver]);
	change_map0([\'0id\'], [set_geodata] );
	change_map1([\'1id\'], [set_geodata] );
}
function change_driver() {
  document.getElementById("2id").value=arguments[11];
  document.getElementById("driver_added").value=arguments[11];
  document.getElementById("2driver_id").value=arguments[0];
  document.getElementById("2password").value=arguments[1];
  document.getElementById("2surname").value=arguments[2];
  document.getElementById("2prename").value=arguments[3];
  document.getElementById("2cellular").value=arguments[4];
  document.getElementById("2msisdn").value=arguments[5];
  document.getElementById("2bday").value=arguments[6];
  document.getElementById("2type").value=arguments[7];
  document.getElementById("2kto_name").value=arguments[8];
  document.getElementById("2blz").value=arguments[9];
  document.getElementById("2kto_nr").value=arguments[10];
  change_map2([\'2id\'], [set_geodata] );
}
function set_geodata() {
   var prefix = parseInt(arguments[0], 10);
   document.getElementById("debug").value="debug1: " + prefix + "; debug2: " + arguments[0];
   var liste = document.getElementById(prefix + "description");
   liste.value=null;
   var i = liste.length;
   while ( i > 0 ) {
     i--;
     liste.options[i]=null;
     liste.remove(i);
   }
   while (arguments.length > i * ds + ds){
     hinzu(liste, arguments[i * ds + 1], arguments[i * ds + 1]);
     streets[i * max + prefix]=arguments[i * ds + 2];
     nrs[i * max + prefix]=arguments[i * ds + 3];      
     citys[i * max + prefix]=arguments[i * ds + 4];      
     zips[i * max + prefix]=arguments[i * ds + 5];      
     xs[i * max + prefix]=arguments[i * ds + 6];      
     ys[i * max + prefix]=arguments[i * ds + 7];      
     states[i * max + prefix]=arguments[i * ds + 8];
     ids[i * max + prefix]=arguments[i * ds + 9];
     i++;
   }
   change_loc(prefix);
}
function load() {
  if (GBrowserIsCompatible()) {
    var pt = new GLatLng(' . join( ', ', $centerpt->ll() ) . ');
';
    $jscript .= jscript_addmap( 0, $centerpt );
    $jscript .= jscript_addmap( 1, $centerpt );
    $jscript .= jscript_addmap( 2, $centerpt );
    $jscript .= '  }
}';

}

sub jscript_addmap {
    my $p        = shift;    # $p = $prefix!!
    my $centerpt = shift;
    return '    maps[' . $p
        . '] = new GMap2(document.getElementById("map'
        . $p . '"));
    maps[' . $p . '].addControl(new GLargeMapControl());
    maps[' . $p . '].addControl(new GMapTypeControl());
    maps[' . $p . '].setCenter(pt, 12);
    maps[' . $p . '].addOverlay(new GMarker(pt));
    area[' . $p . '] = new GPolyline(getArea());
    maps[' . $p . '].addOverlay(area[' . $p . ']);
    GEvent.addListener(maps[' . $p . '], "click", function(marker, point) {
      if (! marker){
        maps[' . $p . '].clearOverlays();
        maps[' . $p . '].addOverlay(area[' . $p . ']);
        maps[' . $p . '].addOverlay(new GMarker(point));
        maps[' . $p . '].panTo(point);
        document.getElementById("' . $p . 'x").value = point.y;
        document.getElementById("' . $p . 'y").value = point.x;
      }
    });
';

}
