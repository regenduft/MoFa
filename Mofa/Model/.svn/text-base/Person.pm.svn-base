package Mofa::Model::Person;

=head2 Mofa::Model::Person

Personen mit Accounts, die Angebote und Gesuche in die Mitfahrzentrale
einstellen können.
Erbt von: C<Mofa::Model::Object>.  

=head4 Skalare Attribute

C<type (int)           > - Typ - ob nur Gesuche, nur Angebote, oder beides

C<bday (int)           > - Geburtsdatum

C<id (string)          > - (Statt Id (Int) wie Mofa::Model::Object): Login
 
C<password (string)    > - Password

C<name (string)        > - Name
 
C<prename (string)     > - Vorname

C<cellular (string)    > - Handynummer (an die SMS-Benachrichtungen gesendet werden)

C<msisdn (string)      > - ID, mit der das Handy identifiziert wird, wenn es lokalisiert werden soll.

C<banking_name (string)> - Kontoinhaber

C<bank_code (string)   > - BLZ

C<account_nr (string)  > - Kontonummer

=head4 Foreign-Key-Attribute

C<address (Mofa::Model::Adress)> - Adresse der Person

C<addressId (int)>

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Object;
use Mofa::Model::Address;
@Mofa::Model::Person::ISA = ("Mofa::Model::Object");

sub unquoted_fields() { return qw(type address bday); }

sub quoted_fields() {
    return
        qw(id password name prename cellular msisdn banking_name bank_code account_nr);
}
sub foreign_keys() { return ( address => Mofa::Model::Address->table() ); }

sub address { $_[0]->_get_set_fkey( 'address', 'Mofa::Model::Address', @_ ); }

sub addressId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('address');
}
sub type         { $_[0]->_get_set( 'type',         @_ ); }
sub bday         { $_[0]->_get_set( 'bday',         @_ ); }
sub password     { $_[0]->_get_set( 'password',     @_ ); }
sub name         { $_[0]->_get_set( 'name',         @_ ); }
sub prename      { $_[0]->_get_set( 'prename',      @_ ); }
sub cellular     { $_[0]->_get_set( 'cellular',     @_ ); }
sub msisdn       { $_[0]->_get_set( 'msisdn',       @_ ); }
sub banking_name { $_[0]->_get_set( 'banking_name', @_ ); }
sub bank_code    { $_[0]->_get_set( 'bank_code',    @_ ); }
sub account_nr   { $_[0]->_get_set( 'account_nr',   @_ ); }

1;

