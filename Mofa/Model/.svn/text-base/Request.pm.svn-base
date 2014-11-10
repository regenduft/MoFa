package Mofa::Model::Request;

=head2 Mofa::Model::Request

Mitfahrgesuche. Erbt von: C<Mofa::Model::Lift>.  

=head4 Foreign-Key-Attribute

C<requester (Mofa::Model::Person) > - Person, die diese Mitfahrgelegenheit sucht.

C<requesterId (string)>

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Lift;
@Mofa::Model::Request::ISA = ("Mofa::Model::Lift");

sub unquoted_fields() {
    return ( Mofa::Model::Request->SUPER::unquoted_fields(), qw(negotiated_to) );
}
sub quoted_fields() { return qw(requester); }

sub foreign_keys() {
    return (
        Mofa::Model::Request->SUPER::foreign_keys(),
        requester => Mofa::Model::Person->table()
    );
}

sub requester { $_[0]->_get_set_fkey( 'requester', 'Mofa::Model::Person', @_ ); }

sub requesterId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('requester');
}

sub get_by_requester {
    my ($class, $person) = @_;
    my $op = "SELECT "
        . join( ', ', $class->fields() )
        . " FROM " . $class->table() 
        . " WHERE requester = '$person';";
    my $ans = $class->dbh()->selectall_arrayref( $op, { Slice => {} } );
    my @lifts;
    foreach my $hash ( @{$ans} ) { push( @lifts, $class->new($hash) ); }
    return @lifts;
}

1;

