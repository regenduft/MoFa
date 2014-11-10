package Mofa::Model::GeocodedPt;

=head2 Mofa::Model::GeocodetPt

Punkte auf der Erdoberfläche mit Koordinate und Adresse, sowie mit einer
Genauigkeit, wie gut sie zu der Geocode-Anfrage passen.
Objekte dieser Klasse werden von C<Mofa::Model::Geocode>-Objekten aggregiert.
Erbt von: C<Mofa::Model::Address.>

=head4 Skalare Attribute

C<accuracy (int)> - Gibt an, wie gut das Objekt zur Geocode-Anfrage passt. 

=cut

use lib('../..');
use strict;
use warnings;

use Mofa::Model::Address;
@Mofa::Model::GeocodedPt::ISA = ("Mofa::Model::Address");

sub hidden_fields() { return qw(accuracy); }
sub accuracy { $_[0]->_get_set( 'accuracy', @_ ); }
1;

