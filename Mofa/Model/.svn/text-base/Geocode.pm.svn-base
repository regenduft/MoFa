package Mofa::Model::Geocode;

=head2 Mofa::Model::Geocode

Antwort auf eine Geocode-Anfrage. Erbt von: C<Mofa::Model::Object>.

=head4 Klassenmethoden

=head4 C<$ new($@)> 

I<Parameter:> Geocode-Anfrage (C<string>), 
               Liste von passenden GeocodedPt-Objekten
               
I<Rückgabewert:> neues C<Geocode>-Objekt.
    
=head4 C<$ get($)>

I<Parameter:> Geocode-Anfrage (C<string>)
    
I<Rückgabewert:> Zu dieser Geocode-Anfrage passendes C<Geocode>-Objekt

Alle zu dieser Anfrage passenden Punkte werden in der
Datenbank gesucht, und zum neuem Geocode Objekt hinzugefügt.

=head4 Objektmethoden

=head4 C<@ points()>

I<Rückgabewert:> Liste der C<GeocodedPts> in diesem C<Geocode>-Objekt.
    
=head4 C<$ push(@)>

I<Parameter:> Liste von C<GeocodedPts>

Fügt die übergeben GeocodetPts zu diesem Objekt hinzu. 

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Object;
use Mofa::Model::GeocodedPt;
@Mofa::Model::Geocode::ISA = ("Mofa::Model::Object");

sub unquoted_fields() { return qw(id point accuracy); }
sub quoted_fields()   { return qw(query); }
sub foreign_keys()    { return ( point => Mofa::Model::Address->table() ); }

sub hidden_fields() { return qw(points accuracys ids); }
sub query           { $_[0]->_get_set( 'query', @_ ); }

## Benutzung: 	points() liefert ein Array von Geocoded points
##					push(@) fuegt liste von Geocoded points zum Objekt hinzu
##					new($@) erzeugt ein Geocode-Objekt mit query und liste von Geocoded points
##					add() speichert die Daten des Objekts in eine db
##					get($) holt ein Objekt anhand einer query aus der db

sub points {
    my ($self) = @_;
    my @pts    = @{ $self->{points} };
    my $size   = scalar(@pts) - 1;
    my $pt;
    foreach my $i ( 0 .. $size ) {
        $pt = $pts[$i];
        if ( not ref($pt) ) {
            my $pt = Mofa::Model::Address->get($pt);
            my $ac = $self->{accuracys}->[$i];
            bless( $pt, 'Mofa::Model::GeocodedPt' );
            $pt->accuracy( defined($ac) ? $ac : 99 );
            $self->{points}->[$i] = $pt;
        }
    }
    return sort { $b->accuracy() <=> $a->accuracy(); } @{ $self->{points} };
}

sub new {
    my ( $class, $query, @pts ) = @_;
    my $self = {
        query  => $query,
        points => \@pts,
        accuracys => [ map { $_->accuracy(); } @pts ]
    };
    bless( $self, $class );
    return $self;
}

sub push {
    my ( $self, @pts ) = @_;
    CORE::push( @{ $self->{points} }, @pts );
    CORE::push( @{ $self->{accuracys} }, map { $_->accuracy(); } @pts );
}

sub add($) {
    my ($self) = @_;
    my $ans = 1;
    my ( $pt, $_ptid, $_ac, $ptid, $ac );
    my @pts  = @{ $self->{points} };
    my $size = scalar(@pts) - 1;
    foreach my $i ( 0 .. $size ) {
        $pt = $pts[$i];
        if ( ref($pt) ) {
            $pt->add();
            $_ptid = $pt->id();
            $_ac   = $pt->accuracy();
        }
        else {
            $_ptid = $pt;
            $_ac   = $self->{accuracys}->[$i];
        }
        $ptid = defined($_ptid) ? $_ptid : 'NULL';
        $ac   = defined($_ac)   ? $_ac   : 'NULL';
        my $op = "INSERT INTO "
            . $self->table()
            . " (id, query, point, accuracy) "
            . "VALUES ( NULL, '"
            . $self->dbval('query')
            . "', $ptid, $ac );";
        $ans = $self->dbh()->do($op);
        if ( not $ans ) {
            saveerr(
                'Hinzufuegen zu Tabelle des Objekts vom Typ '
                    . ref($self)
                    . " fehlgeschlagen:$ans",
                $op
            );
        }
        my $id = eval { $self->dbh()->func('last_insert_rowid') };
        if ( defined($id) ) { $self->{ids}->[$i] = $id; }
    }
    return $ans;
}

sub get($$) {
    my ( $class, $query ) = @_;
    my $all = $class->dbh()->selectall_arrayref(
        "SELECT "
            . join( ', ', $class->fields() )
            . " FROM "
            . $class->table()
            . " WHERE query='$query'",
        { Slice => {} }
    );
    if ( defined($all) and ref($all) and scalar( @{$all} ) > 0 ) {
        my ( @ids, @pts, @accs );
        foreach my $hash ( @{$all} ) {
            if ( not defined( $hash->{point} ) ) {
                my $op = "DELETE FROM "
                    . $class->table()
                    . " WHERE id = "
                    . $hash->{id};
                $class->dbh()->do($op);
                $class->saveerr(
                    "Eintrag zu $query mit undef-Point wurde aus Geocode-Tabelle geloescht: "
                        . $hash->{id} );
                return undef;
            }
            CORE::push( @ids,  $hash->{id} );
            CORE::push( @pts,  $hash->{point} );
            CORE::push( @accs, $hash->{accuracy} );
        }
        my $self = {
            query     => $query,
            points    => \@pts,
            accuracys => \@accs,
            ids       => \@ids
        };
        bless( $self, $class );
        return $self;
    }
    croak "Keine entsprechende Geocode-Query $query im Cache!";
}

1;
