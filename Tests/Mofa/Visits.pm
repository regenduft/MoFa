package Mofa::Visits;

use lib('..');
use strict;
use warnings;
use Carp;

use Mofa::Object;
use Mofa::Person;
use Mofa::MeetingPt;
@Mofa::Visits::ISA = ("Mofa::Object");

sub unquoted_fields() { return qw(id place); }
sub quoted_fields()   { return qw(person); }

sub foreign_keys() {
    return (
        person => Mofa::Person->table(),
        place  => Mofa::MeetingPt->table()
    );
}

sub person { return $_[0]->get_data( 'person', 'Mofa::Person' ); }

sub personId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('person');
}
sub place { return $_[0]->get_data( 'place', 'Mofa::Place' ); }

sub placeId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('place');
}

1;
