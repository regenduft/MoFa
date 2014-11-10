package Mofa::Model::Mapped;

=head2 Mofa::Model::Mapped

Mitfahrgelegenheit die gerade vermittelt wird.
Erbt von: C<Mofa::Model::Object>

=head4 Skalare Attribute

C<accepted (int)> - Ist die Vermittlung abgeschlossen?

C<detour (int)  > - Umweg für den Autofahrer in Kilometern.

C<addtime (int) > - Zusätzliche Fahrtzeit für den Autofahrer.
 
=head4 Foreign-Key-Attribute

C<offer (Mofa::Model::Offer)    > - Mitfahrangebot das vermittelt wird.

C<offerId (int)>
 
C<request (Mofa::Model::Request)> - Mitfahrgesuch das vermittelt wird.

C<requestId (int)>
 
=head4 Objektmethoden

=head4 C<$ add()>

I<Rückgabewert:> 1 bei Erfolg, < 1 sonst.

Fügt diesen Mapped-Datensatz zur DB hinzu, falls noch
kein Mapped-Datensatz mit gleichem Anbieter und Mitfahrer
und mit gleichem Ziel und Start vorhanden ist. 
Sonst gibt es -3 zurück und ändert das aktuelle Mapped-Objekt
in das zu dem entsprechenden passenden Datensatz gehörige.

=head4 Klassenmethoden

=head4 C<@ get_by_provider($)>

I<Parameter:>    C<Person>-Objekt
    
I<Rückgabewert:> Liste von Mapped-Objekten mit Angeboten dieser Person

=head4 C<@ get_by_provider($)>

I<Parameter:>    C<Person>-Objekt
    
I<Rückgabewert:> Liste von Mapped-Objekten mit Gesuchen dieser Person
    
=head4 C<$ accept($)>

I<Parameter:> Id eines Mapped-Datensatzes (C<int>)
    
Markiert diesen Mapped-Datensatz in der DB als aktzeptiert

=head4 C<$ deny($)>

I<Parameter:> Id eines Mapped-Datensatzes (C<int>)
    
Markiert diesen Mapped-Datensatz in der DB als abgelehnt
    

=cut

use lib('../..');
use strict;
use warnings;
use Carp;

use Mofa::Model::Object;
use Mofa::Model::Request;
use Mofa::Model::Offer;

@Mofa::Model::Mapped::ISA = ("Mofa::Model::Object");

sub unquoted_fields() { return qw(id offer request accepted detour addtime); }
sub quoted_fields()   { return; }

sub foreign_keys() {
    return ( offer => Mofa::Model::Offer->table(),
        request => Mofa::Model::Request->table() );
}

sub offer { $_[0]->_get_set_fkey( 'offer', 'Mofa::Model::Offer', @_ ); }

sub offerId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('offer');
}
sub request { $_[0]->_get_set_fkey( 'request', 'Mofa::Model::Request', @_ ); }

sub requestId {
    if ( @_ > 1 ) { croak "readonly"; }
    $_[0]->dbval('request');
}
sub accepted { $_[0]->_get_set( 'accepted', @_ ); }
sub detour   { $_[0]->_get_set( 'detour',   @_ ); }
sub addtime  { $_[0]->_get_set( 'addtime',  @_ ); }

sub get_by_provider($$@) {
    my ( $class, $person, $state ) = @_;
    return $class->_get_by_person( $person, 'O.provider', $state );
}

sub get_by_requester($$@) {
    my ( $class, $person, $state ) = @_;
    return $class->_get_by_person( $person, 'R.requester', $state );
}

sub _get_by_person($$$) {
    my ( $class, $person, $name, $state ) = @_;
    if ( not defined($state) ) { $state = 'ISNULL'; }
    else { $state = "= $state"; }
    my $op
        = "SELECT M.id AS id, M.offer AS offer, M.request AS request, M.accepted AS accepted, M.detour AS detour, M.addtime AS addtime "
        . "FROM Mapped AS M INNER JOIN Request AS R ON R.id = M.request INNER JOIN Offer AS O ON O.id = M.offer 
		WHERE $name = '$person' And accepted " . $state . ";";
    my $all = $class->dbh()->selectall_arrayref( $op, { Slice => {} } );
    if ( not $all ) { croak $op; }
    my @retval;

    foreach my $hash ( @{$all} ) {
        push( @retval, Mofa::Model::Mapped->new($hash) );
    }
    return (@retval);
}

sub add {
    my ($self)  = @_;
    my $request = $self->dbval('request');
    my $offer   = $self->dbval('offer');
    ## Schauen ob die gleiche Reqeust schonmal gemappt wurde:
    my $op
        = "SELECT id, request, offer FROM Mapped WHERE request = $request And offer = $offer;";
    my $ans = $self->dbh()->selectcol_arrayref($op);
    if ( defined($ans) and ref($ans) and scalar( @{$ans} ) > 0 ) {
        $self = Mofa::Model::Mapped->get( $ans->[0] );
        return -2;
    }
    ## Schauen ob eine Request von gleichem Anfrangendem mit gleichem Start und Ziel schon gemappt wurde:
    $op
        = "SELECT M.id AS id, M.offer AS offer, M.accepted AS accepted, R.requester AS requester, R.start AS start, R.destination AS destination "
        . "FROM Mapped AS M INNER JOIN Request AS R ON M.request = R.id "
        . "WHERE requester = '"
        . $self->request()->dbval('requester')
        . "' And start = "
        . $self->request()->dbval('start')
        . " And destination = "
        . $self->request()->dbval('destination')
        . " And M.offer = $offer;";
    $ans = $self->dbh()->selectcol_arrayref($op);
    if ( defined($ans) and ref($ans) and scalar( @{$ans} ) > 0 ) {
        $self = Mofa::Model::Mapped->get( $ans->[0] );
        return -3;
    }
    return $self->SUPER::add();
}

sub deny {
    my ( $class, $id ) = @_;
    my $self = $class->new( { id => $id, accepted => -1 } );
    return $self->update( 'id', 'accepted' );
}

sub accept {
    my ( $class, $id ) = @_;
    my $self = $class->new( { id => $id, accepted => 1 } );
    return $self->update( 'id', 'accepted' );
}

1;
