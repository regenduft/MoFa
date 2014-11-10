package Mofa::Model::Offer;

=head2 Mofa::Model::Offer

Mitfahrangebote. Erbt von: C<Mofa::Model::Lift>  

=head4 Foreign-Key-Attribute

C<provider (Mofa::Model::Person) >- Anbieter dieses Mitfahrangebotes
  
C<providerId (string)>

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Lift;
use Mofa::Model::Person;
@Mofa::Model::Offer::ISA = ("Mofa::Model::Lift");

sub quoted_fields() { return qw(provider); }

sub foreign_keys() {
    return (
        Mofa::Model::Offer->SUPER::foreign_keys(),
        provider => Mofa::Model::Person->table()
    );
}

sub provider { $_[0]->_get_set_fkey( 'provider', 'Mofa::Model::Person', @_ ); }

sub providerId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('provider');
}

sub get_by_provider {
    my ($class, $person) = @_;
    my $op = "SELECT "
        . join( ', ', $class->fields() )
        . " FROM " . $class->table() 
        . " WHERE provider = '$person';";
    my $ans = $class->dbh()->selectall_arrayref( $op, { Slice => {} } );
    my @lifts;
    foreach my $hash ( @{$ans} ) { push( @lifts, $class->new($hash) ); }
    return @lifts;
}


1;

