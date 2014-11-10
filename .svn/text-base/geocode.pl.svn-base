#!/usr/bin/perl

use warnings;
use strict;

use Mofa::View;
use Mofa::Controller;
use Mofa::Model::CircularArea;
use Mofa::Model::Geocode;

my $p_start = myparam('start');
my $p_dest  = myparam('dest');

if ( not defined($p_start) or $p_start eq '' ) {
    $p_start = $session->param('open_geocode_start');
}
if ( not defined($p_dest) or $p_dest eq '' ) {
    $p_dest = $session->param('open_geocode_dest');
}

if (   not defined($p_start)
    or $p_start eq ''
    or not defined($p_dest)
    or $p_dest eq '' )
{
    display_err('Start oder Ziel nicht angegeben!');
    exit;
}

my @start = Mofa::Controller::str2points($p_start);
my @dest  = Mofa::Controller::str2points($p_dest);

if ( scalar(@start) == 1 and scalar(@dest) == 1 ) {
    ## falls beide eindeutig sind, ist endlich das geocoding abgeschlossen
    ## Nun muss evtl noch ein passender Treffpunkt in der Naehe des
    ## Ortes der gefunden wurde festgelegt werden...
    my ( $start, $dest ) = ( $start[0], $dest[0] );
    my ( $sutm_x, $sutm_y, $sutm_n, $sutm_e ) = $start->utm();
    my $s_area = Mofa::Model::CircularArea->new(
        {   utm_x      => $sutm_x,
            utm_y      => $sutm_y,
            utm_n      => $sutm_n,
            utm_e      => $sutm_e,
            startAngle => 0,
            stopAngle  => 0,
            inRadius   => 0,
            outRadius  => 600
        }
    );
    my ( $dutm_x, $dutm_y, $dutm_n, $dutm_e ) = $dest->utm();
    my $d_area = Mofa::Model::CircularArea->new(
        {   utm_x      => $dutm_x,
            utm_y      => $dutm_y,
            utm_n      => $dutm_n,
            utm_e      => $dutm_e,
            startAngle => 0,
            stopAngle  => 0,
            inRadius   => 0,
            outRadius  => 600
        }
    );
    my $startpts = Mofa::Model::MeetingPt->get_points_in_area( $s_area, 0 );
    my $destpts  = Mofa::Model::MeetingPt->get_points_in_area( $d_area, 0 );
    my ( @startpts, @destpts );

    if (   not defined($startpts)
        or not ref($startpts)
        or scalar( %{$startpts} ) <= 0 )
    {
        bless($start, "Mofa::Model::MeetingPt");
        $start->name($start->description() . ' *');
        $start->update( 'id', 'name' );
        @startpts = ($start);
    }
    else {
        while ( my ( $key, $val ) = each( %{$startpts} ) ) {
            push( @startpts, Mofa::Model::MeetingPt->get($key) );
        }
    }
    if (   not defined($destpts)
        or not ref($destpts)
        or scalar( %{$destpts} ) <= 0 )
    {
        bless($dest, "Mofa::Model::MeetingPt");
        $dest->name($dest->description() . ' *');
        $dest->update( 'id', 'name' );
        @destpts = ($dest);
    }
    else {
        while ( my ( $key, $val ) = each( %{$destpts} ) ) {
            push( @destpts, Mofa::Model::MeetingPt->get($key) );
        }
    }
    Mofa::View::display_search_form( \@startpts, \@destpts, 'search.pl' );
}
else {

#print "Content-type: text/plain\n\n".scalar(@start)."$p_start\n".join("\n",Mofa::Model::Geocode->getquerys());
    Mofa::View::display_search_form( \@start, \@dest, 'geocode.pl' );
}

