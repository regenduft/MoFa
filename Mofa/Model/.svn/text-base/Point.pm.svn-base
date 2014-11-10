package Mofa::Model::Point;

=head2 Mofa::Model::Point

Objekte dieser Klasse repräsentieren einen Punkt auf der Oberfläche der Erde.
Erbt von: C<Mofa::Model::Object>

=head4 Beschreibung

This class represents a point on the earth. The coordinates can be referred
as latitude-longitude dezimal coordinates with C<Mofa::Model::Point::ll()> or as utm-coordinates
in meters with C<Mofa::Model::Point::utm()>. These methods read without parameter or set with
2 (or 4 in case of utm) parameters. You should only use WGS84-coordinates.

=head4 Klassenmethoden

=head4 C<$ new($)>

I<Parameter:> Hashreferenz

I<Rückgabewert:> C<Point>-Objekt

I<Beispiele:>

   $pt = 
       Mofa::Model::Point->new({
           utm_x=>413794, utm_y=>5470842, 
           utm_e=>32,     utm_n=>"U"
       });
   $pt = Mofa::Model::Point->new({
           utm_x=>413794, utm_y=>5470842
       });
   # 32, "U" will be used as values for utm_e and utm_n.

   $pt = Mofa::Model::Point->new({x=>49.39, y=>8.81});
   $pt = Mofa::Model::Point->new({
             coord=>{X=>"49 25 37N", Y=>"7 45 02E"}
         });
 
=head4 C<($$) dms2dez($$)>

I<Parameter:> Koordinaten in Grad Minute Sekunde (C<string>, C<string>)

I<Rückgabewert:> Koordinaten als Dezimalzahl (C<float>, C<float>)

I<Beispiel:>
 
   ($x, $y) = 
     Mofa::Model::Point::dms2dez("49 23 03N", "7 48 44E");

=head4 C<($$) utm2ll(%)>

I<Parameter:> Hash mit Attributen utm_x, utm_y, utm_e, utm_n

I<Rückgabewert:> Koordinaten als Dezimalzahl (C<float>, C<float>)

I<Beispiel:>

   ($x, $y) = 
       utm2ll({
           utm_x=>413794, utm_y=>5470842, 
           utm_e=>32,     utm_n=>"U"
       });
      
=head4 C<($$$$) ll2utm(%)>

I<Parameter:> Hash mit Attributen x, y

I<Rückgabewert:> Utm-Koordinaten

I<Beispiel:>

   ($meters_x, $meters_y, $square_e, $square_n) 
       = ll2utm({x=>49.39, y=>8.81});

=head4 Objektmethoden

=head4 C<($$$$) utm(@)>

I<Parameter:> [utm_x (C<int>), utm_y (C<int>), [utm_e (C<int>), utm_n (C<string>)]]

I<Rückgabewert:> (utm_x, utm_y, utm_n, utm_e)

I<Beispiele:>
 
   Lesen:  ($utm_x, $utm_y)   = $pt->utm;
   Setzen: $pt->utm(413794, 5470842, 32, 'U');
           $pt->utm(413794, 5470842);
      
=head4 C<($$) ll(@)>

I<Parameter:> [x (C<int>), y (C<int>)]

I<Rückgabewert:> (x, y)

I<Beispiele:>
 
   Lesen:  ($x, $y) = $pt->ll;
   Setzen: $pt->ll(49.32, 7.32);

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Karte::UTM;

#use Math::Trig;
use Mofa::Model::Object;
@Mofa::Model::Point::ISA = ("Mofa::Model::Object");

sub unquoted_fields() { return qw(id utm_x utm_y utm_e); }
sub quoted_fields()   { return qw(utm_n); }
sub table             { return 'MeetingPt'; }

sub new($$) {
    my ( $class, $self ) = @_;
    bless( $self, $class );
    if (    defined( $self->{coord} )
        and defined( $self->{coord}->{X} )
        and defined( $self->{coord}->{Y} ) )
    {
        $self->{x} = dms2dez( $self->{coord}->{X} );
        $self->{y} = dms2dez( $self->{coord}->{Y} );
    }
    if (    not( defined( $self->{x} ) and defined( $self->{y} ) )
        and not( defined( $self->{utm_x} ) and defined( $self->{utm_y} ) ) )
    {
        croak "Koordinaten wurden nicht an Konstruktor von $class übergeben!\n".$self->{ans};
    }
    if ( defined( $self->{utm_x} ) ) {
        if ( not defined( $self->{utm_e} ) ) { $self->{utm_e} = 32; }
        if ( not defined( $self->{utm_n} ) ) { $self->{utm_n} = "U"; }
    }
    return $self;
}

sub add {

# Check if exists entry with same coords. if yes, return id of this entry, if no do super->add
    my ($self) = @_;
    $self->utm();
    my $op = "SELECT id FROM "
        . $self->table()
        . " WHERE utm_x = "
        . $self->dbval('utm_x')
        . " And utm_y = "
        . $self->dbval('utm_y');
    my @ans = $self->dbh()->selectrow_array($op);
    if ( scalar(@ans) <= 0 ) { return $self->SUPER::add(); }
    if (   ( not defined( $self->id() ) )
        or $self->id() < 0
        or $self->id() eq '-1' )
    {
        $self->id( $ans[0] );
    }
    return -2;
}

sub utm {
    my ($self) = shift;
    if (@_) {
        $self->{utm_x} = shift;
        $self->{x}     = undef;
        $self->{utm_y} = shift;
        $self->{y}     = undef;
        if (@_) {
            $self->{utm_e} = shift;
            $self->{utm_n} = shift;
        }
        else {
            $self->{utm_e} = 32;
            $self->{utm_n} = "U";
        }
    }
    elsif ( not defined( $self->{utm_x} ) ) {
        ( $self->{utm_x}, $self->{utm_y}, $self->{utm_e}, $self->{utm_n} )
            = $self->ll2utm();
    }
    return ( $self->{utm_x}, $self->{utm_y}, $self->{utm_e}, $self->{utm_n} );
}

sub ll {
    my ($self) = shift;
    if (@_) {
        $self->{x}     = shift;
        $self->{utm_x} = undef;
        $self->{y}     = shift;
        $self->{utm_y} = undef;
    }
    elsif ( not defined( $self->{x} ) ) {
        ( $self->{x}, $self->{y} ) = $self->utm2ll();
    }
    return ( $self->{x}, $self->{y} );
}

# ---- STATISCHE METHODEN ----

sub utm2ll($) {
    my ($coord) = @_;
    return Karte::UTM::UTMToDegrees( $coord->{utm_e}, $coord->{utm_n},
        $coord->{utm_x}, $coord->{utm_y} );
}
sub ll2utm($) {
    my ($coord) = @_;
    my ( $UTM_E, $UTM_N, $UTM_X, $UTM_Y )
        = Karte::UTM::DegreesToUTM( $coord->{x}, $coord->{y}, 'WGS 84' );
    return ( $UTM_X, $UTM_Y, $UTM_E, $UTM_N );
}

sub dms2dez($$) {
    my ( $NS, $OW ) = @_;
    $NS =~ m/(\d*)\s(\d\d)\s(\d\d)(.\d*){0,1}(\w)/;
    my $X = $1 + $2 / 60 + $3 / 3600;
    if ( $4 eq 'S' ) { $X *= -1; }
    $OW =~ m/(\d*)\s(\d\d)\s(\d\d)(.\d*){0,1}(\w)/;
    my $Y = $1 + $2 / 60 + $3 / 3600;
    if ( $4 eq 'W' ) { $Y *= -1; }
    return ( $X, $Y );
}

1;
