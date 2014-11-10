package Mofa::Rating;

use lib('..');
use strict;
use warnings;
use Carp;

use Mofa::Object;
use Mofa::Request;
use Mofa::Offer;
@Mofa::Rating::ISA = ("Mofa::Object");

sub unquoted_fields() {
    return qw(id request offer pts_by_requester pts_by_provider);
}

sub quoted_fields() {
    return
        qw(comment_by_requester comment_by_provider answer_by_requester answer_by_provider);
}

sub foreign_keys() {
    return ( request => Mofa::Request->table(),
        offer => Mofa::Offer->table() );
}

sub request { return $_[0]->_get_set_fkey( 'request', 'Mofa::Request' ); }

sub requestId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('request');
}
sub offer { return $_[0]->_get_set_fkey( 'offer', 'Mofa::Offer' ); }

sub offerId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('offer');
}
sub pts_by_requester { return $_[0]->_get_set( 'pts_by_requester', @_ ); }
sub comment_by_requester {
    return $_[0]->_get_set( 'comment_by_requester', @_ );
}
sub answer_by_requester {
    return $_[0]->_get_set( 'answer_by_requester', @_ );
}
sub pts_by_provider { return $_[0]->_get_set( 'pts_by_provider', @_ ); }
sub comment_by_provider {
    return $_[0]->_get_set( 'comment_by_provider', @_ );
}
sub answer_by_provider { return $_[0]->_get_set( 'answer_by_provider', @_ ); }
1;
