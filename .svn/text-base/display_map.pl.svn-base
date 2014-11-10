#!/usr/bin/perl

use strict;
use warnings;

use Mofa::View;
use Mofa::Controller;
use Mofa::Model::Point;

my ( $x, $y ) = (
    myparam('x'),      myparam('y'),
    myparam('radius'), myparam('width'),
    myparam('height')
);
my ( $rad, $width, $height )
    = ( myparam('radius'), myparam('width'), myparam('height') );

if ( not( defined($x) and defined($y) ) ) {
    if ( not( defined( myparam('utm_x') ) and defined( myparam('utm_y') ) ) )
    {
        display_err('Keine Koordinaten uebermittelt');
        exit;
    }
    else {
        my $pt = Mofa::Model::Point->new(
            { utm_x => myparam('utm_x'), utm_y => myparam('utm_y') } );
        ( $x, $y ) = $pt->ll();
    }
}
if ( not defined($rad) )    { $rad    = 0.4; }
if ( not defined($width) )  { $width  = 125 }
if ( not defined($height) ) { $height = 220; }

my $img_link = Mofa::Controller::get_map_img( $x, $y, $rad, $width, $height );
Mofa::View::display_map( $img_link, $x, $y, $rad, $width, $height );

