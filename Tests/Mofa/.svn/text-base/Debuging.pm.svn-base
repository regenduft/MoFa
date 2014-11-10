package Mofa::Debuging;

use strict;
use warnings;

use lib('..');
my($home) = '/home/flo/workspace/MoFa/';

use DBI;

sub connect_db {
    my $dbh = DBI->connect( 'dbi:SQLite:dbname=' . $home . 'data/dbfile.db',
        '', '', { RaiseError => 1, AutoCommit => 1 } )
        or die("Cannot connect: $DBI::errstr");
    return $dbh;
}

sub connect_old {
    my $dbh = DBI->connect( 'dbi:SQLite:dbname=' . $home . 'data/old.db',
        '', '', { RaiseError => 1, AutoCommit => 1 } )
        or die("Cannot connect: $DBI::errstr");
    return $dbh;
}


sub cp2 {
    use Mofa::Model;
    my @return;
    my $old = Mofa::Model::connect_old();
    my $ids = Mofa::MeetingPt->get_ids($old);
    my @ids = @{$ids};
    foreach my $id (@ids) {
        my $pt = Mofa::MeetingPt->get( $id, $old );
        $pt->id(undef);
        $pt->add();
        print $pt->id(), $pt->name(), "\n";
    }

    #return @return;
}

sub cp {
    use Mofa::Model;
    my @return;
    my $old = Mofa::Model::connect_old();
    my $ids = Mofa::Address->get_ids();
    my @ids = @{$ids};
    foreach my $id (@ids) {
        if ( $id > 3140 ) {
            my $pt = Mofa::MeetingPt->get($id);

            #$pt->{id} = undef;
            #$pt->add();
            print join( ';  ',
                $pt->id(), $pt->name(), $pt->description(), "\n" );
        }
    }

    #return @return;
}

sub create_tables_manual {
    my ($dbh) = connect_db();
    my @retvals;
    push( @retvals, 'Meetingpt' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Meetingpt 
(
	id INTEGER NOT NULL,
	name TEXT,
	utm_x INTEGER,
	utm_y INTEGER,
	utm_e INTEGER,
	utm_n TEXT,
	description TEXT,
	street TEXT,
	nr INTEGER,
	city TEXT,
	zip TEXT,
	region TEXT,
	district TEXT,
	state TEXT,
	PRIMARY KEY ( id )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Person' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Person 
(
	id TEXT NOT NULL,
	password TEXT,
	type INTEGER,
	name TEXT,
	prename TEXT,
	address INTEGER,
	bday INTEGER,
	cellular TEXT,
	msisdn TEXT,
	banking_name TEXT,
	bank_code TEXT,
	account_nr TEXT,
	PRIMARY KEY ( id ),
	FOREIGN KEY ( address ) REFERENCES Meetingpt
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Lift_offer' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Lift_offer
(
	id INTEGER NOT NULL,
   provider TEXT, 
   start INTEGER,
   destination INTEGER, 
	startTime INTEGER,
	arrivalTime INTEGER,
	timeAccuracy INTEGER,
	seats INTEGER,
	fee INTEGER,
	FOREIGN KEY ( provider ) REFERENCES Person,
	FOREIGN KEY ( start ) REFERENCES Meetingpt,
	FOREIGN KEY ( destination ) REFERENCES Meetingpt,
	PRIMARY KEY ( id )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Lift_request' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Lift_request
(
	id INTEGER NOT NULL,
   requester TEXT, 
   start INTEGER,
   destination INTEGER, 
	startTime INTEGER,
	arrivalTime INTEGER,
	timeAccuracy INTEGER,
	seats INTEGER,
	fee INTEGER,
	negotiated_to INTEGER,
	FOREIGN KEY ( requester ) REFERENCES Person,
	FOREIGN KEY ( start ) REFERENCES Meetingpt,
	FOREIGN KEY ( destination ) REFERENCES Meetingpt,
	FOREIGN KEY ( negotiated_to) REFERENCES Lift_offer,
	PRIMARY KEY ( id )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Visits' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Visits 
(
	id INTEGER NOT NULL,
	person TEXT,
	place INTEGER,
	FOREIGN KEY ( person ) REFERENCES Person,
	FOREIGN KEY ( place ) REFERENCES Meetingpt,
	PRIMARY KEY ( id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Rating' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Rating 
(
	id INTEGER NOT NULL,
	request INTEGER,
	offer INTEGER,
	pts_by_requester INTEGER,
	pts_by_provider INTEGER,
	comment_by_requester TEXT,
	comment_by_provider TEXT,
	answer_by_requester TEXT,
	answer_by_provider TEXT,
	FOREIGN KEY ( offer ) REFERENCES Lift_offer,
	FOREIGN KEY ( request ) REFERENCES Lift_request,
	PRIMARY KEY ( id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'mark' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Mark 
(
	id INTEGER NOT NULL,
	person TEXT,
	offer INTEGER,
	FOREIGN KEY ( person ) REFERENCES Person,
	FOREIGN KEY ( offer ) REFERENCES Lift_offer,
	PRIMARY KEY ( id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    push( @retvals, 'Mapped' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Mapped 
(
	id INTEGER NOT NULL,
	offer INTEGER,
	request INTEGER,
	accepted INTEGER,
	FOREIGN KEY ( offer ) REFERENCES Lift_offer,
	FOREIGN KEY ( request ) REFERENCES Lift_Request,
	PRIMARY KEY ( id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );
    push( @retvals, create_distance_table($dbh) );

    return (@retvals);
}

sub create_additional_tables {
    my $dbh = shift;
    my @retvals;
    push( @retvals, 'Distance' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Distance 
(
	id INTEGER NOT NULL,
	start INTEGER,
	destination INTEGER,
	distance INTEGER,
	FOREIGN KEY ( start ) REFERENCES Meetingpt,
	FOREIGN KEY ( destination ) REFERENCES Meetingpt,
	PRIMARY KEY ( id )			
)'
        )
    );
    push( @retvals, $dbh->errstr() );
    push( @retvals, 'Geocode' );
    push(
        @retvals,
        $dbh->do(
            'CREATE TABLE Geocode 
(
	id INTEGER NOT NULL,
	query TEXT,
	point INTEGER,
	accuracy INTEGER,
	FOREIGN KEY ( point ) REFERENCES Meetingpt,	
	PRIMARY KEY ( id )
)'
        )
    );
    push( @retvals, $dbh->errstr() );

    return (@retvals);
}