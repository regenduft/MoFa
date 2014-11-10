#!/usr/bin/perl

use warnings;
use strict;

use Mofa::Controller;
use Mofa::View;
use Mofa::Model::Person;

my ( $id, $pw, $nr )
    = ( myparam('login'), myparam('password'), myparam('phone') );

if (    defined($id)
    and defined($pw)
    and defined($nr)
    and $id ne ''
    and $pw ne ''
    and $nr ne '' )
{
    if ( defined( eval { Mofa::Model::Person->get($id) } ) ) {
        display_err('Der Login-Name ist bereits vergeben!');
        exit;
    }
    if ( not $nr =~ m/^01[567]\w{6,10}$/ ) {
        display_err('Das ist ja garkeine Handynummer!');
        exit;
    }
    if ( not $pw =~ m/^..../ ) {
        display_err(
            'Das Passwort soll wenigstens 4 Zeichen haben!<br/>',
            'Am besten nimmst du Zahlen, auf Passwort-Felder
			wir normalerweise automatisch die Zifferneingabe aktiviert!'
        );
        exit;
    }

    my $regkey = rand();
    $session->param( 'regkey',        $regkey );
    $session->param( 'id_to_confirm', $id );
    $session->param( 'pw_to_confirm', $pw );
    $session->param( 'nr_to_confirm', $nr );
    my $msg
        = 'Mobile Hitchhiker Handynr bestaetigen: Link aufrufen, oder Code: '
        . $regkey
        . ' auf der Website eingeben.';
    my $url = 'http://trip261.wohnheim.uni-kl.de/Mofa/confirm.pl?'
        . $session->name() . '='
        . $session->id()
        . '&regkey='
        . $regkey;
    my $res = $regkey;    #Mofa::Controller::send_push_sms($nr, $msg, $url);

    if ( defined($res) ) {
        $session->param( 'smsstatus', $res );
        Mofa::View::register_sms_sent($res);
    }
    else {
        display_err('Fehler beim SMS verschicken!!');
    }
}
else {
    display_err( 'Sie haben das Formular nicht vollstaendig ausgefuellt.',
        br(), 'Wenigstens eines der 3 Felder ist ganz leer!' );
}

# Erzeuge eine neue POST-Anfrage mit den xml-Daten entsprechend dem MLP-Protokoll
#	my $http_req = HTTP::Request->new(POST => 'http://soap.smscreator.de/send.asmx');
#	$http_req->header(SOAPAction => "http://cetix.de/SendSMS/WapPush");
#	my $date = strftime "%a, %d %b %Y %H:%M:%S", gmtime;
#	my $http_data = '<?xml version="1.0" encoding="utf-8"?>
#<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
#  <soap:Body>
#    <WapPush xmlns="http://cetix.de/SendSMS">
#      <User>FLSMSC18570499</User>
#      <Password>4TT3PF</Password>
#      <Recipient>'.$nr.'</Recipient>
#      <Text>Sie haben sich beim Mobile Hitchhiker registriert.</Text>
#      <Url>http://trip261.wohnheim.uni-kl.de/Mofa/confirm.pl?'.
#      	$session->name().'='.$session->id().
#      	'&regkey='.$regkey.'</Url>
#    </WapPush>
#  </soap:Body>
#</soap:Envelope>';
#	$http_req->content_type('text/xml');
#	$http_req->content($http_data);
