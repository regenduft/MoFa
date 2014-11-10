package Mofa::Model::Address;

=head2 Mofa::Model::Address

Objekte dieser Klasse repr‰sentieren einen Punkt auf der Erdoberfl‰che mit
Koordinaten und mit Adresse.
Erbt von: C<Mofa::Model::Point>.

=head4 Skalare Attribute

C<nr          (int)   > - Hausnummer

C<description (string)> - kurze Beschreibung zur Darstellung
wo die vollst‰ndige Adresse nicht hinpasst z.B. "Kaiserslautern Bus Hauptbahnhof"

C<street      (string)> - Straﬂe

C<city        (string)> - Stadt

C<zip         (string)> - Postleitzahl

C<region      (string)> - Bundesland

C<district    (string)> - Kreis

C<state       (string)> - Staat (Abk¸rzung, Deutschland = 'de')

=cut

use lib('../..');
use strict;
use warnings;

use Mofa::Model::Point;
@Mofa::Model::Address::ISA = ("Mofa::Model::Point");

sub unquoted_fields() {
    return ( Mofa::Model::Address->SUPER::unquoted_fields(), qw(nr) );
}

sub quoted_fields() {
    return ( Mofa::Model::Address->SUPER::quoted_fields(),
        qw(description street city zip region district state) );
}
sub table { return 'MeetingPt'; }

sub nr          { $_[0]->_get_set( 'nr',          @_ ); }
sub description { $_[0]->_get_set( 'description', @_ ); }
sub street      { $_[0]->_get_set( 'street',      @_ ); }
sub city        { $_[0]->_get_set( 'city',        @_ ); }
sub zip         { $_[0]->_get_set( 'zip',         @_ ); }
sub region      { 
        my $region = $_[0]->_get_set( 'region',      @_ );

my %abbr = qw(        
Baden-Wuerttemberg BW
Bayern BY
Berlin BE
Brandenburg	BR
Bremen HB
Hamburg HH
Hessen HE
Mecklenburg-Vorpommern MV
Niedersachsen NI
Nordrhein-Westfalen NW
Rheinland-Pfalz RP
Saarland SL
Sachsen SN
Sachsen-Anhalt ST
Schleswig-Holstein SH
Thueringen TH
);          
        if (defined($abbr{$region})) {return $abbr{$region};}
        return $region;
    
    }
sub district    { $_[0]->_get_set( 'district',    @_ ); }
sub state       { $_[0]->_get_set( 'state',       @_ ); }

1;
