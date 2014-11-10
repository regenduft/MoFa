#!/usr/bin/perl

use strict;
use warnings;

use CGI;

our ($wml) = CGI->new();
my $pos_request = join( ' ',
    '<?xml version = "1.0" ?>',
    '<!DOCTYPE invocation PUBLIC "-//WAPFORUM//DTD LOC INV 1.0//EN" "http://www.wapforum.org/DTD/loc/invocation-1.0.dtd">',
    '<invocation>',
    '<attachment-request>',
    '<application>ACME Driving Directions</application>',
    '</attachment-request>',
    '</invocation>' );

open BLA, '>>/home/flo/data/bla.log';
foreach my $p ( sort keys %ENV ) {
    if ( substr( $p, 0, 4 ) eq 'HTTP' ) { print BLA "$p=$ENV{$p}\n"; }
}
print BLA "\n\n";
close BLA;

print 'X-Wap-Loc-Invocation: ' . $pos_request . '
Content-Type: text/vnd.wap.wml

<?xml version="1.0"?>
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.1//EN"
  "http://www.wapforum.org/DTD/wml_1.1.xml">
<wml>
  <card title="hello"><p>';

print 'test</p></card>
</wml>
';

