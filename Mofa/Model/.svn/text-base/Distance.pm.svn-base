package Mofa::Model::Distance;

=head2 Mofa::Model::Distance

Strassenentfernung und Fahrtzeit zwischen zwei C<Point>-Objekten.
Erbt von: C<Mofa::Model::Object>.

=head4 Skalare Attribute

C<distance (float)> - Abstand in Kilometern mit 2 Stellen nach dem Komma

C<time (int)>       - Fahrtzeit in Minuten
 
=head4 Foreign-Key-Attribute

C<start (Mofa::Model::Address)>       - Startpunkt

C<startId (int)>

C<destination (Mofa::Model::Address)> - Zielpunkt

C<destinationId (int)>
 
=head4 Klassenmethoden

=head4 C<$ get($$)>

I<Parameter:> Ids 2er C<Point>-Datensätze (C<int>)
    
I<Rückgabewert:> C<Distance>-Objekt mit dem Abstand zwischen beiden 
Punkten, falls der Abstand bereits in der 
Datenbank steht. Undef sonst.
 
=head4 C<$ add($$$$)>

I<Parameter:> Id des Start und des Zielpunkt (C<int>), Entfernung (C<int>), Zeit (C<int>)
    
I<Rückgabewert:> 1, falls erfolgreich in Datenbank eingetragen. <1, sonst.

Trägt den Abstand zwischen diesen beiden Punkten in die Datenbank ein.
Falls schon ein Eintrag existiert, wird er aktualisiert.

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Object;
use Mofa::Model::Address;
@Mofa::Model::Distance::ISA = ("Mofa::Model::Object");

sub unquoted_fields() { return qw(id start destination distance time); }
sub quoted_fields()   { return qw(); }

sub foreign_keys() {
    return (
        start       => Mofa::Model::Address->table(),
        destination => Mofa::Model::Address->table()
    );
}

sub start { $_[0]->_get_set_fkey( 'start', 'Mofa::Model::Address', @_ ); }

sub startId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('start');
}
sub destination {
    $_[0]->_get_set_fkey( 'destination', 'Mofa::Model::Address', @_ );
}

sub destinationId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('destination');
}
sub distance { $_[0]->get_set( 'distance', @_ ); }
sub time { $_[0]->_get_set( 'time', @_ ); }

sub get($$$) {
    my ( $class, $start, $destination ) = @_;
    my $op = "SELECT distance, time " . " FROM "
        . $class->table()
        . " WHERE start = $start And destination = $destination ;";
    my $hash = $class->dbh()->selectrow_hashref($op);
    if ( defined($hash) and ref($hash) eq 'HASH' ) {
        return ( $hash->{distance}, $hash->{time} );
    }
    croak
        "Keine Distanz zum angegebenem Start $start und Ziel $destination in der Datenbank gefunden!";
}

sub add($$$$$) {
    my ( $class, $start, $destination, $distance, $time ) = @_;
    my $self = {
        start       => $start,
        destination => $destination,
        distance    => $distance,
        time        => $time
    };
    bless( $self, $class );
    ## Suche ob es schon einen entsprechenden Eintrag gibt und aktualisiere diesen ggf.
    my $op = "SELECT id " . " FROM "
        . $class->table()
        . " WHERE start = $start And destination = $destination ;";
    my $list = $class->dbh()->selectcol_arrayref($op);
    if ( defined($list) ) {
        my @list = @{$list};
        if ( scalar(@list) > 0 ) {
            $self->id( $list[0] );
            return $self->SUPER::update('id');
        }
    }
    ## Sonst füge neuen hinzu.
    return ( $self->SUPER::add() );
}
