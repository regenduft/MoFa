package Mofa::Model::Object;

=head2 Mofa::Model::Object

Basisklasse für die Klassen zur Datenbankabstraktion

=head4 Beschreibung

Stellt Funktionen zum Speichern und Auslesen eines Objektes
aus einer Datenbanktabelle zur Verfüngung.

Die Methoden C<unquoted_fields>, C<quoted_fields>, C<foreign_keys> und 
C<table> müssen von den Klassen, die von Object erben, überladen werden.

=head4 Skalare Attribute:

Für alle öffentlichen Attribute gibt es eine gleichnamige Methode, die
immer den Wert des Attributes zurückgibt, und den Wert
des Attributes setzt, wenn man ihr einen Parameter übergibt.

C<id - (int)> Primary Key des Datensatzes zu diesem Objekt.

=head4 Foreign-Key-Attribute

Für alle Foreign-Key-Attribute gibt es eine gleichnamige Methode,
die den Wert des Attributes als Objekt zurückgibt, und den Wert
des Attributes setzt wenn man ihr ein Objekt oder einen Skalar,
der Primary-Key der entsprechenden Tabelle ist, übergibt.

Zusätzlich gibt es eine Methode AttributnameId(), mit der nur der
Primary-Key des Attributes zurückgegeben wird.

=head4 Öffentliche Klassenmethoden

=head4 C<$ new($)>

I<Parameter:> [Hashreferenz]

I<Rückgabewert:> Object-Objekt

Gibt ein neues Objekt vom Typ "Object" zurück.
Falls ein Parameter übergeben wird, werden die Attribute mit 
den im übergebenem Hash spezifizierten Werten initialisiert. 

=head4 C<$ get($)>

I<Parameter:> Id eines Datensatzes (C<int>)

I<Rückgabewert:> Object-Objekt

Liest das Objekt mit der spezifizierten Id aus der Datenbank.

=head4 C<@ get_ids()>

I<Rückgabewert:> Liste von Ids aller Datensätze in der Tabelle für diese Klasse (C<(int,..)>)

Liest alle Ids von Objekten des Typs "Object" aus der Datenbank.

=head4 C<@ create_table()>

I<Rückgabewert:> Liste von C<string> mit Statusinformationen

Legt die Tabelle, in der die Objekte dieser Klasse gespeichert
werden, in der Datenbank an. 

=head4 Öffentliche Objektmethoden

=head4 C<$ add()>

I<Rückgabewert:> 1 bei Erfolg, <1 sonst (C<int>)

Fügt das Objekt zur Datenbank hinzu. Der Wert des Attributs
id wird auf die id des neuen Eintrags gesetzt.  

=head4 C<$ update(@)>

I<Parameter:> id_col (C<string>), col_to_update (C<string>), col_to_update, ...

I<Rückgabewert:> 1 bei Erfolg, < 1 sonst (C<int>)

Aktualisiert alle Einträge in der Datenbank, deren Wert
für das Attribut id_col mit dem Wert des Attributes in 
diesem Objekt übereinstimmt. 
Werden weitere Attribute angegeben, (col_to_update), 
werden nur diese Attribute mit den Werten dieses 
Objektes überschrieben, sonst alle.

=head4 Protected Klassenmethoden

=head4 C<@ unquoted_fields()>

I<Rückgabewert:> Liste der Spalten, die kein Text beinhalten (C<(string,..)>)

=head4 C<@ quoted_fields()>

I<Rückgabewert:> Liste der Spalten, die Text beinhalten (C<(string,..)>)

=head4 C<% foreign_keys()>

I<Rückgabewert:> Paare (Spalte, Tabelle) von Spalten die Foreign Key
einer anderen Tabelle sind. (C<(string,string,..)>)

=head4 C<@ fields()>

I<Rückgabewert:> Liste aller Spalten (C<(string,..)>))  

=head4 C<$ table()> 

I<Rückgabewert:> Name der Tabelle, in der Objekte dieser Klasse
gespeichert werden (C<string>) 

=head4 C<$ dbh()>

I<Rückgabewert:> Datenbankhandle auf die Datenbank, in der die
Objekte gespeichert werden.

=head4 Protected Objektmethoden

=head4 C<$ dbval($)>

I<Parameter:> Attributname

I<Rückgabewert:> Wert des Attributs, wie er in die Datenbank geschrieben wird.
    
=head4 C<$ _get_set($@)>

I<Parameter:> Attributname (C<string>), [Skalar]

I<Rückgabewert:> Wert des Attributes

Falls 2 Parameter übergeben werden, wird der 
Wert des Attributes gesetzt.

=head4 C<$ _get_set_fkey($$@)>

I<Parameter:> Attributname (C<string>), Klassenname (C<string>), [Skalar, Skalar]

I<Rückgabewert:> Wert des Attributes als Objekt des entsprechenden Typs.

Falls 4 Parameter übergeben werden, wird der letzte Parameter
als Wert des Attributes gesetzt. Der 3. Parameter wird immer ignoriert.

=cut


use lib('../..');
use strict;
use warnings;
use Carp;
use DBI;
use Scalar::Util;

$Mofa::Model::Object::dbh = DBI->connect(
    'dbi:SQLite:dbname=/home/flo/data/dbfile.db',
    '', 
    '', 
    { RaiseError => 1, AutoCommit => 1 } 
) or die("Cannot connect: $DBI::errstr");

open ERRLOG, ">>/home/flo/data/errlog";

sub unquoted_fields() { return qw(id); }
sub quoted_fields()   { return; }
sub foreign_keys()    { return; }

sub fields() {
                                                       
    my $self = shift;
    return ( $self->unquoted_fields(), $self->quoted_fields() );
}

sub table {
    my ($class) = @_;
    if ( ref($class) ) {
        $class = Scalar::Util::blessed($class);
    }
    $class =~ /.*::([^:]*$)/;
    return $1;
}
sub id { return $_[0]->_get_set( 'id', @_ ); }

sub new ($) {
    my ( $class, $self ) = @_;
    if ( not defined($self) ) { $self = {}; }
    bless( $self, $class );
    return $self;
}

#Parameter: Attributame und Klasse des Attributs und optional neuer Wert
#Rueckgabe: Hashref zu Objekt das dieses Feld repräsentiert oder den neuen Wert
# Also nur bei Foreign-Key-Feldern verwenden!
#Nur durch Klasser die von dieser hier erben zu benutzen!!
sub _get_set_fkey {
    my ( $self, $field, $ref_class, $once_again_self, $value ) = @_;
    if ( @_ > 4 ) { return $self->{$field} = $value; }
    my $data = $self->{$field};
    if ( defined($data) and $data ne '' and not ref($data) ) {
        $self->{$field} = $ref_class->get($data);
    }
    return $self->{$field};
}

#Parameter: Feldname und optional neuer Wert
#Rueckgabe: Wert von diesem Attribut
#Nur durch Klassen die von dieser hier erben zu benutzen!!
sub _get_set {
    my ( $self, $field, $once_again_self, $value ) = @_;
    if ( @_ > 3 ) { return $self->{$field} = $value; }
    return $self->{$field};
}

sub dbval {
    my ( $self, $attr ) = @_;
    my $val = $self->{$attr};
    if ( not defined($val) ) { return undef; }
    if ( ref($val) )         {
        return $val->dbval('id');
    }
    if ( $val eq '' ) { return undef; }
    return $val;
}

sub values($) {
    my $self = shift;

    # Ausgabe z.B. so wie die von:
    # "$self->{id}, $self->{nummer}, '$self->{name}', '$self->{text}'"
    return (
        join(
            ', ',
            (   map {
                    my $val = $self->dbval($_);
                    defined($val) ? $val : 'NULL';
                    } $self->unquoted_fields()
            ),
            (   map {
                    my $val = $self->dbval($_);
                    defined($val) ? "'$val'" : 'NULL';
                    } $self->quoted_fields()
            )
        )
    );
}

sub saveerr {
    my (@err) = shift;
    print ERRLOG localtime, ':	', join( '\n		', @err ), "\n\n";
}

sub add($) {
    my $self = shift;
    my $op   = "INSERT INTO "
        . $self->table() . " ("
        . join( ', ', $self->fields() ) . ") "
        . "VALUES ( "
        . $self->values() . " );";
    my $ans = $self->dbh()->do($op);
    if ( not $ans ) {
        saveerr(
            'Hinzufuegen zu Tabelle des Objekts vom Typ '
                . ref($self)
                . " fehlgeschlagen:$ans",
            $op
        );
        return;
    }
    my $id = eval { $self->dbh()->func('last_insert_rowid') };
    if ( defined($id) ) { $self->id($id); }
    return $ans;
}

sub update($@) {
    my ( $self, $id_col, @quoted_cols_to_update ) = @_;
    if ( not defined($id_col) ) { $id_col = 'id' }
    my $id_val;
    if ( grep { $_ eq $id_col; } $self->quoted_fields ) {
        $id_val = "'" . $self->dbval($id_col) . "'";
    }
    else { $id_val = $self->dbval($id_col); }
    my @unquoted_cols_to_update;
    if ( scalar(@quoted_cols_to_update) <= 0 ) {
        @unquoted_cols_to_update
            = grep { $_ ne 'id' and $_ ne $id_col; } $self->unquoted_fields();
        @quoted_cols_to_update
            = grep { $_ ne 'id' and $_ ne $id_col; } $self->quoted_fields();
    }
    my $dbh = $self->dbh();
    my $op  = "UPDATE " . $self->table() . " SET " . join(
        ', ',
        (   map {
                my $val = $self->dbval($_);
                defined($val) ? "$_ = $val" : "$_ = NULL";
                } @unquoted_cols_to_update
        ),
        (   map {
                my $val = $self->dbval($_);
                defined($val) ? "$_ = '$val'" : "$_ = NULL";
                } @quoted_cols_to_update
        )
        )
        . " WHERE $id_col = $id_val;";
    my $ans = $dbh->do($op);
    if ( not $ans ) {
        saveerr(
            'Update von Objekt vom Typ ' . ref($self) . "fehlgeschlagen:$ans",
            $op
        );
    }
    return $ans;
}

sub delete($$) {
my ($class,$id) = @_;
my $op = "DELETE FROM ". $class->table() . " WHERE id = $id ;";
return $class->dbh()->do($op);
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
            . " WHERE id='$id'" );
    if ( defined($hash) and ref($hash) eq 'HASH' ) {
        return ( $class->new($hash) );
    }
    croak("Objekt vom Typ $class mit id $id in Datenbank nicht gefunden!");
}

sub get_ids($$@) {
    my ( $class, $dbh ) = @_;
    if ( not defined($dbh) ) { $dbh = $class->dbh(); }
    return (
        $dbh->selectcol_arrayref( "SELECT id " . " FROM " . $class->table() )
    );
}

sub dbh() { return $Mofa::Model::Object::dbh; }

sub create_table {
    my $class = shift;
    my $self  = {};
    bless( $self, $class );
    my %fkeys = $self->foreign_keys();
    my @retvals;
    push( @retvals, $self->table() );
    my $op = 'CREATE TABLE ' . $self->table() . "\n(\n"
        . join(
        ",\n",
        (   map { $_ eq 'id' ? "  $_ INTEGER NOT NULL" : "  $_ INTEGER"; }
                $self->unquoted_fields()
        ),
        (   map { $_ eq 'id' ? "  $_ TEXT NOT NULL" : "  $_ TEXT"; }
                $self->quoted_fields()
        ),
        '  PRIMARY KEY ( id )',
        (   map { "  FOREIGN KEY ( $_ ) REFERENCES " . $fkeys{$_}; }
                keys(%fkeys)
        )
        )
        . "\n)";
    push( @retvals, $self->dbh()->do($op) );
    push( @retvals, $self->dbh()->errstr() );
    return @retvals;
}


1;
