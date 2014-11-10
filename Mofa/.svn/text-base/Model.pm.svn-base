package Mofa::Model;

use strict;
use warnings;
use lib('..');

use Mofa::Model::Object;

use Mofa::Model::MeetingPt;
use Mofa::Model::Person;
use Mofa::Model::Offer;
use Mofa::Model::Request;
use Mofa::Model::Mapped;
use Mofa::Model::Distance;
use Mofa::Model::Geocode;

sub create_tables {
    return 
        Mofa::Model::MeetingPt->create_table(), "\n\n",
        Mofa::Model::Person->create_table(), "\n\n",
        Mofa::Model::Offer->create_table(), "\n\n", 
        Mofa::Model::Request->create_table(), "\n\n",
        #Mofa::Model::Visits->create_table(), "\n\n", 
        #Mofa::Model::Mark->create_table(),"\n\n", 
        Mofa::Model::Mapped->create_table(), "\n\n",
        Mofa::Model::Distance->create_table(), "\n\n", 
        Mofa::Model::Geocode->create_table(),"\n\n",
        #Mofa::Model::Rating->create_table(), "\n\n",
    ;
}

1;
