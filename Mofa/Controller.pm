package Mofa::Controller;

=head1 Mofa::Controller

Modul zum Zugriff auf Dienste f�r die Mitfahrzentrale

=head2 Beschreibung

Dieses Modul beeinhaltet den Vermittlungsdienst, sowie weitere Funktionen, 
mit welchen auf den externe Dienste zugegriffen werden kann.

=head2 Vermittlung zwischen Mitfahrgelegenheiten und Gesuchen

=head4 C<@ mapping_lift($)>

I<Parameter:> C<Offer>-Objekt

I<R�ckgabewert:> sortierte Liste von C<Mapped>-Objekten

Findet passende Gesuche in der Datenbank und berechnet die Umwege, die 
der Anbieter machen m�sste, um diese Mitfahrgelegenheiten durchzuf�hren.

=head4 C<@ mapping_search($)>

I<Parameter:> C<Request>-Objekt

I<R�ckgabewert:> sortierte Liste von C<Mapped>-Objekten

Findet passende Angebote in der Datenbank und berechnet die Umwege, die
die Anbieter machen m�ssten, um diese Mitfahrgelegenheit durchzuf�hren.

=head2 Geocoding

=head4 C<$ geocode(@)>

I<Parameter:> Adressbeschreibung C<(string,..)>

I<R�ckgabewert:> C<Geocode>-Objekt

Konstruiert eine Geocode-Anfrage, und vervollst�ndigt die Adresse mit Koordinaten
mit Hilfe der Datenbank oder eines externen Geocodingdienstes

=head2 Handy-Lokalisierung

=head4 C<$ get_position($)>

I<Parameter:> Handy-Nummer (C<string>)

I<R�ckgabewert:>  C<Area>-Objekt

Fragt das Gebiet, in dem das Handy sich befinden kann, beim Lokalisierungsdienst ab.

=head2 SMS-Versand

=head4 C<$ send_push_sms($$$)>

I<Parameter:> Handy-Nr (C<string>), Nachricht (C<string>), URL (C<string>)

I<R�ckgabewert:> C<string> mit Antwort des SMS-Servicecenters

Versendet eine WAP-Push-SMS mit der Nachricht und dem Link an die Handynummer. 

=head2 Entfernungsbestimmung (Routenplanung)

=head4 C<($$) street_dist($$)>

I<Parameter:> 2 C<Point>-Objekte

R�ckgabewerte: ( Strassenentfernung in Km (C<float>), 
                     Fahrtzeit in Minuten (C<int>)

Die Entfernung wird im Cache nachgeschlagen, falls dies fehlschl�gt bei 
Internet-Services erfragt und falls dies fehlschlaegt wird die Luftlinien-Entfernung 
zurueckgegeben. Daher ist der Wert fuer Entfernung auf jeden Fall definiert, der Wert 
fuer Zeit nicht immer.

=head2 Kartenbilder

=head4 C<$ get_map_img($@)>

I<Parameter:> C<Point>-Objekt, [Radius (C<int>),  [H�he (C<int>), Breite (C<int>)]]

I<R�ckgabewert:> URL zu einem png-Bild einer Karte (C<string>)

Fragt die URL zur Karte mit dem angegebenem Mittelpunkt, die ein Gebiet
mit dem angegebenem Radius (in Kilometern) zeigt, beim Yahoo-Mapimagedienst an. 
Mit den Paramtern H�he und Breite kann die Gr��e des Bildes in Pixeln festgelegt werden.

=cut

use lib('..');
use strict;
use warnings;
use Carp;

use LWP;
use LWP::UserAgent;
use Math::Trig;
use XML::Simple;
use URI::Escape;

use Mofa::Model::CircularArea;
use Mofa::Model::GeocodedPt;
use Mofa::Model::Geocode;
use Mofa::Model::Offer;
use Mofa::Model::Request;
use Mofa::Model::Mapped;
#use Mofa::Model::Visits;
#use Mofa::Model::Mark;
use Mofa::Model::Distance;

use Exporter;

## key f�r localhost
$Mofa::Controller::key
    = 'ABQIAAAADKESdQoREWw_2dhk0j-n4hT2yXp_ZAY8_ufC3CFXhHIE1NvwkxTiCy1mG2PECogLJJed2LUC_3coYA';
## key f�r rhrk.uni-kl.de/~jostock/MoFa
#$Mofa::Controller::key = 'ABQIAAAADKESdQoREWw_2dhk0j-n4hQGfgGqDL-O3W4rmjFlRYgBRY9hlRSgOCjho1GgWAfvWhM0ZnWFLtfFnA';
#$Mofa::Controller::pos_server = 'http://bandit.informatik.uni-kl.de:10035/newRequest';
$Mofa::Controller::pos_server = 'http://localhost:10035/newRequest';

our ($pip180) = pi() / 180;
our (@ISA)    = qw(Exporter);
our (@EXPORT)
    = qw(get_position add_meeting_point $pip180 geocode get_meeting_point);

sub get_position {
    my $msisdn = 4888;
    if (@_) { $msisdn = shift(); }

 # Mit der World-Wide Web Library (LWP) lassen sich Http-Anfragen verschicken.
 # Um den Positionierungsserver abzufragen, muss man eine Http-Anfrage
 # mit Login und MSISDN des Handy in XML codiert an ihn �bermitteln.
 # Verwendet wird das Mobile Location Protocol (MLP) 3.00
    my $http_ua = LWP::UserAgent->new;
    $http_ua->agent("MoFa/0.1 ");

# Erzeuge eine neue POST-Anfrage mit den xml-Daten entsprechend dem MLP-Protokoll
    my $http_req
        = HTTP::Request->new( POST => $Mofa::Controller::pos_server );
    $http_req->content_type('text/xml');
    $http_req->content(
        '<?xml version="1.0"?> <!DOCTYPE svc_init SYSTEM "MLP_SVC_INIT_300.DTD">
    <svc_init ver="3.0.0"> <hdr ver="3.0.0">
       <client>  <id>aUser</id>  <pwd>aPwd</pwd>  </client> </hdr>
    <slir ver="3.0.0">
       <geo_info> <CoordinateReferenceSystem> <Identifier>
          <code>4326</code> <codeSpace>epsg</codeSpace> <edition>6.2.2</edition>
       </Identifier> </CoordinateReferenceSystem> </geo_info>
       <msids> <msid>' . $msisdn . '</msid> </msids>
    </slir> </svc_init>'
        )
        ; #GeoCode fuer UTM: 32614,  Code fuer LAT/LONG: 4326, Emulator kann nur Lat/Long

    # �bermittle die Anfrage mit Hilfe des User-Agent-Objekt
    my $http_res = $http_ua->request($http_req);

    # Eine Antwort auf eine erfolgreiche Anfrage:
    #	<svc_result ver="3.0.0">	<slia ver="3.0.0">
    #		<pos>
    #			<msid type="MSISDN" enc="ASC">4888</msid>
    #			<pd>
    #				<time utc_off="+0200">20060820144234</time>
    #				<shape>	<CircularArcArea srsName="www.epsg.org#4326">
    #					<coord>  <X>48 11 49N</X> <Y>16 15 25E</Y> </coord>
    #					<inRadius>0</inRadius>  <outRadius>532</outRadius>
    #					<startAngle>270</startAngle>  <stopAngle>120</stopAngle>
    #				</CircularArcArea>	</shape>
    #			</pd>
    #		</pos>
    #	</slia>	</svc_result>

    if ( not $http_res->is_success ) {
        croak
            "Positionsbestimmung fehlgeschlagen: Http-Request fehlerhaft oder Server nicht erreichbar.";
    }

# Die Klasse XML::Simple liefert eine Hashreferenz von Hash-Referenzen von Hash-Referenzen
# ACHTUNG: Falls mehrere gleiche Schl�ssel nebeneinander existieren:
# <xml><data><attr>blubb</attr><attr>bla</attr></data>
# liefert es ein ARRAY!!: { data => {attr=>[blubb, bla] } }, da kein Hash mit mehreren gleichen Schl�sseln m�glich!
    my $ans = XMLin( $http_res->content );

    my $area = eval(
        'return $ans->{slia}->{pos}->{pd}->{shape}->{CircularArcArea} ');
    if ( not defined($area) ) {
        croak
            "Positionsbestimmung fehlgeschlagen: Antwort des Positionierungsserver enthaelt keine CircularArcArea.";
    }
    $area->{ans} = XMLout($ans);
    return Mofa::Model::CircularArea->new($area);
}

sub get_map_img {
    my ( $x, $y, $rad, $width, $height ) = @_;
    my $query
        = "http://api.local.yahoo.com/MapsService/V1/mapImage?appid=flojomofa&"
        . "latitude=$x&"
        . "longitude=$y&"
        . "radius=$rad&"
        . "image_height=$height&"
        . "image_width=$width";
    my $http_ua = LWP::UserAgent->new;
    $http_ua->agent("MoFa/0.1 ");
    my $http_req = HTTP::Request->new( GET => $query );
    my $http_res = $http_ua->request($http_req);
    if ( not $http_res->is_success ) {
        croak
            "get_map_img: Konnte keine URL fuer das Bild der Karte von Yahoo erhalten.";
    }
    my $ans = XMLin( $http_res->content() );
    return eval { $ans->{'content'} };
}

sub send_push_sms($$$) {
    my ( $nr, $msg, $url ) = @_;
    my $http_ua = LWP::UserAgent->new;
    $http_ua->agent("MoFa/0.1 ");
    my $http_req = HTTP::Request->new(
        POST => 'http://soap.smscreator.de/send.asmx/WapPush' );
    $http_req->content_type('application/x-www-form-urlencoded');
    $http_req->content(
        'User=FLSMSC18570499&Password=4TT3PF&Recipient=' . $nr . '&Text='
            . $msg . '&Url='
            . uri_escape($url)
            . '&sendDate=' );

    return "SMS waere an  $nr  verschickt worden:  <a href=\"$url\">$msg</a>";

    my $http_res = $http_ua->request($http_req);
    if ( not $http_res->is_success ) {
        croak "SMS konnte nicht verschickt werden: <a href=\"$url\">$msg</a>";
    }
    my $ans = XMLin( $http_res->content );
    return eval { $ans->{'content'} };
}

sub geocode(@) {
    my @arg;
my %abbr = qw(
BW Baden-Wuerttemberg 
bw Baden-Wuerttemberg 
Bw Baden-Wuerttemberg 
BY Bayern
By Bayern
by Bayern
BE Berlin
be Berlin
Be Berlin
BR Brandenburg
Br Brandenburg
br Brandenburg
HB Bremen
hb Bremen
Hb Bremen
HH Hamburg
Hh Hamburg
hh Hamburg
HE Hessen
he Hessen
He Hessen
MV Mecklenburg-Vorpommern
Mv Mecklenburg-Vorpommern
mv Mecklenburg-Vorpommern
NI Niedersachsen
ni Niedersachsen
Ni Niedersachsen
NW Nordrhein-Westfalen
Nw Nordrhein-Westfalen
nw Nordrhein-Westfalen
nrw Nordrhein-Westfalen
Nrw Nordrhein-Westfalen
NRW Nordrhein-Westfalen
RP Rheinland-Pfalz
Rp Rheinland-Pfalz
rp Rheinland-Pfalz
RLP Rheinland-Pfalz
Rlp Rheinland-Pfalz
rlp Rheinland-Pfalz
SL Saarland
sl Saarland
Sl Saarland
SN Sachsen
Sn Sachsen
sn Sachsen
ST Sachsen-Anhalt
St Sachsen-Anhalt
st Sachsen-Anhalt
SH Schleswig-Holstein
sh Schleswig-Holstein
Sh Schleswig-Holstein
TH Thueringen
Th Thueringen
th Thueringen
);          
    foreach my $x (@_) {
        foreach my $y (split /\s|\+|\,/, $x) {
            if (defined($abbr{$y})) {push @arg, $abbr{$y};}
            else {push @arg, $y;}
        }
        
    }
    my $arg = join( '+', @arg );
    $arg =~ s/(\++)|(\s+)/+/g;
    $arg =~ s/(^\+*)|(\+*$)//g;

    #$arg =~ s/(\+[Dd][Ee]$)|(\+[Dd][Ee]\+)//;
    my @list_of_GeocodedPt;
##	my @regions = qw(Rheinland-Pfalz Baden-W�rttemberg Bayern Berlin Brandenburg Bremen Hamburg Hessen Mecklenburg-Vorpommern Niedersachsen Nordrhein-Westfalen Saarland Sachsen Sachsen-Anhalt Schleswig-Holstein Th�ringen);
## 	foreach my $region(@regions){

    # Schaue zunaechst im Anfragen-Cache nach
    my $geocode = eval { Mofa::Model::Geocode->get($arg); };
    
    if ( defined($geocode) ) {
        push( @list_of_GeocodedPt, $geocode->points() );
    }
    else {

        #falls Anfrage nicht im Cache, benutze Geocode-Dienst(e)
        $geocode = Mofa::Model::Geocode->new($arg);
        geocode_google($geocode);
        $geocode->add();
   }

##	} #foreach @region
    return $geocode->points();
}

sub geocode_google($) {
    my ($geocode) = @_;
    my $query = 'http://maps.google.com/maps/geo?q='
        . uri_escape( $geocode->query() )
        . '&output=xml&key='
        . $Mofa::Controller::key;
        
    my $http_ua = LWP::UserAgent->new;
    $http_ua->agent("MoFa/0.1 ");
    my $http_req = HTTP::Request->new( GET => $query );
    my $http_res = $http_ua->request($http_req);
    if ( not $http_res->is_success ) {
        croak(
            "Geocode-Anfrage fehlgeschlagen: Http-Request fehlerhaft oder Server nicht erreichbar."
        );
    }
    my $content = $http_res->content;
    
    #Mieser Workaround fuer Perls Umlaut-Probleme
    $content =~ s/�/Ae/g;
    $content =~ s/�/ae/g;
    $content =~ s/�/Oe/g;
    $content =~ s/�/oe/g;
    $content =~ s/�/Ue/g;
    $content =~ s/�/ue/g;
    $content =~ s/�/ss/g;
    my $ans = eval { XMLin( $content, ForceArray => ['Placemark'], KeyAttr => [] ); };
    my ( @places, @ids, @accuracys );
    eval { @places = @{ $ans->{Response}->{Placemark} }; };
    
    foreach my $place (@places) {
        my %a;
        eval { $a{accuracy} = $place->{AddressDetails}->{Accuracy}; };
        eval {
            $a{description} = $place->{address};
            $a{description} =~ s/(,\s)?.ermany//;
        };
        eval {
            $a{state}
                = $place->{AddressDetails}->{Country}->{CountryNameCode};
        };
        eval {
            $place->{Point}->{coordinates}
                =~ m/([-0-9.]+),([-0-9.]+),([-0-9.]+)/;
            $a{x} = $2;
            $a{y} = $1;
        };
        my $loc = undef;
        eval {
            $a{region}
                = $place->{AddressDetails}->{Country}->{AdministrativeArea}
                ->{AdministrativeAreaName};
        };
        eval {
            $a{district}
                = $place->{AddressDetails}->{Country}->{AdministrativeArea}
                ->{SubAdministrativeArea}->{SubAdministrativeAreaName};
        };
        eval {
            $loc = $place->{AddressDetails}->{Country}->{AdministrativeArea}
                ->{SubAdministrativeArea}->{Locality};
        };
        if ( not defined($loc) ) {
            eval { $loc = $place->{AddressDetails}->{Country}->{Locality}; };
        }
        eval { $a{street} = $loc->{Thoroughfare}->{ThoroughfareName}; };
        eval { $a{zip}    = $loc->{PostalCode}->{PostalCodeNumber}; };
        eval { $a{city}   = $loc->{LocalityName}; };
        if ( defined( $a{street} ) ) {
            $a{street} =~ s/\s([0-9]{1,4})$//;
            $a{nr} = $1;
        }
        ## DEBUG
        $a{ans} = eval { XMLout($ans) . "\n\n" . $query; };
        $geocode->push( Mofa::Model::GeocodedPt->new( \%a ) );
    }    #foreach @places
}

sub str2points {
    my ($string) = @_;
    my ($id) = $string =~ m/^(\d\d*)$/;
    if ( not defined($id) ) {
        return Mofa::Controller::geocode( $string . '+de' );
    }
    return Mofa::Model::Address->get($id);
}

sub mapping_lift(%) {

}

sub calc_box($@) {

    #this function calculates a box around a lift.
    my ( $lift, $space ) = @_;
    if ( not defined($space) ) { $space = 1000; }
    my ( $start, $dest ) = ( $lift->start(), $lift->destination() );
    my ( $x1,    $y1 )   = $start->utm();
    my ( $x2,    $y2 )   = $dest->utm();
    my ( $min_x, $max_x ) = ( $x1 > $x2 ) ? ( $x2, $x1 ) : ( $x1, $x2 );
    my ( $min_y, $max_y ) = ( $y1 > $y2 ) ? ( $y2, $y1 ) : ( $y1, $y2 );
    return ( $min_x - $space, $min_y - $space, $max_x + $space,
        $max_y + $space );
}

sub mapping_search($) {
    my ($request) = @_;
    my ( $mystart, $mydest ) = ( $request->start(), $request->destination() );

#Filter step: get all lifts from database, that pass close by the search
#define Box around search with calc_box and get entrys that probably touch this box.
    my @touch = Mofa::Model::Offer->get_touching( calc_box($request) );

#Calculate detour for each offer if the provider with take this requester with him
    my @mapped;
    foreach my $offer (@touch) {
        my $start = $offer->start();
        my $dest  = $offer->destination();
        my ( $detour, $addtime ) = detour( $start, $mystart, $mydest, $dest );
        push(
            @mapped,
            Mofa::Model::Mapped->new(
                {   offer   => $offer,
                    request => $request,
                    detour  => $detour,
                    addtime => $addtime
                }
            )
        );
    }
    return @mapped;
}

sub detour($$$$) {
    my ( $start, $mystart, $mydest, $dest ) = @_;
    my ( $dist1, $time1 ) = dist( $start,   $mystart );
    my ( $dist2, $time2 ) = dist( $mystart, $mydest );
    my ( $dist3, $time3 ) = dist( $mydest,  $dest );
    my ( $dist4, $time4 ) = dist( $start,   $dest );
    my $dist = $dist1 + $dist2 + $dist3 - $dist4;
    my $time;
    if (    defined($time1)
        and defined($time2)
        and defined($time3)
        and defined($time4) )
    {
        $time = $time1 + $time2 + $time3 - $time4;
    }
    return ( $dist, $time );
}

sub dist($$) { return street_dist(@_); }

sub air_dist($$) {
    my ( $ax, $ay ) = $_[0]->utm();
    my ( $bx, $by ) = $_[1]->utm();

    return (
        int((   sqrt(
                    ( ( $bx - $ax ) * ( $bx - $ax ) )
                    + ( ( $by - $ay ) * ( $by - $ay ) )
                )
            ) / 10
        )
    ) / 100;
}



sub street_dist($$) {
    my ( $start, $dest ) = @_;
    my ( $dist, $time, $query );
    my ( $sid, $did ) = ( $start->id(), $dest->id() );
    if ( defined($sid) and defined($did) and $sid ne '' and $did ne '' ) {
        ( $dist, $time ) = eval{Mofa::Model::Distance->get( $sid, $did )};
        if ( not defined($dist) or not defined($time) ) {
            ( $dist, $time, $query ) = street_dist_mapquest( $start, $dest );
            if ( defined($dist) ) {
                Mofa::Model::Distance->add( $sid, $did, $dist, $time );
            }
        }
    }
    else {
        ( $dist, $time, $query )
            = eval { street_dist_mapquest( $start, $dest ); };
    }
    if ( not defined($dist) ) {
        $dist = air_dist( $start, $dest );
        $query = "Luftlinie!";
    }
    return ( $dist, $time, $query );
}

sub street_dist_mapquest($$) {
    my ( $start, $dest ) = @_;
    my $air = air_dist( $start, $dest );
    if ( $air < 0.2 ) { return ( $air, $air, "Direkt um die Ecke" ); }
    my $http_ua = LWP::UserAgent->new;
    $http_ua->agent("MoFa/0.1 ");

# Erzeuge eine neue POST-Anfrage mit den xml-Daten entsprechend dem MLP-Protokoll
    my $query = 'http://mapquest.de/mq/directions/directions.do' . '?'
        . join( '&',
        'pageId=ADR_ADR',
        'cursorPostion=',
        'resutId=',
        'region=EU',
        'searchKey=',
        'key=',
        'startCountrykey=',
        'hdnLangKey=',
        'hdnStartRegion=',
        'hdnEndRegion=',
        'hdnChanged=',
        'mapRefresh=',
        'endError1=Error_Multiple_Loc_Dir_pre',
        'endError2=Error_Multiple_Loc_Dir_suf',
        'endErrorAdd=endErrorAdd',
        'endAmbiguous=city',
        'hdnAddtohistory=',
        'endAddress=',
        'endCity=0',
        'endAmbSize=2',
        'endAmb0=EU!!!'
            . join( ':', $dest->ll() )
            . '!!!!!!!!!!!!!!!Ziel!!!DE!!!2',
        'endCountry=DE',
        'endAmb1=EU!!!49.176929:8.14638!!!!!!!!!!!!!!!67002!!!DE!!!2',
        'startError1=Error_Multiple_Loc_Dir_pre',
        'startError2=Error_Multiple_Loc_Dir_suf',
        'startErrorAdd=startErrorAdd',
        'stAmbiguous=city',
        'startAddress=',
        'startCity=0',
        'startAmb0=EU!!!'
            . join( ':', $start->ll() )
            . '!!!!!!!!!!!!!!!Start!!!DE!!!2',
        'startCountry=DE',
        'startAmb1=EU!!!49.476929:8.44638!!!!!!!!!!!!!!!67002!!!DE!!!2',
        'startAmbSize=2' );
    my $http_req = HTTP::Request->new( GET => $query );
    my $http_res = $http_ua->request($http_req);
    if ( not $http_res->is_success ) {
        croak(
            "Entfernungsbestimmung durch Routenplanungsdienst von Mapquest fehlgeschlagen: Http-Request fehlerhaft oder Server nicht erreichbar."
        );
    }
    my ($dist)
        = $http_res->content()
        =~ m/.*Entfernung[^\d]*([\d,]*)[^\d]*Kilometer.*/;
    my ( $stunden, $minuten )
        = $http_res->content()
        =~ m/.*zte.Fahrtdauer[^\d]*([\d]*)[^\d]*Stunden[^\d]*([\d]*)[^\d]*Minuten.*/;
    if ( not( defined($minuten) ) ) {
        $stunden = 0;
        ($minuten)
            = $http_res->content()
            =~ m/.*zte.Fahrtdauer[^\d]*([\d,]*)[^\d]*Minuten.*/;
    }
    my $time = undef;
    if ( not defined($stunden) ) { $stunden = 0; }
    if ( defined($minuten) ) {
        $time = $stunden * 60 + $minuten;
    }
    if ( defined($dist) ) { $dist =~ s/\,/\./; }
    return ( $dist, $time, $query );
}

## Diese Methode wird derzeit nicht gewartet!!
#sub street_dist_by_Address ($$) {
#	my ($start, $dest) = @_;
#	my $http_ua = LWP::UserAgent->new;
#	$http_ua->agent("MoFa/0.1 ");
#	# Erzeuge eine neue POST-Anfrage mit den xml-Daten entsprechend dem MLP-Protokoll
#	my $query = 'http://mapquest.de/mq/directions/directions.do' . '?' .
#			join('&',
#				'pageId=ADR_ADR','cursorPostion=','resultId=','region=EU', 'searchKey=',
#				'key=','startCountrykey=','hdnLangKey','hdnStartRegion=','hdnEndRegion=',
#				'hdnChanged=','mapRefresh=','addressCookies=','hdnAddtohistory=',
#				"startCountry=".uri_escape($start->{state}),
#				"startAddress=".uri_escape($start->{street}.' '.$start->{nr}),
#				"startCity=".uri_escape($start->{city}),
#				"startPostCode=".uri_escape($start->{zip}),
#				"endCountry=".uri_escape($dest->{state}),
#				"endAddress=".uri_escape($dest->{street}.' '.$dest->{nr}),
#				"endCity=".uri_escape($dest->{city}),
#				"endPostCode=".uri_escape($dest->{zip})
#			);
#	my $http_req = HTTP::Request->new(GET => $query);
#	my $http_res = $http_ua->request($http_req);
#
#	return "$query\n\n".$http_res->content();
#}


1;
