#!/usr/bin/perl

use warnings;
use strict;
use Carp;

use Mofa::View;
use Mofa::Controller;
use Mofa::Model::Request;
use Mofa::Model::Offer;
use Mofa::Model::Mapped;
use Mofa::Model::MeetingPt;

my $p_start = myparam('start');    # =~ m/^(\d\d*)$/;
my $p_dest  = myparam('dest');     # =~ m/^(\d\d*)$/;

if ( not defined($p_start) or $p_start eq '' ) {
    $p_start = $session->param('open_search_start');
}
if ( not defined($p_dest) or $p_dest eq '' ) {
    $p_dest = $session->param('open_search_dest');
}

if (   not defined($p_start)
    or $p_start eq ''
    or not defined($p_dest)
    or $p_dest eq '' )
{
    display_err('Start oder Ziel nicht angegeben!');
    exit;
}

my $start = Mofa::Model::MeetingPt->get($p_start);
my $dest  = Mofa::Model::MeetingPt->get($p_dest);

if ( not defined($start) or not defined($dest) ) {
    display_err('Start oder Ziel nicht in Datenbank!');
    exit;
}

##  suche passende Mitfahrgelegenheiten:
my $request = Mofa::Model::Request->new(
    {   start       => $start->id(),
        destination => $dest->id(),
        requester   => $session->param('login'),
        startTime   => gmtime()
    }
);
my @mapped = Mofa::Controller::mapping_search($request);
if ( not defined( $session->param('login') )
    or $session->param('login') eq '' )
{
    $session->param( 'open_search_start', $start->id() );
    $session->param( 'open_search_dest',  $dest->id() );
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
            . $dest->description()
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
            . $dest->description()
            . " wurden ueber ihre Anfrage informiert!",
        " Sie erhalten eine Nachricht, sobald sie jemand mitnehmen moechte.",
        @sent_sms
    );
}

