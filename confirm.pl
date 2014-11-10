#!/usr/bin/perl

use warnings;
use strict;

use Mofa::View;
use Mofa::Model::Person;

if ( $session->param('regkey') eq myparam('regkey') ) {
    my $id     = $session->param('id_to_confirm');
    my $pw     = $session->param('pw_to_confirm');
    my $nr     = $session->param('nr_to_confirm');
    my $person = Mofa::Model::Person->new(
        {   id       => $id,
            password => $pw,
            cellular => $nr,
            msisdn   => $nr,
            type     => 1,
            name     => $id
        }
    );
    $person->add();
    $session->param( 'login', $id );
    Mofa::View::confirm_register();
}
else {
    display_err(
        'Irgendwie gabs wohl nen Fehler beim Telefonnummer bestaetigen.',
        'Schreiben Sie an jostock@rhrk.uni-kl.de!' );
}
