#!/usr/bin/perl
use warnings;
use strict;

use lib('../');
use Mofa::Debuging;
use Mofa::Controller;
my $description = "Stelzenberg";
my @aa          = geocode($description);
my $key;
my $value;

#while (($key,$value) = each(%{$a[0]})) {
#print $key, "  ", $value, "\n";
#}
for (@aa) {
    print ${$_}{accuracy}, "\n";
}

