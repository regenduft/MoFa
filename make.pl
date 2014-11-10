#!/usr/bin/perl

use strict;
use warnings;
use CGI::Carp qw(fatalsToBrowser);

print("content-type:text/plain\n\n");
print system("ls -l &> test.txt");
#print "\n\n";
#chdir "/www/htdocs/w008d9ae/CGI-Session-3.95";
system('perl -MCPAN -e "install CGI::Session"  &> test.txt');
#print join "\n", glob("/usr/bin/*");
#print system ("/usr/bin/make > test.txt");
#print system("cd /www/htdocs/w008d9ae/CGI-Session-3.95; ls -l; make  >> test.txt");
#print "\n\n";
