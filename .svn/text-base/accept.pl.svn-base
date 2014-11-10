#!/usr/bin/perl

use strict;
use warnings;

use Mofa::View;
use Mofa::Model::Mapped;

my $login = $session->param('login');
if ( defined($login) and $login ne '' ) {
    my $accept = myparam('accept');
    if ( defined($accept) and $accept ne '' ) {
        Mofa::Model::Mapped->accept($accept);
    }
    my $deny = myparam('deny');
    if ( defined($deny) and $deny ne '' ) {
        Mofa::Model::Mapped->deny($deny);
    }
    my @mapped = Mofa::Model::Mapped->get_by_provider($login);
    Mofa::View::display_accept(@mapped);
}
else {
    Mofa::View::login_failure();
}
