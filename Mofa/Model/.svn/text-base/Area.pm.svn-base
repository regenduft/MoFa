package Mofa::Model::Area;

=head2 Mofa::Model::Area

Ein Gebiet auf der Erdoberfläche.
Erbt von: Mofa::Model::Point

=head4 Objektmethoden

=head4 C<$ contains($@)>

I<Parameter:> Point-Objekt, [Radius (Int)]
    
I<Rückgabewert:> 1, falls der übergebene Punkt in dem Gebiet,
vergrößert nach allen Seiten um den Radius,
liegt. 0 sonst.
 
=head4 C<@ asPolygon(@)>

I<Parameter:> Schrittweite (Int)
    
I<Rückgabewert:> Liste von Point-Objekten, die ein Poylgon
beschreiben, das dieses Gebiet annähert. 

=cut

use lib('../..');
use strict;
use warnings;

use Mofa::Model::Point;
@Mofa::Model::Area::ISA = ("Mofa::Model::Point");

sub contains($@) {
    my ( $self, $enlarge ) = @_;
    if ( not defined($enlarge) ) { $enlarge = 0 }
    my $testpt = shift;
    my ( $ax, $ay ) = $self->utm;
    my ( $px, $py ) = $testpt->utm;
    my $distx       = ( $px - $ax );
    my $disty       = ( $py - $ay );
    my $square_dist = $distx * $distx + $disty * $disty;
    if ( $square_dist <= $enlarge ) { return 1; }
    return 0;
}

sub asPolygon() {
    my ($self) = @_;
    return ($self);
}

