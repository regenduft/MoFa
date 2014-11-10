#!/usr/bin/perl

use lib('..');
use Mofa::Model::Request; 
use Mofa::Model::Offer;

foreach my $i (0..500) {
#Mofa::Model::Request->delete($i);
Mofa::Model::Offer->delete($i);
#Mofa::Model::Mapped->delete($i);
}

