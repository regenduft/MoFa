package Mofa::Model::MeetingPt;

=head2 Mofa::Model::MeetingPt

Punkt auf der Erdoberfläche mit Adresse und Name, der als Treffpunkt 
zwischen Mitfahrer und Autofahrer geeignet ist.
Erbt von: C<Mofa::Model::Address>.

=head4 Skalare Attribute

C<name (string)> - Name des Punktes, der ihn eindeutig identifiziert  und knapp beschreibt

C<distance (float)>  - Entfernung in Kilometern vom Aufenthaltsort (wird nicht in DB gespeichert.)
 
=head4 Klassenmethoden

=head4 C<@ get_points_in_area($@)>

I<Parameter:> C<Area>-Objekt, [Max. Vergrößerung (C<int>), [Min. Treffer (C<int>)]]
    
I<Rückgabewert:> Liste von C<Point>-Objekte innerhalb des Area-Objektes.
    
Sucht Punkte im übergebenem Area-Objekt. Sind noch nicht 
genug Punkte gefunden worden, wird das Area-Objekt um einen
bestimmten Radius vergrößert, und die Suche wiederholt, bis 
genug Punkte gefunden wurden (Min Teffer), oder die Maximale 
Vergrößerung erreicht wurde. Alle gefunden Punkte werden 
zurückgegeben.

=cut

use lib('../..');
use strict;
use warnings;

use Mofa::Model::Address;
@Mofa::Model::MeetingPt::ISA = ("Mofa::Model::Address");

sub quoted_fields() {
    return ( MOFA::Model::MeetingPt->SUPER::quoted_fields(), 'name' );
}

sub name { $_[0]->_get_set( 'name', @_ ); }
sub distance { $_[0]->_get_set( 'distance', @_ ); }

sub add {

# Check if exists entry with same name. if yes, save that entrys id, if no do super->add
    my ($self) = @_;
    my $op = "SELECT id FROM "
        . $self->table()
        . " WHERE name = '"
        . $self->dbval('name') . "'";
    my @ans = $self->dbh()->selectrow_array($op);
    if ( scalar(@ans) <= 0 ) { return $self->SUPER::add(); }
    if (   ( not defined( $self->id() ) )
        or $self->id() < 0
        or $self->id() eq '-1' )
    {
        $self->id( $ans[0] );
    }
    return -3;
}

sub get($$@) {
    my ( $class, $id, $dbh ) = @_;
    if ( not defined($dbh) ) { $dbh = $class->dbh(); }
    my $self = {};
    bless( $self, $class );
    my $hash = $dbh->selectrow_hashref( "SELECT "
            . join( ', ', $class->fields() )
            . " FROM "
            . $class->table()
            . " WHERE id='$id' And name NOTNULL" );
    if ( defined($hash) and ref($hash) eq 'HASH' ) {
        return ( $class->new($hash) );
    }
    croak("Objekt vom Typ $class mit id $id in Datenbank nicht gefunden!");
}

sub get_by_name($$) {
    my ( $class, $name ) = @_;
    return (
        $class->new(
            $class->dbh()->selectrow_hashref(
                      "SELECT "
                    . join( ', ', $class->fields() )
                    . " FROM "
                    . $class->table()
                    . " WHERE name='$name'"
            )
        )
    );
}

sub get_ids($$@) {
    my ( $class, $dbh ) = @_;
    if ( not defined($dbh) ) { $dbh = $class->dbh(); }
    return (
        $dbh->selectcol_arrayref(
                  "SELECT id, name " . " FROM "
                . $class->table()
                . " WHERE name NOTNULL;"
        )
    );
}

sub get_points_in_area($$@) {
    my ( $class, $area, $maxresize, $minhits ) = @_;
    my $enlarge = 80;
    if ( not defined($maxresize) ) { $maxresize = 2000000; }
    elsif ($maxresize == 0) { $maxresize = $enlarge; }
    if ( not defined($minhits) )   { $minhits   = 2; }
    my $ans = _get_points_in_area( $class, $area, $maxresize, $minhits * 2 );
    my @res;
    while ( scalar(@res) < $minhits and $enlarge <= $maxresize ) {
        foreach my $hash ( @{$ans} ) {
            my $pt = Mofa::Model::MeetingPt->new($hash);
            if ( $area->contains( $pt , $enlarge ) ) {
                if (not defined($hash->{distance})) {$hash->{distance} = int($enlarge/100) / 10;}
                push (@res, $pt);
            }
        }
        $enlarge *= 1.2;
        if ( $enlarge < 200 ) { $enlarge = 200; }
    }
    return @res;
}

sub _get_points_in_area(@) {
    my ( $class, $area, $maxresize, $minhits ) = @_;
    my $radius = 32000;
    $maxresize += $radius;    
    my ( $utm_x, $utm_y ) = $area->utm();
    if ( defined( $area->outRadius() ) ) { $radius = $area->outRadius(); }
    my $pts;
    while ((not defined($pts) or (scalar(@{$pts}) < $minhits)) and $radius <= $maxresize ) {
        my $op = 'SELECT * FROM '
            . $class->table()
            . ' WHERE utm_x > '
            . ( $utm_x - $radius )
            . ' And utm_x < '
            . ( $utm_x + $radius )
            . ' And utm_y > '
            . ( $utm_y - $radius )
            . ' And utm_y < '
            . ( $utm_y + $radius )
            . " And name NOTNULL";
        $pts = $class->dbh()->selectall_arrayref( $op, { Slice => {} } );
        if (not defined($pts)) {croak('Fehler beim lesen in der Tabelle MeetingPt');}
        $radius *= 1.5;
    }
    return $pts;
}


# FOLGENDE FKT LIEFERN nur die ID's (als Hash-Schlüssel) mit dem NAMEN (als Wert)
sub get_all($$) {
    my ( $class, $city ) = @_;
    my $ans = $class->dbh()->selectall_hashref(
        "SELECT id, name, description " . " FROM "
            . $class->table(),
#            . " WHERE name NOTNULL;",
        'id'
    );
    my $res;
    while ( my ( $key, $val ) = each( %{$ans} ) ) {
        $res->{$key} = $val->{name};
        if (not defined($val->{name}) or $val->{name} eq '' ) {$res->{$key} = $val->{description};}
    }
    return $res;
}
#
#sub get_city($$) {
#    my ( $class, $city ) = @_;
#    my $ans = $class->dbh()->selectall_hashref(
#        "SELECT id, name " . " FROM "
#            . $class->table()
#            . " WHERE city = '$city' And name NOTNULL; ",
#        'id'
#    );
#    my $res;
#    while ( my ( $key, $val ) = each( %{$ans} ) ) {
#        $res->{$key} = $val->{name};
#    }
#    return $res;
#}

1;
