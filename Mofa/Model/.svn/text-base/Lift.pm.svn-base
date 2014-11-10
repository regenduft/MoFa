package Mofa::Model::Lift;

=head2 Mofa::Model::Lift

Mitfahrgelegenheiten (kann Angebot oder Gesuch sein).
Erbt von: C<Mofa::Model::Object>  

=head4 Skalare Attribute

C<startTime (int)   > - Startzeit

C<arrivalTime (int) > - Ankunftszeit

C<timeAccuracy (int)> - Maximale aktzeptierte Abweichung von der Startzeit

C<seats (int)       > - Freie Sitzplätze

C<fee (int)         > - Gebühren für die Mitnahme

=head4 Foreign-Key-Attribute

C<start (Mofa::Model::MeetingPt)      > - Startort

C<startId (int)>

C<destination (Mofa::Model::MeetingPt)> - Zielort

C<destinationId (int)>

=head4 Klassenmethoden

=head4 C<@ get_touching($$$$)>

I<Parameter:> Koordinaten des unteren rechten und oberen linken Punkt
eines zu den UTM-Achsen parallelen Rechtecks
                
I<Rückgabewert:> Liste von allen Objekten der Klasse auf die die 
Methode aufgerufen wird (zum Bsp: C<Mofa::Modell::Offer>
oder C<Mofa::Model::Request>), die das spezifizierte 
Rechteck berühren, und möglicherweise noch einige die 
es nicht berühren, die jedoch nicht ausgefiltert wurden.

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Object;
use Mofa::Model::MeetingPt;
@Mofa::Model::Lift::ISA = ("Mofa::Model::Object");

sub unquoted_fields() {
    return
        qw(id destination start startTime arrivalTime timeAccuracy seats fee);
}

sub foreign_keys() {
    return (
        start       => Mofa::Model::MeetingPt->table(),
        destination => Mofa::Model::MeetingPt->table()
    );
}

sub destination {
    $_[0]->_get_set_fkey( 'destination', 'Mofa::Model::MeetingPt', @_ );
}

sub destinationId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('destination');
}
sub start { $_[0]->_get_set_fkey( 'start', 'Mofa::Model::MeetingPt', @_ ); }

sub startId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('start');
}
sub startTime    { $_[0]->_get_set( 'startTime', @_ ); }
sub arrivalTime  { $_[0]->_get_set( 'arrivalTime', @_ ); }
sub timeAccuracy { $_[0]->_get_set( 'timeAccuracy', @_ ); }
sub seats        { $_[0]->_get_set( 'seats', @_ ); }
sub fee          { $_[0]->_get_set( 'fee', @_ ); }

# returns Array of Lifts that touch an Area spezified by the 4 parameters.
# (Lower Left an Upper Right Corner)
sub get_touching($$$$$) {
    my ( $class, $left, $bottom, $right, $top ) = @_;
    my $op = "SELECT "
        . join( ', ', map { "L.$_ AS $_"; } $class->fields() )
        . ", S.utm_x AS x1, S.utm_y AS y1, S.utm_n AS n1, S.utm_e AS e1, "
        . "D.utm_x AS x2, D.utm_y AS y2, D.utm_n AS n2, D.utm_e AS e2 "
        . "FROM MeetingPt AS S INNER JOIN Offer AS L ON S.id = L.start INNER JOIN MeetingPt AS D ON D.id = L.destination "
        . "WHERE "
        . "((x1 < $left AND x2 > $left) OR (x1 > $right AND x2 < $right) OR (x1 > $left AND x1 < $right)) "
        . "AND "
        . "((y1 < $top AND y2 > $top) OR (y1 > $bottom AND y2 < $bottom) OR (y1 < $top AND y1 > $bottom))";
    my $ans = $class->dbh()->selectall_arrayref( $op, { Slice => {} } );
    my @lifts;
    foreach my $hash ( @{$ans} ) { push( @lifts, $class->new($hash) ); }
    return @lifts;
}

1;
