#!/usr/in/perl

use warnings;
use strict;

use lib('../');
use Mofa::Controller;
#use Mofa::Cities;
use Mofa::Model;
use Mofa::MeetingPt;

my $dbh = Mofa::Model::connect_db();
my $i   = 1;
foreach my $city (@Mofa::Cities::cities) {
    $city =~ s/\/.*$//;
    $city =~ s/�/Ae/g;
    $city =~ s/�/ae/g;
    $city =~ s/�/Oe/g;
    $city =~ s/�/oe/g;
    $city =~ s/�/Ue/g;
    $city =~ s/�/ue/g;
    $city =~ s/�/ss/g;
    my @hits = eval { Mofa::Controller::geocode( $city . '+DE' ) };
    print "\n\n\n" . $i++ . ": $city\n";
    my $j = 1;

    foreach my $hit (@hits) {
        if ( defined( $hit->{city} ) and not $hit->{city} eq '' ) {
            my $desc = $hit->{description};
            $desc =~ s/^(\w*)\s.*/$1/;
            $city =~ s/^(\w*)\+.*/$1/;
            if ( $desc eq $city ) {
                bless( $hit, 'Mofa::MeetingPt' );
                if ( defined( $hit->{region} ) and not $hit->{region} eq '' )
                {
                    $hit->{name} = $hit->{city} . " (" . $hit->{region} . ")";
                }
                else { $hit->{name} = $hit->{city} . " (Deutschland)"; }
                eval { $hit->add($dbh); };
                print $hit->{name} . "wird hinzugef�gt (" . $j++ . "); ";
            }
        }
    }
}

