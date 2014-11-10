#!/usr/bin/perl

use warnings;
use strict;
use Carp;

use Mofa::View;
use Mofa::Model::Person;
use Mofa::Model::MeetingPt;
use Mofa::Model::Request; 
use Mofa::Model::Offer;
use Mofa::Controller;
use Mofa::Model::Address;
use Mofa::Model::CircularArea;



my ($time,$timeAccuracy) = get_time();
my $start = get_point('start');
my $destination = get_point('destination');

##  suche passende Mitfahrgelegenheiten:
if (myparam('type') eq 'offer') {
    if ( not defined( $session->param('login') )
        or $session->param('login') eq '' )
    {
        display_err('Sie müssen sich einloggen');
        exit;
    }
    my $offer = Mofa::Model::Offer->new(
        {   start       => $start,
            destination => $destination,
            provider   => $session->param('login'),
            startTime   => $time,
            seats   => 1,
            fee   => 10,
            timeAccuracy => $timeAccuracy
        }  
    );
    $offer->add();
    my @mapped = Mofa::Controller::mapping_lift($offer);
    display_msg('Gespeichert', 'Sie erhalten eine SMS sobald ein passendes Gesuch eingetragen wird.');
}
else {
    my $request = Mofa::Model::Request->new(
        {   start       => $start,
            destination => $destination,
            requester   => $session->param('login'),
            startTime   => $time,
            timeAccuracy => $timeAccuracy
        }
    );

    my @mapped = Mofa::Controller::mapping_search($request);
    if ( not defined( $session->param('login') )
        or $session->param('login') eq '' )
    {
        $session->param( 'open_search_time',  myparam('time') );
        $session->param( 'open_search_start', $start->id() );
        $session->param( 'open_search_destination',  $destination->id() );
        Mofa::View::display_search_result(@mapped); 
    }
    else {
        $request->add();
        my @sent_sms;
    LIFT:
        foreach my $mapped (@mapped) {
    
        #Speichern
            if ( $mapped->add() < 0 ) {
                next LIFT;
            } # Falls vorher schon so eine Request zu dieser Offer gemappt wurde, keine Sms senden.
            my $offer = $mapped->offer();

#Eine Session-ID erzeugen mit der sich der Fahrer über den Link in der SMS anmelden kann.
            my $confirm_session
                = CGI::Session->new( CGI::Session::ID::md5->generate_id() );
            $confirm_session->param( 'login',        $offer->providerId() );
            $confirm_session->param( 'requester_id', $session->param('login') );
            $confirm_session->param( 'offer_id',     $offer->id() );

            #SMS-Nachricht erzeugen.
            my $msg = $session->param('login')
                . ' sucht MFG von '
                . $start->description()
                . ' nach '
                . $destination->description()
                . '. Umweg: '
                . $mapped->detour() . 'km/'
                . $mapped->addtime() . 'min';
            my $url = 'http://trip261.wohnheim.uni-kl.de/Mofa/accept.pl?'
                . $confirm_session->name() . '='
                . $confirm_session->id();
            my $sms = Mofa::Controller::send_push_sms(
                eval { $offer->provider()->cellular() },
                $msg, $url );
            push( @sent_sms, $sms );
        }

        display_msg(
            'Anfrage gesendet!',
            scalar(@sent_sms)
            . " Fahrer fuer Mitfahrgelegenheiten von "
            . $start->description()
            . " nach "
            . $destination->description()
            . " wurden ueber ihre Anfrage informiert!",
            " Sie erhalten eine Nachricht, sobald sie jemand mitnehmen moechte.",
            @sent_sms
        );
    }
}

sub get_time {
    my $time = myparam('time');

    if ((not defined($time)) or $time eq '') {
        if ( 
             defined( $session->param('login') ) 
             and $session->param('login') ne '' 
             and defined($session->param('open_search_time'))
             and $session->param('open_search_time') ne ''
        ) { $time = $session->param('open_search_time');
        } else {
            Mofa::View::display_enter_time();
            exit;
        }
    }

##HASH ordnet Werten zu: UHRZEIT (in std., absolut), TAG (relativ in tagen), GENAUIGKEIT (plus oder minus in std)
my %times = ( 
 'jetzt'=>[-1,0,0.5],
 'heute'=>[0,0,24],
 'morgen'=>[0,1,24],
 'frueh'=>[7.5,0,2],
 'vormittag'=>[10.5,0,2],
 'mittag'=>[13.5,0,2],
 'nachmittag'=>[16.5,0,2],
 'abend'=>[19.5,0,2],
 'nacht'=>[1.5,1,5],
);
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime();
my ($addhour, $addday, $precision) = @{$times{$time}};
my $tis = time() +  -$sec - $min*60 - $hour*3600 + $addhour*3600 + $addday*3600*24;
if ($addhour < 0 ) {
 $tis = time() + $addday*3600*24;
} 

return ($tis, $precision);
}

sub get_point {
    my ($what) = @_;
    my $point = myparam($what);

    if ((not defined($point)) or $point eq'') {
        return $session->param("open_search_$what") if ( 
             defined( $session->param('login') ) 
             and $session->param('login') ne '' 
             and defined($session->param("open_search_$what"))
             and $session->param("open_search_$what") ne ''
        );
        my @nearloc;
        my @oldloc;
        my $login = $session->param('login');
        if (defined($login) and not $login eq '') {
            ## Falls er sofort loswill kommen fuer den Startort Punkte in der Umgebund in Frage
            if (myparam('time') eq 'jetzt' and $what eq 'start') {
                my $person = Mofa::Model::Person->get($login);
                @nearloc = Mofa::Model::MeetingPt->get_points_in_area(
                    Mofa::Controller::get_position(
                        '4888'
                    )
                );
            }
            my @lifts = Mofa::Model::Request->get_by_requester($login);
            push(@lifts, Mofa::Model::Offer->get_by_provider($login));
            my %locations;
        
            ## Berechne eine Bewertung (SortierungsSchlüssel) für jeden Start/Ziel-Ort
            foreach my $lift ( @lifts ) {
                my ($lifsec,$lifmin,$lifhour) = gmtime($lift->startTime());
                my ($nowsec,$nowmin,$nowhour) = gmtime();
                #$nowhour += $time;
                my $timediff = ($lifmin * 60 + $lifhour) - ($nowmin * 60 + $nowhour);
                if ($timediff > 120) {$timediff = 120;}
                else {
                    if ($timediff < 10) {$timediff = '0' . $timediff};
                    if ($timediff < 100) {$timediff = '0' . $timediff};
                }
                if ($what eq 'start') {
                    ## Beim Startort bevorzuge Orte von denen er um die
                    ## Uhrzeit schonmal losgefahren ist, dann die letzten
                    ## Startorte sortiert nach Alter, dann die letzten Zielorte..
                    my $sortkey = 's'. $timediff . $lift->startTime();
                    my $oldkey = $locations{$lift->startId()};  
                    if (not defined ($oldkey) or  $oldkey gt $sortkey) { 
                        $locations{$lift->startId()} = $sortkey;
                    }
                    $sortkey = 'z120' . $lift->startTime();
                    $oldkey = $locations{$lift->destinationId()};  
                    if (not defined ($oldkey) or  $oldkey gt $sortkey) { 
                        $locations{$lift->destinationId()} = $sortkey;
                    }
                } elsif ($what eq 'destination') {
                    ## Beim Zielort bevorzuge Orte an die er um die 
                    ## Uhrzeit schonmal von diesem Ort gefahren ist, dann die
                    ## Orte an die er allegmein um die Uhrzeit gefahren ist, 
                    ## dann die letzten Zielorte sortiet nach Alter, 
                    ## dann die letzten Startorte
                    my $sortkey = 'b';
                    if ($lift->startId() == $start->id()) {$sortkey='a';}
                    $sortkey .= $timediff . $lift->startTime();
                    my $oldkey = $locations{$lift->destinationId()};  
                    if (not defined ($oldkey) or  $oldkey gt $sortkey) { 
                        $locations{$lift->destinationId()} = $sortkey;
                    }
                    $sortkey = 'z120' . $lift->startTime();
                    $oldkey = $locations{$lift->startId()};  
                    if (not defined ($oldkey) or  $oldkey gt $sortkey) { 
                        $locations{$lift->startId()} = $sortkey;
                    }
                } else {
                    croak "Typ des Punktes der eingegeben werden soll ist $what,"
                         ." sollte aber 'start' oder 'destination' sein.";
                }
            }
            ## Sortiere die gefundenen Start/Zielorte nach der Bewertung und
            ## fuege sie zur Liste der Orte hinzu.
            my @unsrtloc;
            foreach my $locid (keys(%locations)) {
               push(@unsrtloc,  Mofa::Model::MeetingPt->get($locid));
            }
            @oldloc = sort {$locations{$a->id()} cmp $locations{$b->id()}} @unsrtloc;
        }
        Mofa::View::display_enter_point($what,\@nearloc, \@oldloc, []);
        exit;
    }

    my $ptobj = eval {Mofa::Model::MeetingPt->get($point);};

    if ($@ or not defined($ptobj)) {
        my $ptobj = eval {Mofa::Model::Address->get($point);};
        if ($@ or not defined($ptobj)) {
            ## $start ist offensichtlich keine gültige ID! Also versuchen wirs mit Geocoden
            #print "content-type:text/plain\n\nvorm geocoden\n";
            my @geoloc = Mofa::Controller::geocode($point.'+de');
            #print "nachm geocoden\n";
            Mofa::View::display_enter_point($what, [], [], \@geoloc);
            #print "nachm display enter pont\n";
            exit;
        }
        ## $start ist eine gültige ID, aber nicht von einem Treffpunkt.
        ## Suche also Liste von Treffpunkten in der Umgebung. Falls keine gefunden
        ## werden, fuege diesen Punkt als Treffpunkt hinzu. Sonst lasse auswaehlen.
    
        my @nearloc = Mofa::Model::MeetingPt->get_points_in_area( 
            Mofa::Model::CircularArea->newcircle($ptobj, 600)
        );
        Mofa::View::display_enter_point($what, \@nearloc, [], []);
        exit;
    }
    return $ptobj;
}

