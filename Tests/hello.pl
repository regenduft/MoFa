#!/usr/bin/perl
use lib('/gu2/jostock/perl/');

use strict;
use warnings;

use CGI qw(:standard card Do go setvar postfield anchor input);
use CGI::Carp qw(fatalsToBrowser);
use DBI;

my $dbh = DBI->connect( 'dbi:SQLite:dbname=/gu2/jostock/data/dbfile.db',
    '', '', { RaiseError => 0, AutoCommit => 1 } )
    or exiterr("Cannot connect: $DBI::errstr");

#------------ Main Method ---------------#

if ( defined( param('make_new_tables') ) and defined( param('ropsa1982') ) ) {
    if (    ( param('make_new_tables') eq 'true' )
        and ( param('password') eq 'ropsa1982' ) )
    {
        my $i = 0;
        sendwml(
            card(
                p(  br(),
                    map {
                        $i++;
                        if ( $i % 3 == 1 ) {
                            "Create table " . ( $i + 2 ) / 3 . "  ( $_";
                        }
                        elsif ( $i % 3 == 2 ) { "): $_ <br />"; }
                        else { "$_ <br /> <br />"; }
                        } create_tables(),
                    br(),
                    br(),
                    anchor(
                        'Zurück zum Index',
                        go( { -href => 'hello.pl' } )
                    )
                )
            )
        );
        exit(0);
    }
}

sendwml(
    card(
        { -title => 'MObile MitFAhrzentrale', -id => 'index' },
        p(  { -align => 'center' },
            'Datenbankverwaltung', br(),
            a( { -href => '#Tabellen' }, 'Tabellen neu anlegen' )
        )
    ),
    card(
        { -title => 'MObile MitFAhrzentrale', -id => 'Tabellen' },
        p(  { -align => 'left' },
            'Geben Sie das Passwort ein, um die Tabellen anzulegen:',
            br(),
            input(
                {   -title => 'Passwort',
                    -name  => 'password',
                    -type  => 'password'
                }
            ),
            br(),
            'Dieser Vorgang sollte nur einmalig nach der Installation der Mitfahrzentrale durchgefuehrt werden!',
            br(),
            anchor(
                'Passwort abschicken und Tabellen JETZT anlegen',
                go( { -href => 'hello.pl', -method => 'POST' },
                    postfield(
                        { -name => 'make_new_tables', -value => 'true' }
                    ),
                    postfield(
                        { -name => 'password', -value => '$password' }
                    )
                )
            )
        )
    )
);

#------------- Functions -------------------#
sub exiterr {
    sendwml(
        card(
            { -title => 'Fehler', -id => 'index' },
            p(  join(@_),
                br(),
                a(  { -href => 'http://trip261.wohnheim.uni-kl.de' },
                    'Zurueck zum Index'
                )
            )
        )
    );

}

sub sendwml {
    print( wml_header(), start_wml(), join( "\n", @_ ), end_wml() );
}

sub wml_header {
    return header( { -type => 'text/vnd.wap.wml' } );
}

sub start_wml {
    return (
        '<?xml version="1.0"?>
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN"
"http://www.wapforum.org/DTD/wml_1.1.xml">

<wml>
'
    );
}

sub end_wml {
    return ( '
</wml>
' );
}

sub create_tables {
    my @retvals;
    push( @retvals, 'Person' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Person 
(
	Login VARCHAR ( 0 ) NOT NULL,
	Passwort VARCHAR ( 0 ),
	Typ INTEGER,
	Nachname VARCHAR ( 0 ),
	Vorname VARCHAR ( 0 ),
	Strasse VARCHAR ( 0 ),
	PLZ VARCHAR ( 0 ),
	Ort VARCHAR ( 0 ),
	Geburtsdatum DATE,
	KtoInhaber VARCHAR ( 0 ),
	BLZ VARCHAR ( 0 ),
	KtnNr VARCHAR ( 0 ),
	PRIMARY KEY ( Login )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Treffpunkt' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Treffpunkt 
(
	Name VARCHAR ( 0 ) NOT NULL,
	Breite INTEGER,
	Laenge INTEGER,
	Beschreibung VARCHAR ( 0 ),
	PRIMARY KEY ( Name )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Mitfahrgelegenheit' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Mitfahrgelegenheit 
(
	Nr INTEGER NOT NULL,
   Login VARCHAR(0), 
   von VARCHAR(0),
   nach VARCHAR(0), 
	Typ INTEGER,
   Tag1 DATE,
	Zeit1 TIME,
	Tag2 DATE
	Zeit2 TIME,
	Mitfahrer INTEGER,
	Preis INTEGER,
	FOREIGN KEY ( Login ) REFERENCES Person,
	FOREIGN KEY ( von ) REFERENCES Treffpunkt,
	FOREIGN KEY ( nach ) REFERENCES Treffpunkt,
	PRIMARY KEY ( Nr )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'ist_oft_bei' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE ist_oft_bei 
(
	Id INTEGER NOT NULL,
	Login VARCHAR ( 0 ),
	Name VARCHAR ( 0 ),
	FOREIGN KEY ( Login ) REFERENCES Person,
	FOREIGN KEY ( Name ) REFERENCES Treffpunkt,
	PRIMARY KEY ( Id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'bewertet' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE bewertet 
(
	Id INTEGER NOT NULL,
	Login VARCHAR ( 0 ),
	Nr INTEGER,
	Punkte INTEGER,
	Kommentar VARCHAR ( 0 ),
	Antwort VARCHAR ( 0 ),
	FOREIGN KEY ( Login ) REFERENCES Person,
	FOREIGN KEY ( Nr ) REFERENCES Mitfahrgelegenheit,
	PRIMARY KEY ( Id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'merkt' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE merkt 
(
	Id INTEGER NOT NULL,
	Login VARCHAR ( 0 ),
	Nr INTEGER,
	FOREIGN KEY ( Login ) REFERENCES Person,
	FOREIGN KEY ( Nr ) REFERENCES Mitfahrgelegenheit,
	PRIMARY KEY ( Id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'nutzt' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE nutzt 
(
	Id INTEGER NOT NULL,
	Login VARCHAR ( 0 ),
	Nr INTEGER,
	FOREIGN KEY ( Login ) REFERENCES Person,
	FOREIGN KEY ( Nr ) REFERENCES Mitfahrgelegenheit,
	PRIMARY KEY ( Id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    return (@retvals);
}
