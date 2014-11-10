package Mofa::Mark;

use lib('..');
use strict;
use warnings;
use Carp;

use Mofa::Object;
use Mofa::Person;
use Mofa::Offer;
@Mofa::Mark::ISA = ("Mofa::Object");

sub unquoted_fields() { return qw(id offer); }
sub quoted_fields()   { return qw(person); }

sub foreign_keys() {
    return ( person => Mofa::Person->table(), offer => Mofa::Offer->table() );
}

sub person { $_[0]->_get_set_fkey( 'person', 'Mofa::Person', @_ ); }

sub personId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('person');
}
sub offer { $_[0]->_get_set_fkey( 'offer', 'Mofa::Offer', @_ ); }

sub offerId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('offer');
}

1;
