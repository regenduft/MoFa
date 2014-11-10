package Mofa::Model::CircularArea;

=head2 Mofa::Model::CircularArea

Repr‰sentiert ein Gebiet in Form eines Ring-Ausschnitts auf der Erdoberfl‰che,
(Typischerweise verwendet zur Beschreibung des Ergebnis einer Positionsbestimmungsanfrage).
Erbt von C<Mofa::Model::Area>.

=head4 Skalare Attribute

C<inRadius   (int)> - innerer Radius des Rings in Metern

C<outRadius  (int)> - ‰uﬂerer Radius des Rings in Metern

C<startAngle (int)> - Winkel zu Nord, ab dem das Gebiet beginnt

C<stopAngle  (int)> - Winkel zu Nord, bei dem das Gebiet endet.

=head4 Klassenmethoden

=head4 C<$ new($)>

I<Parameter:> Hashreferenz
    
I<R¸ckgabewert:> C<CircularArea>-Objekt
    
Die Hashreferenz muss zus‰tzlich zu den Attributen,
die zur Initialisierung eines Point-Objekt notwendig sind, 
die Attribute inRadius, outRadius, startAngle und stopAngle 
enthalten.

=head4 C<$ newcircle($$)>

I<Parameter:> C<Point>-Objekt, Radius (C<int>)

I<R¸ckgabewert:> C<CircularArea>-Objekt, das die Kreisfl‰che mit dem Radius 
um den angegebenen Punkt repr‰sentiert 

=cut

#=head1 Name Mofa::Model::CircularArea;
#
#=head1 Syntax
#
#=head1 Description
#
#Speichert den Bereich in dem sich das Handy befindet als Hash 
#mit den Schl¸sseln X, Y, UTM_X, UTM_Y, inRadius, outRadius, 
#startAngle und stopAngle zur¸ck. Zus‰tzlich gibt es 
#die Schl¸ssel squaredOutRadius und squaredInRadius damit 
#aufeinanderfolgende Tests ob die Region einen Pkt enth‰lt 
#schneller durchf¸hrbar sind.

#Der inRadius und outRadius sind in Meter angegeben.
#Die Koordinaten X,Y des Punktes P m¸ssen auch in einem orthonormalem
#System angegeben werden, damit getestet werden kann ob ein Punkt in 
#der angegebenen Region liegt. Dazu werden die Koordinaten X und Y
#zus‰tzlich in UTM Koordinaten (Schl¸ssel UTM_X, UTM_Y)zur¸ckgegeben.
#Die Einheit der UTM-Koordinate ist Meter.
#Das UTM-Quadrat wird durch UTM_E und UTM_N beschrieben. 

#Dadurch wird ein Kreissegment beschrieben:
#
#         /*`
#       /`***\
#     P   )***|
#       \,***/
#         \*,  
#
#Die Position des Punkt P wird durch X und Y beschrieben,
#der Radius der beiden Kreise durch in/outRadius, und der
#Winkel der beiden Begrenzungslinien durch start/stopAngle.
#Das Handy kann sich demnach in der Region mit den Sternchen befinden.
#
#=cut 

use lib('../..');
use strict;
use warnings;

use Mofa::Model::Area;
@Mofa::Model::CircularArea::ISA = ("Mofa::Model::Area");

use Math::Trig;
our ($pip180) = pi() / 180;

sub unquoted_fields() {
    return (
        MOFA::Model::Area->SUPER::unquoted_fields(),
        qw(inRadius outRadius startAngle stopAngle)
    );
}
sub hidden_fields() { return qw(squaredInRadius squaredOutRadius); }

sub inRadius {
    my ( $self, $val ) = @_;
    if ( @_ > 1 ) {
        $self->{inRadius}        = $val;
        $self->{squaredInRadius} = $self->{inRadius} * $self->{inRadius};
    }
    return $self->{inRadius};
}

sub outRadius {
    my ( $self, $val ) = @_;
    if ( @_ > 1 ) {
        $self->{outRadius}        = $val;
        $self->{squaredOutRadius} = $self->{outRadius} * $self->{outRadius};
    }
    return $self->{outRadius};
}

#sub startAngle {if (@_>1) {$_[0]->{startAngle} = $_[1]*$pip180;}return $_[0]->{startAngle};}
#sub stopAngle {if (@_>1) {$_[0]->{stopAngle} = $_[1]*$pip180;}return $_[0]->{stopAngle};}

sub new($$) {
    my ( $class, $self ) = @_;
    $self = $class->SUPER::new($self);
    bless( $self, $class );
    if (not(    defined( $self->{startAngle} )
            and defined( $self->{stopAngle} )
            and defined( $self->{inRadius} )
            and defined( $self->{outRadius} ) )
        )
    {
        return $self->_error(
            "start/stop-Angle oder in/out-Radius nicht an Konstruktor von $class ¸bergeben!"
        );
    }
    $self->{squaredInRadius}  = $self->{inRadius} * $self->{inRadius};
    $self->{squaredOutRadius} = $self->{outRadius} * $self->{outRadius};
    $self->{startAngle} *= $pip180;
    $self->{stopAngle}  *= $pip180;
    return $self;
}

sub newcircle($$$) {
    my ($class, $pt, $rad) = @_;
    my ( $sutm_x, $sutm_y, $sutm_n, $sutm_e ) = $pt->utm();
    return Mofa::Model::CircularArea->new(
        {   utm_x      => $sutm_x,
            utm_y      => $sutm_y,
            utm_n      => $sutm_n,
            utm_e      => $sutm_e,
            startAngle => 0,
            stopAngle  => 0,
            inRadius   => 0,
            outRadius  => 600
        }
    );
}

sub contains($@) {
    my ( $self, $position, $enlarge ) = @_;
    my ( $ax, $ay ) = $self->utm();
    my ( $px, $py ) = $position->utm();
    my $distx        = ( $px - $ax );
    my $disty        = ( $py - $ay );
    my $square_disty = $disty * $disty;
    my $square_dist  = $distx * $distx + $square_disty;
    my $angle        = atan2( $distx, $disty );
    if ( $angle < 0 ) { $angle += pi() * 2; }
    my $sa = $self->{startAngle};
    my $ea = $self->{stopAngle};

    if ( defined($enlarge) and $enlarge != 0 ) {
        my $outRad     = $self->{outRadius} + $enlarge;
        my $inRad      = $self->{inRadius} - $enlarge;
        my $enlargeRad = asin( 2 * $enlarge / $outRad );
        if (    $square_dist <= $outRad * $outRad
            and ( $inRad < 0 or $square_dist >= $inRad * $inRad )
            and (
                (       $sa < $ea
                    and $sa - $enlargeRad <= $angle
                    and $angle <= $self->{stopAngle} + $enlargeRad
                )
                or (    $sa > $ea
                    and $sa - $enlargeRad <= $angle
                    and $angle >= $self->{stopAngle} - $enlargeRad )
                or (    $sa > $ea
                    and $sa + $enlargeRad >= $angle
                    and $angle <= $self->{stopAngle} + $enlargeRad )
                or ( $square_dist <= $enlarge * $enlarge )
            )
            )
        {
            return 1;
        }
        return 0;
    }
    if (    $square_dist <= $self->{squaredOutRadius}
        and $square_dist >= $self->{squaredInRadius}
        and ( ( $sa < $ea and $sa <= $angle and $angle <= $self->{stopAngle} )
            or
            ( $sa > $ea and $sa <= $angle and $angle >= $self->{stopAngle} )
            or
            ( $sa > $ea and $sa >= $angle and $angle <= $self->{stopAngle} )
            or ( $square_dist == 0 ) )
        )
    {
        return 1;
    }
    return 0;
}

sub asPolygon {
    my ( $self, $step ) = @_;
    if ( not defined($step) ) { $step = 0.2; }
    my @polygon;
    my $i;
    if ( $self->{error} ) {
        return undef;
    }
    my $sa = $self->{startAngle};
    my $ea = $self->{stopAngle};
    my $ir = $self->{inRadius};
    my $or = $self->{outRadius};
    if ( $sa > $ea ) { $ea += 2 * pi(); }

    my ( $utm_x, $utm_y, $utm_e, $utm_n ) = $self->utm();

    # start point
    push(
        @polygon,
        Mofa::Model::Point->new(
            {   utm_e => $utm_e,
                utm_n => $utm_n,
                utm_x => $utm_x + sin($sa) * $ir,
                utm_y => $utm_y + cos($sa) * $ir
            }
        )
    );

    #outer circle
    $i = $sa;
    while ( $i < $ea ) {
        push(
            @polygon,
            Mofa::Model::Point->new(
                {   utm_e => $utm_e,
                    utm_n => $utm_n,
                    utm_x => $utm_x + sin($i) * $or,
                    utm_y => $utm_y + cos($i) * $or
                }
            )
        );
        $i += $step;
    }

    #connection from outer circle to inner circle
    push(
        @polygon,
        Mofa::Model::Point->new(
            {   utm_e => $utm_e,
                utm_n => $utm_n,
                utm_x => $utm_x + sin($ea) * $or,
                utm_y => $utm_y + cos($ea) * $or
            }
        )
    );
    push(
        @polygon,
        Mofa::Model::Point->new(
            {   utm_e => $utm_e,
                utm_n => $utm_n,
                utm_x => $utm_x + sin($ea) * $ir,
                utm_y => $utm_y + cos($ea) * $ir
            }
        )
    );

    #inner circle
    $i -= $step;
    while ( $i > $sa ) {
        push(
            @polygon,
            Mofa::Model::Point->new(
                {   utm_e => $utm_e,
                    utm_n => $utm_n,
                    utm_x => $utm_x + sin($i) * $ir,
                    utm_y => $utm_y + cos($i) * $ir
                }
            )
        );
        $i -= $step;
    }

    #close polygon
    push( @polygon, $polygon[0] );
    return @polygon;
}

1;
