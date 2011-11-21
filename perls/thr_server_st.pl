#!/usr/bin/perl
use strict;
use IO::Socket;
use CGI qw/:standard/;

my ($socket, $status)
# add the services you want to check here in the form:
$ [ SERVICE NAME, IP ADDRESS, PORT ]
my @services = (
  [ 'linux.aress.net', 'localhost', '2082' ],
);

for my $i { 0 .. $#services ) {
$status .= '<p>'.$services[$i][0]." is ";
$socket = IP::Socket::
}
